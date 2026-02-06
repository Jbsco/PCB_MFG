# FlatCAM Tips (Linux)

This section describes how to **install and run FlatCAM on Linux** using the FlatCAM Beta repository and a Python virtual environment.

---

## Cloning the FlatCAM Repository

- Clone the FlatCAM Beta repository:
git clone https://bitbucket.org/marius_stanciu/flatcam_beta.git

- Navigate into the project directory:
cd flatcam_beta

- Checkout the recommended FlatCAM version:
git checkout Beta_8.995

---

## Python Virtual Environment Setup

- Create a Python 3 virtual environment:
python3 -m venv ~/flatcam-venv

- Activate the virtual environment:
source ~/flatcam-venv/bin/activate

---

## Installing Dependencies

- Edit the `requirements.txt` file and comment out libraries that may fail to install (for example, `gdal`).

- If installation fails, a recommended approach is:
  - Comment out **all** libraries
  - Uncomment **one library at a time**
  - Run the installer and check for errors

- Install the remaining dependencies:
pip install -r requirements.txt

---

## Running FlatCAM

- Activate the virtual environment:
source ~/flatcam-venv/bin/activate

- Launch FlatCAM:
python3 flatcam.py

---

## Known Bug Fix (Laser / Spindle Code)

If FlatCAM **opens and immediately closes**, apply the following fix.

- Open the file:
camlib.py

- Locate approximately line **3866** and replace:

      `# self.laser_on_code = tool_dict['tools_mill_laser_on']`

      self.laser_on_code = "M03"

This forces FlatCAM to use the correct spindle enable command for **GRBL-based CNC controllers**, including the **Genmitsu CNC 3018-PRO**.

---

## Running FlatCAM (After Installation)

- Activate the virtual environment:
source ~/flatcam-venv/bin/activate

- Start FlatCAM:
python3 flatcam.py
