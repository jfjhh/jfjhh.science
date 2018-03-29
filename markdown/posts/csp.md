---
title: 'Curve Systems [Practical] [WIP]'
subtitle: 'Making the Programmable Motion'
author:
- Alex Striff
date: 2017-08-21
---

Abstract
========

This text seeks to investigate implementation details of some curve systems.
Often, conveniences and hindrances encountered in the implementation of such
systems will inform improvements that need to be made to the definitions of the
curve systems. This project does not seek to create a particular engine, such as
[Danmakufu Ph3][], but instead to provide a concrete implementation of some of
the ideas of curve systems, in a way that is easier to use in further
applications such as generating computer graphics or motions in games.

Base
====

Where [Ph3][] sets out to control the flow of the game in an imperative manner,
this implementation of more general curve systems will seek to use a more
declarative style.

Convenience
===========

As a practical consideration mostly unrelated to the implementation of curve
systems, some features can be added to an implementation that make the
experience of manipulating curves much smoother.

Period Finding
--------------

When dealing with purely periodic curves, such as circles, ellipses, or
Lissajous curves, which have periodic components in each basis, it may not be
immediately obvious what the period of the curve is, though it is necessary to
input for generation of output. The implementation itself can find the period of
the curves, given both that the individual basis functions are periodic, and
that the basis functions have relatively rational periods. I.e. the $x$ function
may have period $T_x = \sqrt{2}$, which is irrational, and the $y$ function have
period $T_y = 2\sqrt{2}$, which is also irrational, yet $\frac{T_x}{T_y} =
\frac{1}{2}$, which is rational, and thus the entire curve is periodic.

A function is periodic if it is constant or trigonometric, and is not combined
with another aperiodic function. E.g. $2+\sin t$ is periodic, because the
functions $2$ and $\sin$ are periodic, while $t\sin t$ is not periodic, because
$t$ is not periodic. In general, any function $H(f, g)$ on periodic $f$ and $g$
will be periodic, and otherwise aperiodic. Commonly, $H$ is one of addition,
multiplication, or exponentiation, though it is useful to include that it may
also be the coproduct. I.e. $\forall f, H(f, \emptyset) = H(\emptyset, f) = f$,
such as is partially true in the case that $H(f, g) = f + 0$. Given periodic $f$
and $g$, $H(f, g)$ will have periods at $lcm(T_f, T_g)$, or equivalently at
$gcd(f_f, f_g)$.

Specifically, sines and cosines are the most often used periodic function, as
other trigonometric functions have asymptotes that are undesirable for
describing curves. In the case where $f$ and $g$ are either sines or cosines of
the form $sin(kt)$, the period will be $T = \frac{2\pi}{k}$ and the frequency $f
= \frac{k}{2\pi}$.

Now generally, given periodic functions $f$ and $g$ of rational frequencies $f_f
= \frac{p}{q}$ and $f_g = \frac{r}{s}$, it can be shown that their smallest
general period is

$$
T_{fg} = \frac{2\pi qs}{gcd(ps, qr)}
$$

For multiple periodic functions $f_1 = \frac{p_1}{q_1}$ to $f_1 =
\frac{p_1}{q_1}$, the smallest general period of their combination $H(f_1,
\dots, f_n)$ will be

$$
T_H = \frac{2\pi \prod_{i \in [1, n]}{q_i}}
{gcd(\{p_i \prod_{j\in[1, n], j\neq i}{q_j} : i \in [1, n]\})}
$$

While this period is the smallest for any combining function $H$, for some
functions, the minimal period will be shorter. E.g. for $f(t) = \sin t$ and
$g(t) = 2$, the minimal period of $H(f, g) = f^g = \sin^2 t$ is $\pi$, not the
period $2\pi$ which would be found from the above.

To find the period of a curve, one would apply the above equation to find the
period of the functions in each dimension, and then apply it again to the
periods of all the dimensions to find the period of the entire curve. Because
any real number can have its decimal expansion truncated and interpreted as a
rational, like $\pi \approx 3.141593 = \frac{3141593}{10^6}$, this method can
even be used on pseudo-periodic functions, with discretion, as a nice default
value that can be changed if the user wishes to view the entire curve. This also
may be useful if rounding error is unavoidable in some context and the curve is
known to be periodic from some outside knowledge.

A heuristic may also be applied that investigates other shorter periods. For $h
= H(f, g)$, fractions of the $gcd$ period, $T_{gcd}$ may be investigated. If
$h(0) = h(\frac{T_{gcd}}{k})$ and $h'(0) = h'(\frac{T_{gcd}}{k})$, then
$\frac{T_{gcd}}{k}$ is most likely a period of $h$. Good values of $k$ to try
are $2$ and any of $p_i, q_i$. E.g. for $\sin^2 t$, $\frac{T_{gcd}}{2} = \pi$,
which is the minimal period of the function.

**TODO:** Prove if checking only $h$ and $h'$ is enough to give periodicity, or
if higher derivatives are required. By power series, doing all derivatives is
certainly enough, and doing only the first derivative works for many functions.


[Danmakufu Ph3]: http://www.geocities.co.jp/SiliconValley-Oakland/9951/pre/th_dnh_ph3.html 'Danmakufu Ph3'
[Ph3]: http://www.geocities.co.jp/SiliconValley-Oakland/9951/pre/th_dnh_ph3.html 'Danmakufu Ph3'

