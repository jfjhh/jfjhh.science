---
title: 'Reed Notes $\LaTeX$ Class'
author:
- Alex Striff
date: 2018-06-04
---

Click to download my [Reed Notes $\LaTeX$ Class][reednotes]. I have used it with
minor modifications in the past for writing up problem sets, notes, and lab
reports. The source is reproduced below.

[reednotes]: pub/reednotes.cls

```latex
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reed Notes
% LaTeX Class
% Version 1.0 (2018)
%
% Original author:
% Alex Striff (striffa@reed.edu)
%
% License:
% CC BY-NC-SA 4.0 (http://creativecommons.org/licenses/by-nc-sa/4.0/)
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{reednotes}[2018/06/04 Reed Notes LaTeX Class v1.0]

\ProcessOptions\relax

\LoadClass[letterpaper,8pt]{extarticle}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[sc]{mathpazo}
\usepackage[fleqn]{amsmath}
\usepackage{amssymb}
\usepackage{amsthm}
\usepackage{booktabs}
\usepackage{caption}
\usepackage{enumitem}
\usepackage{float}
\usepackage{geometry}
\usepackage{graphicx}
\usepackage{mathtools}
\usepackage{microtype}
\usepackage{nicefrac}
\usepackage{physics}
\usepackage{titlesec}
\usepackage{titling}
\usepackage{xcolor}

% Page and length restyling.
\geometry{lmargin=0.75in,rmargin=0.75in,tmargin=0.5in,bmargin=0.625in}
\linespread{1.04}
\setlength{\droptitle}{-0.5in}
\setlist[enumerate]{parsep=0.25em}
\setlist[itemize]{parsep=0.25em}
\setcounter{secnumdepth}{-2}
\pretitle{\begin{center}\LARGE}
\posttitle{\par\end{center}}
\renewcommand{\maketitlehookb}{\begin{center}}
\preauthor{\begin{tabular}[t]{c}}
\postauthor{\end{tabular}}
\predate{\par}
\postdate{}
\renewcommand{\maketitlehookd}{\end{center}}
\renewcommand{\thepage}{\color{gray}\arabic{page}}
\captionsetup{figurename=Fig.,labelfont=bf}

% Sets.
\let\oldemptyset\emptyset
\let\oldsetminus\setminus
\renewcommand{\emptyset}{\varnothing}
\renewcommand{\setminus}{\mathbin{\vcenter{\hbox{$\scriptstyle\oldsetminus$}}}}
\newcommand{\intersect}{\cap}
\newcommand{\union}{\cup}
\newcommand{\isomorphic}{\cong}

% Well-known mathematical objects.
\newcommand{\naturals}{\mathbf{N}}
\newcommand{\integers}{\mathbf{Z}}
\newcommand{\rationals}{\mathbf{Q}}
\newcommand{\reals}{\mathbf{R}}
\newcommand{\complex}{\mathbf{C}}
\newcommand{\polynomials}{\mathcal{P}}
\newcommand{\matrices}{\mathcal{M}}
\newcommand{\finitefield}[1]{\nicefrac{\integers}{#1\integers}}
\newcommand{\stdbasis}{\mathcal{E}}
\newcommand{\ve}{\varepsilon}

% Linear Algebra: Matrices and various collections.
\newcommand{\rep}[1]{{\left[#1\right]}}
\newcommand{\mrep}[1]{{\left[#1\right]}}
\newcommand{\map}{\rightarrow}
\newcommand{\linearmap}{\xrightarrow{\backsim}}
\newcommand{\kernel}[1]{\operatorname{\mathcal{N}}{\left(#1\right)}}
\newcommand{\range}[1]{\operatorname{\mathcal{R}}{\left(#1\right)}}
\newcommand{\charpoly}[1]{\ensuremath{\det{({#1} - tI)}}}

% Linear Algebra: Often-used operators.
\DeclareMathOperator{\sgn}{\mathrm{sgn}}
\DeclareMathOperator{\sign}{\mathrm{sign}}
\DeclareMathOperator{\id}{\mathrm{id}}
\DeclareMathOperator{\spn}{\mathrm{span}}
\DeclareMathOperator{\im}{\mathrm{im}}
\DeclareMathOperator{\img}{\mathrm{img}}
\DeclareMathOperator{\sym}{\mathrm{Sym}}
\DeclareMathOperator{\Hom}{\mathrm{Hom}}
\DeclareMathOperator{\dom}{\mathrm{dom}}
\DeclareMathOperator{\cod}{\mathrm{cod}}
\DeclareMathOperator{\nullity}{\mathrm{nullity}}

% Miscellany.
\renewcommand{\ge}{\geqslant}
\renewcommand{\le}{\leqslant}

\endinput

```

