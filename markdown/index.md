---
title: 'Curve Systems [WIP]'
subtitle: 'Analysis for Use in Programmable Motion'
author:
- Alex Striff
date: 2017-07-21
---

Abstract
========

The process used to program object trajectories in computer game scripting
engines such as [Danmakufu Ph3][] is to update object positions, velocities,
accelerations, or angular variants over time to create complex motion. For
example, an object created with $a = \alpha = 0$ and $v$ and $\omega$ nonzero
will travel in an Archimedean spiral.

![Archimedian Spiral][aspiral]\ 

In general for this system, interesting shapes are obtained by setting initial
positions of objects along some curve, and making the objects move in a
direction that is often related to the curve. Objects created along the curve

$$
\begin{bmatrix}
x \\
y
\end{bmatrix} =
\begin{bmatrix}
r\cos u \\
r\sin u
\end{bmatrix},
$$

for $u \in [0, 2\pi]$ and $\theta_0 = \frac{y(u)}{x(u)} - \pi$, with $\alpha = a
= \omega = 0$ and $v > 0$ will move inwards towards the center of the
curve. The start time of the object motion from the initial position may also be
linearily varied, in the form $t_c = ku + t_0$, for some scale factor $k$. This
paradigm makes programming complex motion and multiple related patterns
difficult. While there is support for Hermite splines in [Ph3][], their use is
limited to simple splines used for enemy motion. This text studies the
mathematical properties of the current commonly-used system, and investigates
other methods for describing motion along a curve that have better descriptive
power.

The Particle System
===================

The current system is analogous to the movement of particles without the
constraint that mechanical energy must be conserved. I.e. the position ($x_0$ or
$y_0$), velocity ($v$), acceleration ($a$), angle ($\theta_0$), angular velocity
($\omega$), or angular acceleration ($\alpha$) can be arbitrarily set to any
value desired. As a notational convention for the particle system, $v \equiv
\|\vec{v}\|$, since the presence of $(x_0, y_0, \theta_0)$ for a particle
eliminate the need to specify the direction of an associated vector. Parametric
curves parameterized by only one variable are so w.r.t. $t$, which is not always
time.

What possible curves can be described by the motion of a single particle in this
system? In the typical case for constant $(x_0, y_0, \theta_0, v, a, \omega,
\alpha)$, trivial differential equations can be solved for each of the
dimensions of the particle's travel.

$$
\begin{align*}
v &= \frac{dx}{dt}        & \omega &= \frac{d\theta}{dt} \\
a &= \frac{d^2 x}{{dt}^2} & \alpha &= \frac{d^2 \theta}{{dt}^2}
\end{align*}
$$

$$
\begin{align*}
x &= x_0 + vt + \frac{1}{2}at^2 \\
\theta &= \theta_0 + \omega t + \frac{1}{2}\alpha t^2
\end{align*}
$$

Because linear velocities and accelerations are essentially represented in polar
form, a generic transformation can be applied to map displacements to each
dimension. For the Cartesian parameterization in $\mathbb{R}^2$, this is
obviously $(\cos\theta, \sin\theta)$, but it is important to note
that this also obviously works for Cartesian coordinates in $\mathbb{R}^n$. This
implies that not only does this work in three-dimensional space, but also that
interesting effects might be obtained by specifying motion in higher dimensions
and using the projection to lower dimensions as the output curve. Applying the
coordinate transformation gives a parameterization in each dimension. In
$\mathbb{R}^2$:

$$
\begin{align*}
x &= \iint{a_x dt} \\
&= \iint{a\cos\theta dt} \\
&= \iint{a\cos\left(\theta_0 + \omega t + \frac{1}{2}\alpha t^2\right) dt}
\end{align*}
$$

Essentially all graphics programs that use curves of this form solve for
positions numerically (such as setting $v = a\Delta t$, then $x = v\Delta
t\cos\theta$). As such, a solution for $x$ above is not necessary practically,
but is important for study here. As it stands, the solution for particle motion
specified in this way is particularly messy. For the Fresnel integrals

$$
C(u) + iS(u) = \int_0^u{e^{\left.{i\pi x^2}\middle/{2}\right.}dx}
$$

The solution in the $x$ dimension only is

$$
\begin{align*}
x = -\left.\left(a \left(-\sqrt{\pi } (\alpha  t+\omega ) \cos \left(\theta
-\frac{\omega ^2}{2   \alpha }\right) C\left(\frac{t \alpha +\omega }
{\sqrt{\pi } \sqrt{\alpha   }}\right) \\
+\sqrt{\pi } (\alpha  t+\omega ) \sin \left(\theta -\frac{\omega ^2}
{2  \alpha }\right) S\left(\frac{t \alpha +\omega }{\sqrt{\pi }
\sqrt{\alpha   }}\right) \\
+\sqrt{\alpha } \sin \left(\theta +\frac{\alpha  t^2}{2}+t \omega
\right)\right)\right)\middle/\left(\alpha ^{3/2}\right)\right. \\
+ \left(\left.\left(\sqrt{\pi } v \left(\cos \left(\theta -\frac{\omega ^2}
{2 \alpha }\right)   C\left(\frac{t \alpha +\omega }{\sqrt{\pi }
\sqrt{\alpha }}\right) \\
-\sin   \left(\theta -\frac{\omega ^2}{2 \alpha }\right) S\left(\frac{t \alpha
+\omega   }{\sqrt{\pi } \sqrt{\alpha }}\right)\right)\right)\middle/
\left(\sqrt{\alpha }\right)\right.\right)t
+ x_0
\end{align*}
$$

This sucks. Luckily, a much simpler, functionally equivalent representation
exists. This method deviates from the above definition of particle motion in
terms of changing $(x, y, \theta)$, and instead achieves behavior equivalent to
the function above with the addition of one new parameter per dimension. I.e.
a curve under the particle system can be described by $(x, x_c, y, y_c, v, a,
\theta, \omega, \alpha)$.

$$
\begin{align*}
x &= x_0 + \cos\left(\theta_0 + \omega t + \frac{1}{2}\alpha t^2\right)
\left(x_c + vt + \frac{1}{2}at^2\right) \\
y &= y_0 + \sin\left(\theta_0 + \omega t + \frac{1}{2}\alpha t^2\right)
\left(y_c + vt + \frac{1}{2}at^2\right)
\end{align*}
$$

Particle Curves
---------------

All categories of curves obtainable using a single particle are documented
below.  If a curve variable is not specified in the description, it is zero.

![Line: $\{v\} \neq 0$][line]

![Circle: $\{x_c, y_c, \omega\} \neq 0$, $x_c = y_c$][circle]

![Ellipse: $\{x_c, y_c, \omega\} \neq 0$, $x_c \neq y_c$][ellipse]

![Archimedes' Spiral: $\{v, \omega\} \neq 0$][aspiral]

![Archimedian Spiral $r(\theta)=\theta^{\left.1\middle/n\right.}$,
where $n=\frac{1}{2}$: $\{a, \omega\} \neq 0$][spiral]

![Archimedian Reversing Spiral $r(\theta)=\theta^{\left.1\middle/n\right.}$,
where $n=2$: $sgn(va) = -1$][arevspiral]

![Archimedian Spiral $r(\theta)=\theta^{\left.1\middle/n\right.}$,
where $n=2$: $sgn(\omega\alpha) = 1$][angaspiral2]

![Angular Hook Spiral: $\{v, \omega\} \neq 0 > sgn(\omega)\cdot\alpha$][anghook]

All of the spiral curves have variants where at least one of $x_c$ or $y_c$ are
nonzero, which has the effect of shifting the start of the spiral outwards in
the case that $x_c = y_c$, or of stretching the modified spiral in the case that
$x_c \neq y_c$.

![Archimedes' Spiral, Shifted: $\{v, \omega, x_c, y_c\} \neq 0$,
$x_c = y_c$][xyspiral]

![Archimedes' Spiral, Shifted and Stretched: $\{v, \omega, sgn(x_c y_c)\} \neq
0$, $x_c \neq y_c$][xysspiral]

Composition
-----------

Of course, the listing above does not include all curves that one may wish to
draw. In order to create more complex curves, the most common method in existing
particle systems is to use multiple particles set to move in arcs, where the
beginning of the next particle's arc is the end of the previous particle's arc.

![Arc][arc1]\ 

![Component Arcs: $\{x_c, y_c, \omega\} \neq 0$, $x_c = y_c$, $\theta \in
\mathbb{R}$, $t \in [0, t_f]$, $t_f < 2\pi$][arc2]

![Composed Arcs][arccomp]

A composed arc has piecewise particle curve functions defined in terms of
component arcs.

$$
x(t) =
\begin{cases}
x_1(t) & 0 \leq t < t_{f_1} \\
x_2(t - t_{f_1}) & t_{f_1} \leq t < t_{f_1} + t_{f_2} \\
\vdots & \vdots \\
x_n(t - \sum_{i=1}^{n-1}{t_{f_i}}) &
\sum_{i=1}^{n-1}{t_{f_i}} \leq t < \sum_{i=1}^{n}{t_{f_i}}
\end{cases}
$$

In practical applications, the component functions are often modified to accept
a normalized parameter $t'$, so the normalized curve from components $X_n(t') =
x_n(t'\cdot t_{f_n})$ is

$$
X(t') =
\begin{cases}
X_1(t') & 0 \leq t' < 1 \\
X_2(t' - 1) & 1 \leq t' < 2 \\
\vdots & \vdots \\
X_n(t' - n + 1) & n - 1 \leq t' < n
\end{cases}
$$

By composing arcs like this, arbitrary parametric functions can be approximated.
However, current implementations of the particle system like [Ph3][] rely on the
user to manually implement this composition, and the component arcs must be
manually translated into the correct position. To make matters worse, these
systems often do not provide sufficient abstractions that would allow the
automation of this process. Due to this difficulty of use, curves under the
particle system are linear in most cases, occasionally curved, rarely composed
as above, and almost never spirals. Even if sufficient abstractions were
present, arcs are not optimal choices for the approximation of curves. Instead,
particle systems obtain interesting motion by virtue of varying initial
positions and by accidental group motion, analogous to a kind of beating
phenomenon. Both of these techniques require much manual work as well.

Improvement
-----------

The issues with the particle system raise more general concerns to attention.
The core difficulty in use of the particle system is the difficulty of
composition. Whether it is difficult to align component arcs or to create
apparent motion from several linear-path particles, better ease of construction
is achievable through composition. Additionally, much design in particle systems
is done by trial and error. A higher-level system would allow more targeted
development of motion.

General Curve Systems
=====================

Users of the particle system have access to parametric curves for setting
initial positions of particles, but not for determining their motion.
Additionally, any further composition of curves must be done manually, and often
does not achieve full generality. Fully parametric systems for describing motion
attenuate this issue to varying degrees. To differentiate the compositional
nuances between parametric, particle, and other systems, some formal
definition and investigation of these apparent *curve systems* is warranted.

Throughout the following definition of curve systems, an effort is made to
typeset symbols for mathematical objects such that the type of an object can be
discerned from the script it is written in.

Curves
------

Let $\mathcal{M}$ be the set of all descriptions of curves. Previously, the
particle system for describing curves was investigated. Let the kind of curve
description used in the particle system be called $\mathcal{P}$: the particle
curve description. Whether the process used to realize $\mathcal{P}$ is
implemented as the unwieldy original definition of the particle curve, or as the
equivalent form that uses extra parameters is of no consequence. The defining
characteristics of a curve description such as $\mathcal{P}$ are the categories
of curves that it is possible to describe, and the possible morphisms on the
described categories of curves.

### Categories of Curves ###

The individual categories of curves that a description $\mathcal{D}$ is capable
of describing form a set $I(\mathcal{D})$. Some of these categories of curves
are well-known, and are often expressible in several different descriptions. For
example, there are the curve categories that embody the linear curve
$\mathfrak{L}$, the circular curve $\mathfrak{C}$, and the Archimedes' spiral
curve $\mathfrak{A}$ as described above by $\mathcal{D}$, having familiar
behavior. A category of curves consists of a basis curve and isomorphisms on
curves, originating from the basis curve, that result in all other curves in the
category. I.e. given a basis curve $\mathfrak{h}$ and set of isomorphisms
$\mathscr{H}$, a category of curves $\mathfrak{H}$ can be constructed. The set
of all curves generated from a basis function $\mathfrak{h}$ and some
isomorphisms $\mathscr{I} \subset \mathscr{H}$ is $H(\mathfrak{h},
\mathscr{I})$, the fixpoint of applying isomorphisms $\mathscr{I}$ to
$\mathfrak{h}$:

$$
\begin{align*}
F(P, \mathscr{I})
&\equiv
\begin{cases}
P = \emptyset & \bigcup_{i\in\mathscr{I}}{\{i(h) : h \in \mathfrak{h}\}} \\
P \neq \emptyset & \bigcup_{i\in\mathscr{I}}{\{i(p) : p \in P\}}
\end{cases} \\
H(\mathfrak{h}, \mathscr{I})
&\equiv \mathfrak{F} \equiv F(\mathfrak{F}, \mathscr{I})
: \mathfrak{h} \subset \mathfrak{F} \\
\end{align*}
$$

When the subset $\mathscr{I} = \mathscr{H}$,

$$
\begin{align*}
W(\mathfrak{h}) &\equiv H(\mathfrak{h}, \mathscr{I}) \\
I(\mathcal{D}) &\cong W(\mathfrak{h})
\end{align*}
$$

### Curve Description Morphisms ###

Additionally, there exists a set of all description morphisms $m$ on all
described categories of curves $I(\mathcal{D})$, called $M(\mathcal{D})$, such
that:

$$
\begin{align*}
\exists \varepsilon &: m(i) \rightarrow i, \forall i \in I(\mathcal{D}) \\
\forall (i,j) &\in I(\mathcal{D}), \forall k \in i,
\exists l \in i \cup j : m(l) = k \\
m(i) &\equiv \{m(j) : j \in i\}, \forall m \in M(\mathcal{D}), \forall i \in
I(\mathcal{D}) \\
M(\mathcal{D}) &\equiv \{m : \exists i \in I(\mathcal{D}) : m(i) \in
I(\mathcal{D})\}
\end{align*}
$$

$M(\mathcal{D})$ is partitioned by two subsets that *preserve* and *degrade*
described curve category structure. Respectively,

$$
\begin{align*}
M_P(\mathcal{D}) &\equiv \{ m : m \in M(\mathcal{D}), \forall i \in
I(\mathcal{D}), \forall j \in i, m(j) \in i \} \\
M_D(\mathcal{D}) &\equiv M(\mathcal{D}) \cap M_P(\mathcal{D})^c
\end{align*}
$$

### Unity and the Rest ###

The unity curve description $\mathcal{E}$ is trivially defined in terms of the
unity basis curve $\mathfrak{e}$, which denotes the lack of a curve, and the
identity curve category morphism $\varepsilon$, as defined above.

$$
\begin{align*}
\mathfrak{E} &\equiv W(\mathfrak{e}) : \mathscr{H} = \emptyset \\
I(\mathcal{E}) &\equiv \{\mathfrak{E}\} \\
M(\mathcal{E}) &\equiv \{\varepsilon\} \\
\end{align*}
$$

The set of curve isomorphisms $\mathscr{H}$ is defined as $\emptyset$ rather
than an identity on $\mathfrak{e}$, because any $h(\mathfrak{e}) : h \in
\mathscr{H}$ must be a curve by definition, and the creation of a curve from the
lack of a curve would be absurd. This implies that:

$$
\forall \mathcal{D} \in \mathcal{M}\cap\mathcal{E}^c, \\
\forall \mathfrak{I} \in I(\mathcal{D}), \mathfrak{E} \notin \mathfrak{I}
\because \mathfrak{I} = W(\mathfrak{h}) : \mathfrak{h} \neq \mathfrak{e}
\wedge |\mathscr{H}| > 0 \\
M(\mathcal{E}) \subsetneq M(\mathcal{D})
$$

Curve Systems
-------------

The concept of a curve system necessitates an extension of the definition of
curve descriptions to allow for curve description combination. Any two curve
descriptions $\mathcal{B}$ and $\mathcal{C}$ can be combined via $\oplus$ to
create a curve descriptor $\mathcal{A} = \mathcal{B} \oplus \mathcal{C}$ for
more complex curves, which is simply a curve description that satisfies the
following properties:

$$
\begin{align*}
I(\mathcal{B} \oplus \mathcal{C})
&\equiv I(\mathcal{B}) \cup I(\mathcal{C}) \\
M(\mathcal{B} \oplus \mathcal{C})
&\equiv \{c \circ b : b \in M(\mathcal{B}), c \in M(\mathcal{C})\}
\end{align*}
$$

### Description Foundations ###

Curve descriptions $\mathcal{B}$ and $\mathcal{C}$ are *basis descriptions* if
and only if

$$
\nexists (\mathcal{A}, \mathcal{A'}) : \mathcal{A} \oplus \mathcal{A'}
\subset \mathcal{B} \oplus \mathcal{C}, \mathcal{A} \neq \mathcal{A'} \neq
\mathcal{E}
$$

Given any two basis descriptions $\mathcal{B}$ and $\mathcal{C}$, their
combination $\mathcal{F} = \mathcal{B} \oplus \mathcal{C}$ forms a *fundamental
curve description*.

### Construction of Curve Systems ###

Curve systems can be constructed from curve descriptions by means of
composition. A curve system $\mathscr{S}_\mathcal{B}^\mathcal{C}$ has curves
described by $\mathcal{B}$ as its visible *basis* curves, which are then
*composed* according to curves described by $\mathcal{C}$. As an example, the
particle system discussed above is $\mathscr{P} \equiv
\mathscr{S}_\mathcal{P}^\mathcal{E}$, because the visible curves of the particle
system are obviously the particle curves described by the particle descriptor
$\mathcal{P}$, and there are no means of composition in the particle system, so
the composition descriptor is the unity descriptor $\mathcal{E}$. The system
$\mathscr{P}$ is also a *simple curve system*: a curve system that is
constructed from only fundamental curve descriptions. This is so because
$\mathcal{P} = \mathcal{P} \oplus \mathcal{E}$ and $\mathcal{E} = \mathcal{E}
\oplus \mathcal{E}$. For simple curve systems,

$$
\begin{align*}
I(\mathscr{S}_\mathcal{B}^\mathcal{E}) &= I(\mathcal{B}) \\
M(\mathscr{S}_\mathcal{B}^\mathcal{E}) &= M(\mathcal{B})
\end{align*}
$$

This Seems Familiar
-------------------

While it is fun to construct these objects from sets, they have even more
general and well-studied counterparts in the literature of Category Theory. A
list of rough translations from curve-speak to standard category theoretical
terminology follows.

-------------------------------------- -----------------------------------------
          Curve Terminology                    Categorical Terminology
-------------------------------------- -----------------------------------------
Curve basis function $\mathfrak{h}$    An object of category $\mathcal{Func}$

Morphisms on curve functions           The union of all hom-sets of
$\mathscr{H}$                          $\mathcal{Func}$

Curve category $\mathfrak{L}$          An object of category $\mathcal{Curv}$

Curve descriptor $\mathcal{D}$         An object of category $\mathcal{Desc}$

Described curves $I(\mathcal{D})$      The set of objects in $\mathcal{D}$

Described curve morphisms              The union of all hom-sets of
$M(\mathcal{D})$                       $\mathcal{D}$

The unity curve descriptor             ${id}_e \forall e \in E$, $E$ being
$\mathcal{E}$ and components           any of $\mathcal{Func}$,
                                       $\mathcal{Curv}$, or $\mathcal{Desc}$

Descriptor combination                 The coproduct in $\mathcal{Desc}$
$\mathcal{B} \oplus \mathcal{C}$

Curve system construction              The coproduct in $\mathcal{Sys}$
$\mathscr{S}_\mathcal{B}^\mathcal{C}$
-------------------------------------- -----------------------------------------

The Parametric System
=====================

The particle system $\mathscr{P_0}\equiv\mathscr{S}_\mathcal{P}^\mathcal{E}$
allows only a limited set of curves to be used as basis curves. Consider the
improvement in expressiveness possible when using arbitrary parametric curves
$\mathcal{T}$ instead of the particle curves $\mathcal{P}$. This forms the
*fundamental parametric system*
$\mathscr{T_0}\equiv\mathscr{S}_\mathcal{T}^\mathcal{E}$. In fact, because the
particle curves themselves are parametric curves, we have

$$
\begin{align*}
\mathcal{P} &\subsetneq \mathcal{T} \\
\therefore \mathscr{S}_\mathcal{P}^\mathcal{E}
&\subsetneq \mathscr{S}_\mathcal{T}^\mathcal{E} \\
\Rightarrow \mathscr{S}_\mathcal{P}^\mathcal{E}
&< \mathscr{S}_\mathcal{T}^\mathcal{E}
\end{align*}
$$

Here, $\subsetneq$ denotes its usual meaning, and $\lt$ denotes an inequality
of the expressiveness of the two systems.

Interpolation Systems
---------------------

What use is the parametric system to a user of a particle system, or any other
system that is used in practical graphics applications? Virtually none of these
use $\mathscr{T_0}$ internally, because parametric equations take too long to
solve, and practically require a computer algebra system for simplification to
be efficient when external input equations must be dealt with. More common
systems include the Bézier system
$\mathscr{B_0}\equiv\mathscr{S}_\mathcal{B}^\mathcal{E}$, the Cubic Hermite
Spline (Hermite) system
$\mathscr{H_0}\equiv\mathscr{S}_\mathcal{H}^\mathcal{E}$, and other such
fundamental systems based upon common interpolation curves, of which
$\{\mathfrak{L}, \mathfrak{C}, \mathfrak{A}\} \subsetneq I(\mathcal{P})$ are
included. All of these interpolation-based systems form a composite system that
reflects the properties of the fundamental interpolation systems, aptly called
the *interpolation system* $\mathscr{I}$, defined as

$$
\begin{align*}
\forall\mathfrak{i} : \nexists (\mathfrak{j},m)
&: m(\mathfrak{j}) = \mathfrak{i}, \mathfrak{j} \neq \mathfrak{i} \\
\wedge \forall u, \nexists v
&: \forall t, \mathfrak{i} = u \wedge \mathfrak{i} = v \wedge u \neq v, \\
\forall\mathcal{D} &: M(\mathcal{D}) = \mathscr{D}
\wedge \mathcal{D} \cong W(\mathfrak{i}), \\
\mathcal{I} &\equiv \bigoplus_{d\in\mathcal{D}}{d} \\
\mathscr{I} &\equiv \mathscr{S}_\mathcal{I}^\mathcal{E}
\end{align*}
$$

This implies that $\mathscr{T_0}$ has even more descriptive power than
originally thought.

$$
\begin{align*}
\mathcal{I} &\cong \mathcal{T} \\
\therefore \mathscr{S}_\mathcal{I}^\mathcal{E}
&\cong \mathscr{S}_\mathcal{T}^\mathcal{E} \\
\Rightarrow \mathscr{S}_\mathcal{I}^\mathcal{E}
&\leq \mathscr{S}_\mathcal{T}^\mathcal{E} \\
\therefore \mathscr{I} &\cong \mathscr{T_0}
\end{align*}
$$

The Cut Functor
---------------

### TODO: Change so that *cut* just cuts, and something else does the approximation with interpolation. ###

Because $\mathscr{I} \cong \mathscr{T_0}$, a *curve bifunctor* must exist, which
makes it possible to specify curves in $\mathscr{T_0}$ and transform them to
$\mathscr{I}$ and *vice versa*, via a *curve functor* $\mathbb{C} :
\mathscr{T_0} \rightarrow \mathscr{I}$, called *cut*, which takes a curve
$\mathfrak{t}$ under $\mathscr{T_0}$ to many curves $\mathfrak{i}\in
I(\mathscr{I})$, which approximate $\mathfrak{t}$. $\mathbb{C} : \mathscr{T_0}
\rightarrow \mathscr{P}$ has already been studied in the exposition of
$\mathscr{P}$, and $\mathbb{C} : \mathscr{T_0} \rightarrow \mathscr{B}$
describes the familiar construction of a composite Bézier curve, while
$\mathbb{C} : \mathscr{T_0} \rightarrow \mathscr{H}$ describes the same for
piecewise Hermite splines. Because $\mathscr{I} \cong \mathscr{T_0}$, we also
have $\mathbb{C} : \mathscr{T_0} \rightarrow \mathscr{T_0}$, the construction of
a piecewise parametric curve. This implies that arbitrarily smooth
approximations of $\mathfrak{t}$ are possible by iteration of $\mathbb{C}$.

Higher Parametric Systems
-------------------------

Mmm, *composition*.


[Danmakufu Ph3]: http://www.geocities.co.jp/SiliconValley-Oakland/9951/pre/th_dnh_ph3.html 'Danmakufu Ph3'
[Ph3]: http://www.geocities.co.jp/SiliconValley-Oakland/9951/pre/th_dnh_ph3.html 'Danmakufu Ph3'
[point]: img/param_point.svg
[line]: img/param_line.svg
[circle]: img/param_circle.svg
[ellipse]: img/param_ellipse.svg
[aspiral]: img/param_aspiral.svg
[spiral]: img/param_spiral.svg
[arevspiral]: img/param_arevspiral.svg
[angaspiral2]: img/param_angaspiral2.svg
[anghook]: img/param_anghook.svg
[xyspiral]: img/param_xyspiral.svg
[xysspiral]: img/param_xysspiral.svg
[arc1]: img/param_arc1.svg
[arc2]: img/param_arc2.svg
[arccomp]: img/param_arccomp.svg

