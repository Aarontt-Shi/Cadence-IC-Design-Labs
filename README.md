# Analog & Digital IC Design — Cadence PSpice and Verilog

**Design portfolio — analog/digital IC design, SPICE simulation and RTL design**

Six reports covering analog and digital IC design work. Each is documented as a self-contained
technical report (objective → theory → method → measured results → discussion), together with the
schematics, simulation setups and waveform captures produced during the work, and — for the
digital designs — the synthesizable Verilog source and testbenches.

The reports were originally authored in Word/PDF and have been re-typeset here in Markdown so that
the schematics, netlists and simulation results can be browsed directly in the browser.

---

## Repository structure

```
Cadence-IC-Design-Labs/
├── README.md                                    ← this file
├── project-01-pspice-basic-analyses/            ← PSpice: DC / AC / transient / bias-point
│   ├── README.md
│   └── figures/                                 (26 captures)
├── project-02-pspice-cmos-inverter/             ← PSpice: CMOS inverter + symbol encapsulation
│   ├── README.md
│   └── figures/                                 (41 captures)
├── project-03-verilog-full-adder/               ← Verilog: 1-bit full adder
│   ├── README.md
│   ├── rtl/full_adder.v
│   ├── tb/tb_full_adder.v
│   └── figures/                                 (16 captures)
├── project-04-verilog-boolean-cmos-gate/        ← Verilog + PSpice: compound CMOS gate
│   ├── README.md
│   ├── rtl/boolean_logic.v
│   ├── tb/tb_boolean_logic.v
│   └── figures/                                 (29 captures)
├── project-05-verilog-traffic-light/            ← Verilog: FSM traffic-light controller
│   ├── README.md
│   ├── rtl/traffic_light.v
│   ├── tb/tb_traffic_light.v
│   └── figures/                                 (16 captures)
├── project-06-verilog-pwm-siren/                ← Verilog: PWM "aria" envelope generator
│   ├── README.md
│   ├── rtl/pwm_sound_controller.v
│   ├── tb/tb_pwm_sound_controller.v
│   └── figures/                                 (13 captures)
└── original/                                    ← archived copies of the source documents
```

---

## Project index

| # | Report | Topic | EDA tools | Key deliverable |
|---|--------|-------|-----------|-----------------|
| 1 | [PSpice — basic circuit analyses](project-01-pspice-basic-analyses/README.md) | DC sweep, AC sweep, transient, bias point | Cadence OrCAD Capture CIS / PSpice 17.4 | Characterised 4 circuits; extracted β of Q2N2222 vs Q2N2220 |
| 2 | [PSpice — CMOS inverter & symbol encapsulation](project-02-pspice-cmos-inverter/README.md) | VTC, noise margin, load-capacitance delay, sub-circuit packaging | OrCAD Capture CIS, PSpice Model Editor | 41-figure study + reusable `CMOS_FZ` symbol library |
| 3 | [Verilog — 1-bit full adder](project-03-verilog-full-adder/README.md) | Dataflow RTL, exhaustive testbench, synthesis | Xilinx Vivado | `full_adder.v` + testbench + RTL schematic |
| 4 | [Verilog + PSpice — compound CMOS gate](project-04-verilog-boolean-cmos-gate/README.md) | Boolean expression in RTL and as a CMOS compound gate | Vivado, OrCAD PSpice | `boolean_logic.v` + transistor-level simulation |
| 5 | [Verilog — traffic-light controller](project-05-verilog-traffic-light/README.md) | Finite-state-machine design, clocked counter, FSM decoding | Xilinx Vivado | `traffic_light.v` + testbench + synthesis report |
| 6 | [Verilog — PWM "aria" siren](project-06-verilog-pwm-siren/README.md) | PWM duty-cycle envelope, 4-state FSM, timing budget | Xilinx Vivado | `pwm_sound_controller.v` + testbench (60 cells) |

---

## Technical skills demonstrated

| Area | Detail |
|------|--------|
| **Analog / mixed-signal simulation** | Cadence OrCAD Capture CIS + PSpice 17.4: DC sweep, AC sweep with Bode (magnitude & phase) analysis, time-domain transient analysis, static operating-point (bias) analysis |
| **Device & model handling** | Diode/Zener biasing, BJT operating-point extraction (V<sub>CEQ</sub>, I<sub>CQ</sub>, I<sub>BQ</sub>, β), MOSFET W/L sizing, PSpice Model Editor, custom `.lib` → `.olb` symbol generation |
| **Custom-symbol workflow** | Netlist export in *Create SubCircuit Format* mode, Model Editor import, `Model Import Wizard`, symbol validation in a wrapper test bench |
| **Digital RTL design** | Verilog-2001: dataflow (`assign`) and behavioural (`always @(*)`, clocked `always`) modelling, parameterised modules, finite-state machines |
| **Verification** | Exhaustive and directed testbenches, `timescale` control, `$dumpfile`/`$dumpvars`, waveform-based functional verification |
| **Synthesis & implementation** | Xilinx Vivado project flow (RTL project creation, device selection, elaboration, synthesis, RTL schematic / netlist inspection, resource-utilisation reporting) |
| **Analysis & reporting** | Parameter-sweep studies (V<sub>DD</sub>, W, L, C<sub>L</sub>), quantitative interpretation of VTC shift / slope, propagation-delay reasoning, technical write-up |

---

## Tools and environment

| Tool | Version / role |
|------|----------------|
| Cadence OrCAD Capture CIS + PSpice | 17.4 — schematic capture and SPICE simulation |
| PSpice Model Editor | 17.4 — model/library packaging |
| Xilinx Vivado | RTL entry, behavioural simulation, synthesis, RTL schematic |
| Verilog | IEEE 1364-2001 |

---

## Note on these pages

`original/` holds archived copies of the source documents (written in Chinese), kept so that the
English reports can be checked against their sources. Each Markdown report in this repository is an
English re-typesetting of the same work: the procedure is condensed, while the circuit parameters,
measured values and conclusions are preserved verbatim, and every figure from the original document
is retained in the corresponding `figures/` folder. Verilog listings shown in `rtl/` and `tb/` were
transcribed from the editor screenshots in the original documents; lines that were cropped out of a
screenshot are marked in the relevant report.

The archived files have been de-identified: personal and authoring metadata has been stripped from
the documents, and each file is named after the report it corresponds to.

| Archived file | Corresponding report |
|---------------|----------------------|
| `original/project-01-pspice-basic-analyses.docx` | Project 01 |
| `original/project-02-pspice-cmos-inverter.docx` | Project 02 |
| `original/project-03-verilog-full-adder.docx` | Project 03 |
| `original/project-04-verilog-boolean-cmos-gate.docx` | Project 04 |
| `original/project-05-verilog-traffic-light.docx` | Project 05 |
| `original/project-06-verilog-pwm-siren.pdf` | Project 06 |
