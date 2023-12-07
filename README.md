# PCB_MFG
This repository was created for working with and improving the PCB design and production process using resources provided by the University of Colorado Boulder Partnership Program on the Colorado Mesa University campus. These resources are made available to students and faculty alike.

## Introduction
PCB production is in the process of being made more accesible to students and faculty. Desktop CNC machines are available in labs at Confluence Hall which have the capacity to produce good quality single-sided designs, as well as double-sided designs (with some additional effort), with low/no cost for students and faculty. Efforts have been made to reduce complexity and improve ease-of-use by developing a consistent and repeatable process that produces usable results in a shorter time-frame than ordering from third-party prototyping services.

## Tools & Software Used
The CNC machines located in Confluence Hall labs are being made available for specific projects by faculty permission, and may be made more widely available in the future. Discuss access with faculty and ensure thorough understanding of the equipment, materials, and lab policies before use - you will gain valuable assistance and knowledge to improve your results and ensure that these resources remain effective and safe for use.

### Genmitsu 3018 Pro Desktop CNC Machines

These tools are available on Github and were found to be effective for each part of the process detailed within this repository. System compatibility was a priority as was open-source status.

### https://github.com/Denvi/Candle CNC control and heightmapping software (Windows or Linux)

### https://github.com/tbfleming/jscut (https://jscut.org/) SVG intake, toolpathing, and GCode output (in-browser)

### https://github.com/inkscape/inkscape SVG preparation for JSCut (Windows, Linux, MacOSX)

### https://github.com/KiCad (https://gitlab.com/kicad/) Schematic & PCB design software, simulation, SVG output (Docker, Windows, Linux, MacOS)

## Process
It is recommended to have access to the above software. As they have their own release channels please refer to their documentation. Generally, Candle, Inkscape, and KiCAD are installed software, while JScut is accesible from a browser such as Chome or Firefox. Drivers for the 3018 CNC machine may need to be installed for communication through Candle, these may be found on the Sainsmart site.

### KiCad
Designs start in a KiCAD project. It is possible to start immediately within the PCB editor, however there are advantages to working within a project file and creating a schematic first.

The schematic editor looks and functions similarly to SPICE software, with usability improvements as well as functionality beneficial to full-stack design work. Components may be added to the KiCAD library, but the existing library is sufficient for intermediate designs. Components can be assigned a footprint, which also often includes a 3D model for rendering visuals and checking 3D space conflicts. Python script support extends functionality and allows for some automation, but is not necessary to produce competent results.

<p align="center">
  <img src="Example/KiCAD_Schematic.png" width="350" title="Example Schematic Design in KiCAD">
</p>

The PCB board editor can be entered from the schematic editor. The two documents are linked, and components in the schematic will be inserted into the board editor as footprints. Circuit nets are also shared between the documents. It is possible to auto-place footprints, but it is recommended to manually adjust and rotate components accordingly to make routing easier. The board editor has many layers to manipulate. Most important for prototyping purposes are the top copper layer and the edge cuts layer. The bottom layer and multiple layers beyond this are also accesible (board stackup settings may be edited at any time). Additional vias and PCB specific components that are not typically present on a circuit schematic can be placed in the same manner as in the schematic editor, with a large default library to explore. Pin headers, I/O vias and pads, connectors, and even active trace elements such as Bluetooth or tuned antennae are present and waiting for application in student projects!

<p align="center">
  <img src="Example/KiCAD_PCB.png" width="350" title="Circuit Board Design in KiCAD">
</p>

Once a board design is ready to export, SVG output of individual layers is achieved in the "File → Export → SVG" menu option and selecting each layer to export. For this process it is recommended to select the "Color" and "Board Area Only" radio button options, as well as checking "Print one page per layer". These options have been tested as most compatible when exporting to Inkscape and then JScut for Gcode generation.

### Inkscape
Each SVG file can be opened in Inkscape to make these files compatible with JScut. This process is brief, and consists of converting all objects present in the SVG into path objects. Select all objects in the graphic area and select the "Path → Object to Path" menu option, followed by the "Path → Stroke to Path" menu option. Exporting this as an SVG with a transparent background is sufficient to progress to JScut.

<p align="center">
  <img src="Example/Filter_DualOp-F_Cu.png" width="350" title="Example SVG Output from Inkscape">
</p>

### JScut
JScut ingests an SVG files and allows configuring various types of toolpaths followed by export to Gcode. Since the PCB milling operation is a single pass at 0.1mm depth-of-cut (and potentially a second operation for via holes), many settings are unused.

•  It is recommended to select "Make all mm", set Tool Diameter to 0.1mm, set Pass Depth to 0.1mm, set Rapid to 1000mm/min, and set Plunge and Cut to 100mm/min, before moving on to Operations.

•  Select "Open SVG → Local" to open the SVG file exported from Inkscape. If the copper layer graphic does not appear as expected, or appears incomplete or cut off, adjust Inkscape export settings accordingly.

•  If all appears as expected, begin selecting path objects in the graphic to create Operations. Multiple Operations can be created per group of objects selected, for example, select all pad and via holes and select "Create Operation", followed by the "Pocket" drop-down option, and a value of "0.1" for the Deep field. The Operation can be expanded to access additional options, such as boolean operations, margin setting, and milling direction.

•  After the Pocket Operation, select all copper objects such as pours, pads, vias, and traces (this may take some time with complex designs), then select "Create Operation", followed by the "Outside" drop-down option, and again a value of "0.1" for the Deep field. The Pocket and Outside Operations are sufficient for most designs using through-hole or even surface mount components, but there is potential for more advanced toolpathing as well.

•  Select "Simulate GCODE" to verify toolpathing and observe Operation behavior and order.

•  Select "Save GCODE" to save the Gcode file.

<p align="center">
  <img src="Example/JSCut.png" width="350" title="Example Toolpath Output from JScut">
</p>


### Candle
Candle controls the CNC machine directly over USB or by generating a Gcode file for running on a USB stick inserted in the CNC machine.

•  Ensure Candle is connected to the CNC machine over USB by selecting "Service → Settings" and "Connection" in the pop-up window. The "Connection" drop-down should show a numbered COM option corresponding to the CNC machine - if not, verify the correct drivers have been installed.

•  Close this window and observe the control panel, which may be configured by adjusting settings.
The 3018 Pro CNC machine is capable of making use of the probe and heightmap functions in Candle, which are critical to producing good quality PCB designs.

•  In order to use the continuity probe, where the cutting tool making contact with the PCB surface triggers the probe stop, GRBL commands must be sent to the machine via the command terminal, and the tool head spindle must be connected to a "GND" pin on the control board, and the PCB must be connected to the "A5" pin on the control board. These connections are easily made using aliigator clips and male pin headers. These connections must be removed when turning the spindle on - **be sure to always check and check again that these clips are removed from the spindle before turning the spindle on**.

•  The GRBL commands that must be sent to properly set the homing cycle for continuity probing are `$22-1` (homing cycle enable) and `$23=0` (homing cycle direction). Additional GRBL commands are provided in the "GRBL_Settings_Pocket_Guide_Rev_B" document or at www.DIYMachining.com/GRBL.

•  With the homing cycle configured, spindle off, and clips attached, use the control panel to raise the tool head and position the cutting tool over a corner of the PCB. Note the directionality of all controls, and observe the Candle graphical display of the tool head.

•  The Z-home button may be used to slowly lower the tool head until continuity is made and the tool head stops. Zero the machine in Candle by selecting the Zero X, Y, and Z buttons in the control panel.

•  Load the Gcode file generated by JScut by selecting "File → Open" and selecting "All Files (*.*)" from the pop-up window drop-down options to view Gcode files.

<p align="center">
  <img src="Example/Candle_GCode_Output.png" width="350" title="Example Gcode File Loaded in Candle">
</p>

•  Once a Gcode file is opened, Candle enables the Heightmap function. Select "Create" (or optionally apply the modeled heightmap that was developed for rapid prototyping using the fixture design included in this repository).

•  Adjust the Heightmap settings to enclose the design shown in the graphical window, or select the "Auto" button to automatically set parameters.

•  Select reasonable values for the Heightmap Probe Grid. Some parameters may be unfamiliar - "F" is the probe feedrate, "Zt" is the distance to raise the tool head when moving to the next point, and "Zb" is the distance to lower the tool head when probing. If the machine was zeroed previously, then a value of 1.50 for Zt with other values left as default is likely sufficient.

•  Observe the arrangement of the graphical representation of the operation and visually verify that the machine will not be crashed before selecting "Probe". The routine will run until complete or if continuity was made at an unexpected point. If the Heightmap was not able to be completed, try adjusting the "Zt" or "Zb" parameters accordingly, or inspect for other issues.

<p align="center">
  <img src="Example/Candle_Heightmapping.png" width="350" title="Example Candle Heightmap Routine Being Performed">
</p>

•  With the Heightmap complete, close the Heightmap mode by selecting "Edit".

•  Raise the tool head slightly and reset alarms if necessary.

•  Perform additional visual checks to verify the machine will be able to proceed with the milling operation unobstructed, and **remove clips attached to the spindle and PCB before turning the spindle on**.
### Note that the spindle rotates near 10,000 RPM, and the cutting bit could break and create a dangerous situation. Follow lab policies regarding safety and have faculty or senior students familiar with this process verify that everything is in order before turning on the spindle and running milling Gcode.

•  Turn the spindle on and select "Send" to run the operation. Observe the machine safely and while wearing safety glasses.

The routine should complete and the PCB will be ready for final processing, cutting, or hole drilling operations.

<p align="center">
  <img src="Example/KiCAD_Render.png" width="350" title="Example Populated PCB Rendered in KiCAD">
</p>
