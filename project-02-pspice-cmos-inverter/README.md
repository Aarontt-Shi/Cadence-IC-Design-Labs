# Project 02 — CMOS Inverter: Static & Dynamic Characterisation with PSpice

> Source document: *实验二 PSpice 仿真（2）*
> Toolchain: Cadence OrCAD Capture CIS / PSpice 17.4

---

## 1. Objective

1. Use Cadence OrCAD PSpice for advanced circuit design and simulation.
2. Learn to **encapsulate a schematic as a reusable symbol** (sub-circuit + custom part library) in OrCAD.
3. Study the structure, operating principle and simulation methodology of a **CMOS inverter**.

---

## 2. Background

### 2.1 The PSpice Model Editor

PSpice ships with a model conversion and editing tool, the **Model Editor**, which converts externally supplied model parameter files into PSpice model files and can generate a corresponding symbol for them. A complete model-creation and application cycle has three stages:

1. Import the model file.
2. Build the model symbol.
3. Apply the model in a simulation.

### 2.2 CMOS inverter operating principle

The CMOS inverter is a pair of complementary MOSFETs:

- **PMOS** — source tied to the supply rail (V<sub>DD</sub>), drain joined to the NMOS drain to form the output V<sub>out</sub>.
- **NMOS** — source tied to ground, drain joined to the PMOS drain.
- **Gates** — both gates are tied together and form the input V<sub>in</sub>.

| Input | PMOS | NMOS | Output |
|-------|------|------|--------|
| V<sub>in</sub> = 0 V | V<sub>GS,P</sub> = −V<sub>DD</sub> → **on** | V<sub>GS,N</sub> = 0 V → **off** | pulled up to V<sub>DD</sub> → logic **1** |
| V<sub>in</sub> = V<sub>DD</sub> | V<sub>GS,P</sub> = 0 V → **off** | V<sub>GS,N</sub> = V<sub>DD</sub> → **on** | pulled down to GND → logic **0** |

**Core characteristics**

1. **Zero static power** — in either stable state one device is always off, so there is no d.c. path from V<sub>DD</sub> to ground.
2. **Rail-to-rail output** — the output reaches the full 0 V and V<sub>DD</sub>.
3. **Extremely high input impedance** — the gate is an insulator and draws essentially no current.

**Switching behaviour**

- Input low → high: the PMOS turns off progressively while the NMOS turns on; the output discharges to ground through the NMOS.
- Input high → low: the NMOS turns off progressively while the PMOS turns on; the output charges from V<sub>DD</sub> through the PMOS.

**Sizing**

The PMOS is normally made wider than the NMOS (in this experiment **W<sub>p</sub> = 1.275 µm vs. W<sub>n</sub> = 0.375 µm**) because hole mobility is lower than electron mobility and the larger geometry compensates for it. This balances the two devices (β<sub>n</sub> ≈ β<sub>p</sub>) and equalises the rise and fall times.

<p align="center">
  <img src="figures/fig-01-cmos-inverter-operation.png" width="620" alt="CMOS inverter operating states">
  <br><em>Conduction states of the CMOS inverter.</em>
</p>
<p align="center">
  <img src="figures/fig-02-cmos-inverter-reference-circuit.png" width="560" alt="CMOS inverter reference circuit">
  <br><em>Reference simulation circuit.</em>
</p>

### 2.3 Static characteristics in a word

The static characteristic of a CMOS inverter describes its behaviour when input and output are both settled — i.e. the voltage transfer characteristic (VTC), the noise margins and the static power. The VTC relates V<sub>in</sub> to V<sub>out</sub> and determines the logic threshold, the transition-region gain and hence the circuit's noise immunity.

<p align="center">
  <img src="figures/fig-03-vtc-concept.png" width="620" alt="Voltage transfer characteristic">
  <br><em>Voltage transfer characteristic (VTC) of a CMOS inverter.</em>
</p>

---

## 3. Method and results

### 3.1 Part I — Designing the CMOS inverter and encapsulating it as a symbol

#### 3.1.1 Schematic entry

In Cadence OrCAD Capture CIS a new project was created and the inverter was built from **`MBreakN`** (NMOS) and **`MBreakP`** (PMOS). Device dimensions were set to

| Device | W | L |
|--------|---|----|
| NMOS | 0.375 µm | 0.25 µm |
| PMOS | 1.275 µm | 0.25 µm |

VCC, GND, V<sub>in</sub> and V<sub>out</sub> were wired up, and **`PortBoth-L`** symbols were placed to create the external ports required for encapsulation. Note that **GND must be connected even inside a sub-circuit**, otherwise the design cannot be simulated. Device parameters were edited by double-clicking the transistor and applying `W` and `L` in the parameter dialog (**Apply** must be clicked to commit the change).

<p align="center">
  <img src="figures/fig-04-inverter-schematic-ports.png" width="620" alt="Inverter schematic with ports">
  <br><em>Inverter schematic with the external ports used for packaging.</em>
</p>
<p align="center">
  <img src="figures/fig-05-wl-parameter-setting.png" width="620" alt="W/L parameter setting">
  <br><em>Setting the W and L parameters on the MOS devices.</em>
</p>

#### 3.1.2 Generating the sub-circuit netlist

`Tools ▸ Create Netlist` was used with the default output path and the PSpice option **“Create SubCircuit Format Netlist”** ticked (Descend mode kept). This turns the current sheet into a standard, re-callable sub-circuit block.

<p align="center">
  <img src="figures/fig-06-netlist-subcircuit-options.png" width="620" alt="Netlist generation options">
  <br><em>Netlist generation options — sub-circuit format selected.</em>
</p>

#### 3.1.3 Converting the netlist into a Capture symbol

The PSpice **Model Editor** was opened and the generated netlist library was loaded, then exported to a Capture part library:

1. `File ▸ Open…` → select the `.lib` file created by the netlist step.
2. `File ▸ Export to Capture Part Library…` → keep the default in/out paths, click **OK**; a `.olb` part library is generated.
3. `File ▸ Model Import Wizard [Capture]` → confirm the default library path and `.olb` directory, review the generated symbol, and click **Finish**. With no errors reported in the log, the encapsulation is complete.

| Step | Figure |
|------|--------|
| Model Editor | [fig-07](figures/fig-07-pspice-model-editor.png) |
| Opening the custom library | [fig-08](figures/fig-08-model-editor-open-lib.png) |
| Selecting the generated `.lib` | [fig-09](figures/fig-09-lib-file-selected.png) |
| Export to Capture part library | [fig-10](figures/fig-10-export-to-capture-part-library.png) |
| Model Import Wizard | [fig-11](figures/fig-11-model-import-wizard.png) |
| Generated symbol | [fig-12](figures/fig-12-generated-part-symbol.png) |

<p align="center">
  <img src="figures/fig-12-generated-part-symbol.png" width="620" alt="Generated part symbol">
  <br><em>The generated CMOS inverter symbol — pin connectivity verified before saving.</em>
</p>

#### 3.1.4 Wrapper test bench — static behaviour

A new project was created and the custom part was added through `Place Part ▸ Add Library` → the `.olb` file.

<p align="center">
  <img src="figures/fig-14-wrapped-inverter-static-schematic.png" width="640" alt="Wrapper test schematic">
  <br><em>Wrapper test bench used to verify the encapsulated inverter.</em>
</p>

Simulation profile: **Analysis type = DC Sweep**, **Options = Primary Sweep**, source **V2** swept **0 → 5 V in 0.01 V steps**. Crucially, the packaged library **`CMOS_FZ.LIB`** had to be added under `Configuration Files ▸ Filename ▸ Browse ▸ Library`, otherwise the simulation cannot resolve the sub-circuit.

<p align="center">
  <img src="figures/fig-15-configuration-files-library.png" width="640" alt="Adding the library to the simulation profile">
  <br><em>Adding <code>CMOS_FZ.LIB</code> to the simulation profile.</em>
</p>

`Trace ▸ Add Trace ▸ V(out)` gives the VTC of the *packaged* inverter:

<p align="center">
  <img src="figures/fig-16-wrapped-inverter-vtc.png" width="640" alt="VTC of the packaged inverter">
  <br><em>Static VTC of the encapsulated inverter — matches the un-packaged reference.</em>
</p>

#### 3.1.5 Wrapper test bench — dynamic behaviour

Replacing the DC source with a pulse source gives the dynamic response, plotted as V(out) together with V(in):

<p align="center">
  <img src="figures/fig-17-wrapped-inverter-pulse-schematic.png" width="620" alt="Pulse-source test schematic">
  <br><em>Wrapper test bench driven by a pulse source.</em>
</p>
<p align="center">
  <img src="figures/fig-18-wrapped-inverter-transient.png" width="640" alt="Transient response of the packaged inverter">
  <br><em>Dynamic response of the encapsulated inverter — behaviour is as expected, confirming that the packaging preserved the electrical characteristics.</em>
</p>

### 3.2 Part II — Static characteristics of the CMOS inverter

<p align="center">
  <img src="figures/fig-19-static-analysis-schematic.png" width="620" alt="Static analysis schematic">
  <br><em>Schematic for the DC sweep (devices sized as above).</em>
</p>

**Analysis type = DC Sweep**, **Primary Sweep**, source **V1** swept **0 → 6 V in 0.01 V steps**. `V(out)` and `V(in)` were plotted together:

<p align="center">
  <img src="figures/fig-21-vtc-vin-vs-vout.png" width="640" alt="VTC Vout vs Vin">
  <br><em>Voltage transfer characteristic of the CMOS inverter.</em>
</p>

**Reading the curve.** For low V<sub>in</sub> the output sits near V<sub>DD</sub> — the inverter outputs a logic high. As V<sub>in</sub> rises the output begins to fall; as V<sub>in</sub> approaches V<sub>DD</sub>/2 the output collapses steeply — the **transition (threshold) region**. Above that threshold the output approaches 0 V, i.e. a logic low.

#### 3.2.1 Effect of the supply voltage

Five runs were made with **V1 = V2 = 1 V, 2 V, 3 V, 4 V, 5 V**:

<p align="center">
  <img src="figures/fig-22-vtc-vs-vdd.png" width="640" alt="VTC vs VDD">
  <br><em>VTC family for V<sub>DD</sub> = 1 V … 5 V.</em>
</p>

The family of curves shows a systematic shift: as V<sub>DD</sub> increases from 1 V to 5 V the **transition region moves to the right** and the **threshold voltage V<sub>th</sub> increases**, while the **slope in the transition region (i.e. the gain) also increases**. Physically this is the modulation of the inverter's switching behaviour by the supply: at a higher V<sub>DD</sub> a larger input voltage is needed to flip the state, and the device transconductance g<sub>m</sub> is enhanced, sharpening the transition.

#### 3.2.2 Effect of device geometry (W and L)

| Case | Change | Figure |
|------|--------|--------|
| NMOS W | 0.375 µm → **0.7 µm** | [fig-23](figures/fig-23-nmos-w-variation.png) |
| PMOS W | 1.275 µm → **2 µm** | [fig-24](figures/fig-24-pmos-w-variation.png) |
| NMOS L | 0.25 µm → **0.5 µm** | [fig-25](figures/fig-25-nmos-l-variation.png) |
| PMOS L | 0.25 µm → **0.5 µm** | [fig-26](figures/fig-26-pmos-l-variation.png) |

In each figure the **red** curve is the original characteristic and the **green** curve the modified one.

<p align="center">
  <img src="figures/fig-23-nmos-w-variation.png" width="600" alt="NMOS W variation">
  <br><em>NMOS W = 0.375 µm (red) vs. 0.7 µm (green).</em>
</p>
<p align="center">
  <img src="figures/fig-24-pmos-w-variation.png" width="600" alt="PMOS W variation">
  <br><em>PMOS W = 1.275 µm (red) vs. 2 µm (green).</em>
</p>

**Discussion — channel width W**

- *Widening the NMOS* raises its saturation current (a wider device carries more current), **reduces the fall time** (a stronger NMOS discharges the load capacitance faster) and **increases the slope of the transition region**, i.e. the inverter gain.
- *Widening the PMOS* raises its saturation current and **reduces the rise time** (a stronger PMOS charges the load capacitance faster).

<p align="center">
  <img src="figures/fig-25-nmos-l-variation.png" width="600" alt="NMOS L variation">
  <br><em>NMOS L = 0.25 µm (red) vs. 0.5 µm (green).</em>
</p>
<p align="center">
  <img src="figures/fig-26-pmos-l-variation.png" width="600" alt="PMOS L variation">
  <br><em>PMOS L = 0.25 µm (red) vs. 0.5 µm (green).</em>
</p>

**Discussion — channel length L**

- *Shortening L* increases the saturation current (short-channel effects), can **lower the threshold voltage**, and shortens both rise and fall times because the device turns on more easily.
- *Lengthening L* lowers the saturation current (a longer channel means a higher channel resistance), tends to **raise the threshold voltage**, and lengthens rise/fall times because a higher gate voltage is needed to turn the device on.

### 3.3 Part III — Dynamic characteristics of the CMOS inverter

<p align="center">
  <img src="figures/fig-27-transient-schematic.png" width="620" alt="Transient schematic">
  <br><em>Load-capacitance test bench.</em>
</p>

**Analysis type = Time Domain**, **Options = General Settings**, start time 0, **total duration 100 ms**. With **C = 30 nF** the output was observed as V(out), and the input V(in) was added in a second plot (`Plot ▸ Add Plot to Window`):

<p align="center">
  <img src="figures/fig-29-c30nf-waveform.png" width="640" alt="C = 30 nF waveform">
  <br><em>Input and output waveforms, C = 30 nF.</em>
</p>

To quantify the effect of the load, the simulation was repeated for **C = 3 nF, 30 nF and 300 nF**:

<p align="center">
  <img src="figures/fig-30-c3nf-waveform.png" width="620" alt="C = 3 nF">
  <br><em>C = 3 nF.</em>
</p>
<p align="center">
  <img src="figures/fig-31-c30nf-waveform-repeat.png" width="620" alt="C = 30 nF">
  <br><em>C = 30 nF.</em>
</p>
<p align="center">
  <img src="figures/fig-32-c300nf-waveform.png" width="620" alt="C = 300 nF">
  <br><em>C = 300 nF.</em>
</p>

**Discussion — load capacitance C<sub>L</sub>**

| Case | Observed behaviour |
|------|--------------------|
| **C<sub>L</sub> = 3 nF (small)** | Steep rise/fall edges; average propagation delay t<sub>pd</sub> below 10 ns; small charge/discharge time constant τ ≈ RC. High-speed response. |
| **C<sub>L</sub> = 300 nF (large)** | Rise/fall times lengthened by roughly two orders of magnitude; propagation delay increases into the microsecond range; τ grows strongly; visible waveform degradation (reduced slope). |

The load capacitance is inversely related to circuit speed (t<sub>pd</sub> ∝ C<sub>L</sub>). The physical origin is that the charge/discharge current is I = C<sub>L</sub> · dV/dt: a larger C<sub>L</sub> requires a longer charge/discharge time for a given transistor current, which directly degrades the propagation delay and therefore the maximum operating frequency.

### 3.4 Part IV — Packaging the inverter into the SPICE model library

The packaging flow of §3.1 was repeated as a standalone exercise. The schematic sheet was renamed **`CMOS_FZ`**, then `Place Port` → **`PORTBOTH-L/CAPSYM`** was used to add the external ports to the supply-less, output-port-less simulation schematic.

| Step | Figure |
|------|--------|
| Complete symbol-level schematic (ports removed from the simulation sheet) | [fig-33](figures/fig-33-symbol-level-schematic.png) |
| `Tools ▸ Create Netlist` with sub-circuit output | [fig-34](figures/fig-34-create-netlist-dialog.png) |
| Model Editor menu (Capture ▸ Done) | [fig-35](figures/fig-35-model-editor-open.png) |
| `File ▸ Open` → `CMOS` added to the Model List | [fig-36](figures/fig-36-model-import-wizard.png) |
| Final encapsulated part symbol | [fig-37](figures/fig-37-part-symbol-generated.png) |
| Wrapper test bench `CMOS_FZ_TEST` | [fig-38](figures/fig-38-wrapper-test-schematic.png) |

A dedicated wrapper project **`CMOS_FZ_TEST`** was then created to test the packaged part:

<p align="center">
  <img src="figures/fig-38-wrapper-test-schematic.png" width="620" alt="CMOS_FZ_TEST wrapper">
  <br><em>Wrapper test bench for the packaged <code>CMOS_FZ</code> part.</em>
</p>
<p align="center">
  <img src="figures/fig-39-wrapper-vtc.png" width="640" alt="Packaged part VTC">
  <br><em>Static VTC obtained from the packaged symbol (DC sweep, V2 = 0–5 V, 0.01 V step).</em>
</p>
<p align="center">
  <img src="figures/fig-40-wrapper-transient-schematic.png" width="620" alt="Wrapper transient schematic">
  <br><em>Pulse-source version of the wrapper test bench.</em>
</p>
<p align="center">
  <img src="figures/fig-41-wrapper-transient-result.png" width="640" alt="Wrapper transient result">
  <br><em>Dynamic response of the packaged part — consistent with the flat schematic.</em>
</p>

---

## 4. Discussion

- **Encapsulation works only if the electrical environment is preserved.** The two errors that cost the most time were file-path problems during export and a missing `CMOS_FZ.LIB` entry in the simulation profile. Both are *configuration* failures, not design failures — and both cause a simulation that simply cannot resolve the sub-circuit. Checking that a packaged part reproduces the flat schematic (fig-16 / fig-39) is the only reliable acceptance test.
- **The VTC is a design surface, not a single curve.** Sweeping V<sub>DD</sub>, W and L mapped the inverter's behaviour onto a family of characteristics: supply voltage translates the threshold and sharpens the transition; device width moves the trip point (because it changes the β<sub>n</sub>/β<sub>p</sub> balance) and the gain; device length mainly changes drive strength and threshold.
- **Speed is set by the load, not by the logic.** The 100× increase in C<sub>L</sub> produced roughly a 100× increase in delay, confirming t<sub>pd</sub> ∝ C<sub>L</sub> and the I = C<sub>L</sub>dV/dt relationship. In a real design the fan-out, interconnect and pad capacitance therefore dominate the achievable clock frequency.
- **There is a genuine trade-off surface.** Making the devices wider improves drive and raises gain, but increases gate and diffusion capacitance and therefore dynamic power and self-loading. The sizing chosen here (W<sub>p</sub>/W<sub>n</sub> ≈ 3.4) is the standard mobility-compensation compromise rather than an optimum for any single metric.

## 5. Conclusions and reflection

This laboratory was the first time the full *design → package → verify* chain of an IC design flow was executed end to end. Three things carried over into later work:

1. **Parameterised studies.** Changing one variable at a time (V<sub>DD</sub>, then W, then L, then C<sub>L</sub>) and reading the delta off the curve is the most efficient way to build intuition for a circuit, and it scales directly to SPICE corner analysis.
2. **Attention to detail in tooling.** Wrong file paths, un-imported model parameters and unconnected grounds each blocked the flow. Precision in the tool configuration is as important as precision in the circuit.
3. **Explicit trade-off reasoning.** Raising switching speed costs power; increasing load drive costs area and speed. Design is the act of choosing a point on that surface for a given application, not of maximising any single figure of merit.

---

## Appendix — full figure gallery

<details>
<summary><strong>Click to expand all 41 captures from this laboratory</strong></summary>

| # | Figure | Description |
|---|--------|-------------|
| 01 | ![](figures/fig-01-cmos-inverter-operation.png) | CMOS inverter conduction states |
| 02 | ![](figures/fig-02-cmos-inverter-reference-circuit.png) | Reference circuit |
| 03 | ![](figures/fig-03-vtc-concept.png) | VTC concept |
| 04 | ![](figures/fig-04-inverter-schematic-ports.png) | Inverter schematic with ports |
| 05 | ![](figures/fig-05-wl-parameter-setting.png) | W/L parameter entry |
| 06 | ![](figures/fig-06-netlist-subcircuit-options.png) | Netlist options |
| 07 | ![](figures/fig-07-pspice-model-editor.png) | PSpice Model Editor |
| 08 | ![](figures/fig-08-model-editor-open-lib.png) | Opening the library |
| 09 | ![](figures/fig-09-lib-file-selected.png) | `.lib` file selected |
| 10 | ![](figures/fig-10-export-to-capture-part-library.png) | Export to Capture part library |
| 11 | ![](figures/fig-11-model-import-wizard.png) | Model Import Wizard |
| 12 | ![](figures/fig-12-generated-part-symbol.png) | Generated symbol |
| 13 | ![](figures/fig-13-add-custom-library.png) | Adding the custom library |
| 14 | ![](figures/fig-14-wrapped-inverter-static-schematic.png) | Wrapper static test bench |
| 15 | ![](figures/fig-15-configuration-files-library.png) | Configuration Files → Library |
| 16 | ![](figures/fig-16-wrapped-inverter-vtc.png) | Packaged inverter VTC |
| 17 | ![](figures/fig-17-wrapped-inverter-pulse-schematic.png) | Pulse-source wrapper |
| 18 | ![](figures/fig-18-wrapped-inverter-transient.png) | Packaged inverter transient |
| 19 | ![](figures/fig-19-static-analysis-schematic.png) | Static analysis schematic |
| 20 | ![](figures/fig-20-dc-sweep-settings.png) | DC sweep settings |
| 21 | ![](figures/fig-21-vtc-vin-vs-vout.png) | V<sub>out</sub> vs V<sub>in</sub> |
| 22 | ![](figures/fig-22-vtc-vs-vdd.png) | VTC vs V<sub>DD</sub> |
| 23 | ![](figures/fig-23-nmos-w-variation.png) | NMOS W variation |
| 24 | ![](figures/fig-24-pmos-w-variation.png) | PMOS W variation |
| 25 | ![](figures/fig-25-nmos-l-variation.png) | NMOS L variation |
| 26 | ![](figures/fig-26-pmos-l-variation.png) | PMOS L variation |
| 27 | ![](figures/fig-27-transient-schematic.png) | Transient schematic |
| 28 | ![](figures/fig-28-transient-settings.png) | Transient settings |
| 29 | ![](figures/fig-29-c30nf-waveform.png) | C = 30 nF |
| 30 | ![](figures/fig-30-c3nf-waveform.png) | C = 3 nF |
| 31 | ![](figures/fig-31-c30nf-waveform-repeat.png) | C = 30 nF (repeat) |
| 32 | ![](figures/fig-32-c300nf-waveform.png) | C = 300 nF |
| 33 | ![](figures/fig-33-symbol-level-schematic.png) | Symbol-level schematic |
| 34 | ![](figures/fig-34-create-netlist-dialog.png) | Create Netlist dialog |
| 35 | ![](figures/fig-35-model-editor-open.png) | Model Editor |
| 36 | ![](figures/fig-36-model-import-wizard.png) | Model Import Wizard |
| 37 | ![](figures/fig-37-part-symbol-generated.png) | Part symbol generated |
| 38 | ![](figures/fig-38-wrapper-test-schematic.png) | `CMOS_FZ_TEST` wrapper |
| 39 | ![](figures/fig-39-wrapper-vtc.png) | Packaged part VTC |
| 40 | ![](figures/fig-40-wrapper-transient-schematic.png) | Wrapper transient schematic |
| 41 | ![](figures/fig-41-wrapper-transient-result.png) | Wrapper transient result |

</details>
