---
title: 'Building a Spectrum Analyzer?'
subtitle: 'Fun with RF'
author:
- Alex Striff
date: 2018-09-07
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

This is the result of my first design attempt:

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

**Reality:** The board sucks, and I don't just mean the soldering to the ground
plane. I get $75 - 85\;MHz$ over the tuning range of $1 - 11.5\;V$, and for some
reason the circuit is incredibly sensitive to both loading and external objects,
as it is unshielded. The other transistors are another follower and a
common-base amplifier, but neither of them work because they load down the
oscillator (transistor not visible) too much when connected, to the point where
the oscillation dies out immediately. With only the additional follower
connected, the oscillation *still* dies out, but slowly over about $10\;s$, and
can be restarted if the board is tapped. Clearly some more work needs to be
done.

![Colpitts Board](img/colpitts-board.jpg)

