# Passive Dynamic Walker (PDW) 2D Kinematics Analysis

This MATLAB-based project performs kinematic and energy analysis on a digitized passive dynamic walker (PDW) trial. It was developed for the **Animal Locomotion and Bio-inspired Robotics** unit at **Imperial College London**.

---

## 🎯 Objective

To analyze the most consistent passive walking trial captured via 2D video, following digitization in **DLTdv8**. This includes:

- Computing joint angles and gait patterns
- Estimating center of mass (CoM) trajectories
- Analyzing potential and kinetic energy over time
- Comparing experimental results with simulated PDW behavior

---

## 🧪 Methods

- Marker trajectories were digitized using **DLTdv8** from side-view PDW video.
- Time-series kinematic data were loaded in MATLAB for further processing.
- Absolute interleg angles, stance leg angles, CoM displacement, and energy profiles were computed.
- Non-dimensional time was used for normalized visualization across steps.

---

## 📈 Key Plots

| Plot Type | Description |
|-----------|-------------|
| `stance_vs_time.png` | Stance and interleg angle vs time |
| `interleg_vs_stance.png` | Step-wise state-space trajectory |
| `com_trajectory.png` | Center of mass (X, Y) displacement |
| `energy_dynamics.png` | Detrended potential energy and kinetic energy |

Example:  
![Gait Angles](plots/stance_vs_time.png)

---
## 🔍 Report Analysis Guide

In line with the coursework brief, interpret your results based on the following criteria:

### 1. Gait Symmetry
- Are the **stance** and **interleg angles** smooth and periodic?
- Do the **state-space trajectories** (interleg vs stance) form regular loops across steps?

### 2. Energy Patterns
- Does the **detrended potential energy (PE)** show rhythmic fluctuations?
- Is the **cycling of PE and kinetic energy (KE)** consistent with your PDW simulation results?

### 3. Stability
- Are there increasing **deviations in angle profiles or CoM drift** over time?
- Do you observe signs of **instability or limping behavior**?

---
## ▶️ How to Run

1. Open **MATLAB**
2. Navigate to the `src/` directory
3. Run the main script:

```matlab
run_gait_analysis
filename = '../data/sample_data.csv';
```

---

## 🧠 Background: DLTdv8 Workflow

The motion capture data used in this analysis was digitized using **DLTdv8 (v8.1)** from a high-frame-rate side-view video of the passive dynamic walker.

For more details on the digitizing workflow, refer to the [DLTdv8 tutorial](http://biomech.web.unc.edu/dltdv8_manual/#trackingTutorial).

---

## 📂 File Structure

```text
src/
  run_gait_analysis.m       - Main script
  calculateAngles3.m        - Interleg angle (A-B-C)
  calculateAngles4.m        - Angle vs ramp vector

data/
  sample_data.csv           - Example marker data

plots/
  *.png                     - Generated figures
