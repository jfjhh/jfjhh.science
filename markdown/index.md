---
title: 'Building a Spectrum Analyzer?'
subtitle: 'Fun with RF'
author:
- Alex Striff
date: 2018-09-04
---

Abstract
========

Why buy an expensive spectrum analyzer when you can make one with the circuitry
of a simple sweeped superheterodyne radio reciever and an old analog
oscilloscope? **Answer:** It's harder than I thought. This page should hopefully
contain updates as I progress on my RF journey.

Voltage Controlled Oscillator
=============================

**TODO:** Actually finish building a working high-level VCO for frequency
conversion.

![Colpitts Oscillator Schematic 1](img/colpitts-1.png)

**Schematic Notes:** The load outside of the box simulates the $10x$ probe. The
transistor's $C_{be}$ completes the Colpitts oscillator. The inductor resistor
(not in actual circuit) was tweaked until the simulation output looked somewhat
like what was observed. It is needed to simulate various losses. Otherwise,
unrealistic things happen, like the base voltage going wildly negative. Finally,
the small base capacitor also accounts for some of the additional stray
capacitance.

**Simulation:** $f = 91.33671\;MHz$, $\Delta V_{pp} = 326.25\;mV$. The emitter
signal is similar to what was measured on the real circuit.

![Emitter Signal: Low Magnification](img/colpitts-ngspice-low.png)
![Emitter Signal: Medium Magnification](img/colpitts-ngspice-medium.png)
![Emitter Signal: High Magnification](img/colpitts-ngspice-high.png)

