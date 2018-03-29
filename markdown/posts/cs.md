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

