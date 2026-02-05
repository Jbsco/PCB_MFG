-------------------------------------------------------
# KiCAD Tips (for Genmitsu CNC 3018-PRO)

This section provides practical guidelines to reduce common **design and manufacturing issues** when milling PCBs designed in **KiCAD** using the **Genmitsu CNC 3018-PRO** CNC machine
([Amazon link](https://www.amazon.com/Genmitsu-3018-PRO-Control-Engraving-300x180x45mm/dp/B07P6K9BL3)).

<p align="center">
  <img src="./images/GenmitsuCNC3018.png" width="350" title="Genmitsu CNC 3018-PRO">
</p>

The **Genmitsu CNC 3018-PRO** is an entry-level, desktop, 3-axis CNC router intended for hobbyists, students, and educational environments. It has a working area of approximately **300 × 180 × 45 mm**, uses a 775 spindle motor, and is controlled via GRBL firmware. The machine is commonly used for engraving and light milling of materials such as wood, plastics, acrylic, **PCB copper boards**, and soft aluminum. While affordable and relatively easy to assemble, it is designed for **prototyping and learning**, not industrial-grade PCB manufacturing.

Although the machine offers reasonable precision, PCB milling imposes strict constraints on **trace width, clearance, and pad size**. Inadequate values can easily result in short circuits, broken traces, or partially milled pads.

## KiCAD Design Guidelines for CNC Milling

Below is an example of a KiCAD PCB layout that follows the recommended guidelines for CNC milling:

<p align="center">
  <img src="./images/Kicad_PCB_example_00.png" width="350" title="KiCAD PCB example following CNC milling guidelines">
</p>

### Trace Width and Clearance
- Avoid thin traces whenever possible.
- Recommended minimum values for reliable milling:
  - **Trace width:** ≥ **1.0 mm**
    *(Left-click the trace → Properties (E) → Set Track Width to 1 mm)*

  - **Clearance:** ≥ **0.5 mm**
    *(File → Board Setup → Design Rules → Constraints → Minimum Clearance → 0.5 mm)*

- Traces placed too close together may not be fully isolated during milling, leading to **short circuits**.

### Pads and Through-Hole Components
- Through-hole components generally work well on the 3018-PRO, but **pad sizes must be increased**.
- Pads that are too small may be partially removed during isolation milling, resulting in unreliable electrical connections.

- Use **larger rectangular pads** for improved milling results:
  *(Left-click pad → Right-click → Properties (E) → Pad Shape → Rectangular → Size = 2 mm)*

- To apply the same pad settings to all pads:
  1. Right-click the modified pad → **Copy Pad Properties to Default**
  2. Select the remaining pads (**Ctrl + Left-click**)
  3. Right-click → **Paste Default Pad Properties to Selected**

- For **ground planes**, set pad connections to **Solid**:
  *(Left-click pad → Right-click → Properties (E) → Connections → Pad Connection → Solid)*
  This ensures the pad is removed, leaving only the drilled hole.

### Jumpers
- Jumpers can be added directly from the **KiCAD symbol library**.
- The schematic example below shows a jumper implementation:

<p align="center">
  <img src="./images/Kicad_PCB_example_01.png" width="350" title="KiCAD schematic jumper example">
</p>

- In the PCB layout (`.kicad_pcb`), a jumper can be implemented using a **resistor footprint**.
- To avoid **Design Rule Check (DRC)** errors, connect the resistor pads with a shortcut trace on the **top copper layer (red)**, as shown below:

<p align="center">
  <img src="./images/Kicad_PCB_example_03.png" width="350" title="PCB jumper implemented using resistor footprint">
</p>

### Board Complexity
- **Single-sided boards** are strongly recommended for use with the Genmitsu CNC 3018-PRO.
- Double-sided boards require precise alignment and are significantly more difficult to mill reliably.

### Final Checks
- Always run **Design Rule Check (DRC)** in KiCAD before exporting fabrication files.
