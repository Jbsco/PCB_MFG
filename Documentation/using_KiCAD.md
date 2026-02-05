# Using KiCAD
Designs start in a KiCAD project. It is possible to start immediately within the PCB editor, however there are advantages to working within a project file and creating a schematic first.

The schematic editor looks and functions similarly to SPICE software, with usability improvements as well as functionality beneficial to full-stack design work. Components may be added to the KiCAD library, but the existing library is sufficient for intermediate designs. Components can be assigned a footprint, which also often includes a 3D model for rendering visuals and checking 3D space conflicts. Python script support extends functionality and allows for some automation, but is not necessary to produce competent results.

<p align="center">
  <img src="./images/KiCAD_Schematic.png" width="350" title="Example Schematic Design in KiCAD">
</p>

The PCB board editor can be entered from the schematic editor. The two documents are linked, and components in the schematic will be inserted into the board editor as footprints. Use the hotkey "F8" or select "Tools → Update PCB from Schematic", this will place missing footprints. Circuit nets are also shared between the documents. It is possible to auto-place footprints, but it is recommended to manually adjust and rotate components accordingly to make routing easier. The board editor has many layers to manipulate. Most important for prototyping purposes are the top copper layer and the edge cuts layer. The bottom layer and multiple layers beyond this are also accessible (board stackup settings may be edited at any time). Additional vias and PCB specific components that are not typically present on a circuit schematic can be placed in the same manner as in the schematic editor, with a large default library to explore. Pin headers, I/O vias and pads, connectors, and even active trace elements such as Bluetooth or tuned antennae are present and waiting for application in student projects!

<p align="center">
  <img src="./images/KiCAD_PCB.png" width="350" title="Circuit Board Design in KiCAD">
</p>

Once a board design is ready to export, _the process will diverge depending on whether you are ingesting **gerber fabrication files with FlatCAM**, or **SVG files with Inkscape and jscut**. Both are effective for prototyping, though the SVG method tested poorly among students. If you opt to go this route, export your copper layer in color, select only the board area, and include edge cuts if you need those outlined in the milling operation. Otherwise, select "File → Fabrication Outputs → Gerbers" and select the layer you are working with. Default settings were found to work well. Select "Plot to create the Gerber file, and then select "Generate Drill Files" (being sure "Drill Units" is set to millimeters) to create the drill Excellon file. Default settings here were also found to work well. Several files are created, however we will only use two in FlatCAM.

Next Tutorial: [Using FlatCAM](./using_FlatCAM.md)

-------------------------------------------------------
# KiCad Tips (for Genmitsu CNC 3018-PRO)

This section provides practical guidelines to reduce common **design and manufacturing issues** when milling PCBs designed in **KiCad** using the **Genmitsu CNC 3018-PRO** CNC machine
([Amazon link](https://www.amazon.com/Genmitsu-3018-PRO-Control-Engraving-300x180x45mm/dp/B07P6K9BL3)).

<p align="center">
  <img src="./images/GenmitsuCNC3018.png" width="350" title="Genmitsu CNC 3018-PRO">
</p>

The **Genmitsu CNC 3018-PRO** is an entry-level, desktop, 3-axis CNC router intended for hobbyists, students, and educational environments. It has a working area of approximately **300 × 180 × 45 mm**, uses a 775 spindle motor, and is controlled via GRBL firmware. The machine is commonly used for engraving and light milling of materials such as wood, plastics, acrylic, **PCB copper boards**, and soft aluminum. While affordable and relatively easy to assemble, it is designed for **prototyping and learning**, not industrial-grade PCB manufacturing.

Although the machine offers reasonable precision, PCB milling imposes strict constraints on **trace width, clearance, and pad size**. Inadequate values can easily result in short circuits, broken traces, or partially milled pads.

## KiCad Design Guidelines for CNC Milling

Below is an example of a KiCad PCB layout that follows the recommended guidelines for CNC milling:

<p align="center">
  <img src="./images/Kicad_PCB_example_00.png" width="350" title="KiCad PCB example following CNC milling guidelines">
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
- Jumpers can be added directly from the **KiCad symbol library**.
- The schematic example below shows a jumper implementation:

<p align="center">
  <img src="./images/Kicad_PCB_example_01.png" width="350" title="KiCad schematic jumper example">
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
- Always run **Design Rule Check (DRC)** in KiCad before exporting fabrication files.


