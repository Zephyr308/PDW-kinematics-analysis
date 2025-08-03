# 🦿 Passive Dynamic Walker: 2D Gait Analysis in MATLAB

This repository contains a MATLAB-based pipeline for analyzing the 2D gait kinematics of a Passive Dynamic Walker (PDW) from video-based digitized marker data.

It supports processing and visualizing:

- Gait angles (stance and inter-leg)
- State-space trajectories
- Center of mass (CoM) movement
- Energy dynamics (Potential and Kinetic Energy)

## 📷 Example Plots

Example analysis plots from sample runs can be found in the [`/plots`](./plots) folder.

---

## 📋 Features

- 📈 Plot leg angles over time (absolute & non-dimensional)
- 🔁 Visualize state-space trajectory across multiple steps
- 🎯 Estimate center of mass trajectory
- ⚡ Compute and plot PE and KE
- 🖼️ Automatically saves all generated figures to the `/plots` directory

---

## ▶️ How to Run

1. Open MATLAB
2. Navigate to the `src/` directory
3. Run the main script:

```matlab
run_gait_analysis
```
Make sure the digitized data file is correctly specified in the script:
```matlab
filename = '../data/your_data_file.csv';
```
## 📂 Folder structure
```graphql
PDW_Gait_Analysis/
├── data/              # Digitized CSV files from DLTdv8
├── plots/             # Auto-generated figures
├── src/               # MATLAB source scripts
├── BACKGROUND.md      # Theoretical and experimental context
└── README.md          # This file
```


## 📚 Background

The analysis is based on a simplified **inverted pendulum model** of legged locomotion.  
For details on the physical setup, digitizing workflow, and theoretical context, see [`BACKGROUND.md`](./BACKGROUND.md).

---

## 🔧 Requirements

- MATLAB R2019a or later  
- [DLTdv8](http://biomech.web.unc.edu/dltdv/) (for digitizing marker coordinates)  
  ➤ Includes documentation and tutorials for video annotation

---

## 📌 Notes

- This pipeline assumes a **2D side-view recording** and uses a **fixed column format** in the CSV file.
- Ensure your data is **calibrated** using a known reference length in pixels (e.g., ramp step height).
- You can **manually adjust** step segmentation and calibration parameters in the script.
