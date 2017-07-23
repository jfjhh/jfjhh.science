---
title: 'Parametric Equations [WIP]'
subtitle: 'Analysis for Use in Programmable Motion'
author:
- Alex Striff
date: 2017-07-21
---

Abstract
========

The process used to program object trajectories in computer game scripting
engines such as [Danmakufu Ph3][] is to update object positions, velocities,
accelerations, or angular variants to create complex motion. E.g. an object with
$a > \alpha$ and $v << a, \omega << \alpha$ will move in a spiral. Interesting
shapes are obtained by setting initial positions of objects along some curve,
and making the objects move in a direction that is often related to the curve.
Objects created along the curve
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
= \omega = 0$ and $\vec{v} > 0$ will move inwards towards the center of the
curve. The start time of the object motion from the initial position may also be
linearily varied, in the form $t_c = ku + t_0$, for some scale factor $k$. This
paradigm makes programming complex motion and multiple related patterns
difficult. While there is support for Hermite splines in [Ph3][], their use is
limited to simple splines used for enemy motion.

![test]\ 

Test Lisp Code
==============

This is some unrelated common lisp code that messes with Church numerals.

Church Numerals
---------------

```lisp
;;;;
;;;; Computing some things with the lambda calculus.
;;;; Alex Striff.
;;;;

(defparameter *calls* 0)

(defmacro l (&body body)
  "Make a thunk for `body`."
  `(lambda () ,@body))

(defun call (l &rest args)
  "Calls nested lambda terms."
  (if (null args)
      l
      (progn
	(incf *calls*)
	(if (= (length args) 1)
	    (funcall l (car args))
	    (funcall (apply #'call
			    (append (list l) (butlast args)))
		     (car (last args)))))))

(defun lcall (l &rest args)
  "Lazily calls nested lambda thunks."
  (if (= (length args) 1)
      (funcall (funcall l) (funcall (car args)))
      (funcall (apply #'call (append (list (funcall l)) (cdr args)))
	       (funcall (car args)))))

#|
Commonly used lambda terms:
I := λx.x
K := λx.λy.x
S := λx.λy.λz.x z (y z)
B := λx.λy.λz.x (y z)
C := λx.λy.λz.x z y
W := λx.λy.x y y
U := λx.λy.y (x x y)
ω := λx.x x
Ω := ω ω
Y := λg.(λx.g (x x)) (λx.g (x x))
|#

(defparameter i (lambda (x) x))
(defparameter k (lambda (x) (lambda (y) x)))
(defparameter s (lambda (x) (lambda (y) (lambda (z) (call x z (call y z))))))
(defparameter b (lambda (x) (lambda (y) (lambda (z) (call x (call y z))))))
(defparameter c (lambda (x) (lambda (y) (lambda (z) (call x z y)))))
(defparameter w (lambda (x) (lambda (y) (call x y y))))
(defparameter u (lambda (x) (lambda (y) (call y (call x x y)))))
(defparameter ω (lambda (x) (call x x)))
(defparameter Ω (lambda () (call ω ω)))
(defparameter y (lambda (f) (call (lambda (x) (call f (call x x)))
			     (lambda (x) (call f (call x x))))))

#|
Church Numerals:
0 := λf.λx.x
1 := λf.λx.f x
2 := λf.λx.f (f x)
SUCC := λn.λf.λx.f (n f x)
PLUS := λm.λn.λf.λx.m f (n f x)
MULT := λm.λn.λf.m (n f)
POW := λb.λe.e b
PRED := λn.λf.λx.n (λg.λh.h (g f)) (λu.x) (λu.u)
|#

(defparameter zero (lambda (f) (lambda (x) x)))
(defparameter succ (lambda (n) (lambda (f) (lambda (x) (call f (call n f x))))))
(defparameter plus (lambda (m) (lambda (n) (lambda (f) (lambda (x) (call m f (call n f x)))))))
(defparameter mult (lambda (m) (lambda (n) (lambda (f) (call m (call n f))))))
(defparameter pow (lambda (b) (lambda (e) (call e b))))
(defparameter pred (lambda (n) (lambda (f) (lambda (x) (call n
					      (lambda (g) (lambda (h) (call h (call g f))))
					      (lambda (u) x) (lambda (u) u))))))
(defparameter false (lambda (x) (lambda (y) y)))
(defparameter true (lambda (x) (lambda (y) x)))
(defparameter conj (lambda (p) (lambda (q) (call p q p))))
(defparameter disj (lambda (p) (lambda (q) (call p p q))))
(defparameter neg (lambda (p) (call p false true)))
(defparameter iff (lambda (p) (lambda (x) (lambda (y) (call p x y)))))
(defparameter iszero (lambda (n) (call n (lambda (x) false) true)))

(defun n->i (n)
  "Converts a Church numeral to a Lisp number."
  (if (call (call iszero n) t nil)
      0
      (1+ (n->i (call pred n)))))

(defun i->n (x)
  "Converts a Lisp number to a Church numeral."
  (if (plusp x)
      (call succ (i->n (1- x)))
      zero))

(defun def-i->s (x)
  "Defines the Church numeral corresponding to the number as a variable."
  (let* ((str (format nil "~r" x))
	 (str (substitute #\- #\Space str))
	 (str (string-upcase str))
	 (sym (intern str)))
    (eval
     (list 'defparameter sym (i->n x)))))

;;; Define number-named number variables that are Church numerals.
(setf *calls* 0)
(loop for i from 1 to 1337 do
     (def-i->s i))
(format t "Constructing all Church numeral λ-terms ε [1,1337] took ~:d β-reductions.~%~%" *calls*)

;;; Do calculations.
(setf *calls* 0)
(format t "Calculating (* (* 3 2) (+ 3 (* 2 2))) ... ")
(force-output)
(defparameter *calculation*
  (n->i
   (call mult
	 (call mult
	       (i->n 3)
	       (i->n 2))
	 (call plus
	       (i->n 3)
	       (call mult
		     (i->n 2)
		     (i->n 2))))))
(format t "~a~%" *calculation*)
(format t "Calculation took ~:d β-reductions.~%~%" *calls*)

(setf *calls* 0)
(format t "Calculating 256 (church numeral to number) ... ")
(force-output)
(defparameter *calculation*
  (n->i (i->n 256)))
(format t "~a~%" *calculation*)
(format t "Calculation took ~:d β-reductions.~%~%" *calls*)

(setf *calls* 0)
(format t "Calculating 1,024 (church numeral to number) ... ")
(force-output)
(defparameter *calculation*
  (n->i (i->n 1024)))
(format t "~a~%" *calculation*)
(format t "Calculation took ~:d β-reductions.~%" *calls*)
```


[Danmakufu Ph3]: http://www.geocities.co.jp/SiliconValley-Oakland/9951/pre/th_dnh_ph3.html 'Danmakufu Ph3'
[Ph3]: http://www.geocities.co.jp/SiliconValley-Oakland/9951/pre/th_dnh_ph3.html 'Danmakufu Ph3'
[test]: img/test.svg

