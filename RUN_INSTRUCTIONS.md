# ▶️ How to Run the PDW Kinematics Analysis

Follow these steps to run the MATLAB script and analyze your digitized passive dynamic walker data:

---

## ✅ Prerequisites

- MATLAB R2019a or newer
- Digitized data exported from **DLTdv8** as a `.csv` file
- File should contain [x,y] coordinates for key markers in the correct column order

---

## 🧪 Steps

1. **Open MATLAB**

2. **Navigate to the `src/` directory** in your terminal or using the MATLAB GUI:

```matlab
cd path/to/pdw-kinematics-analysis/src
```
3. **Run the script:
```matlab
run_gait_analysis
```
4. **Ensure the correct data file is referenced
In the script, update this line if you are using a different file or path: 
```matlab
filename = '../data/sample_data.csv';
```

## 📁 Output

The script will generate the following visualizations:

- Time series plots of gait angles  
- Interleg vs stance state-space trajectory  
- Center of mass (CoM) displacement — horizontal and vertical  
- Potential and kinetic energy plots  

These will appear in MATLAB figure windows and can be saved manually or programmatically to the `/plots` folder.

---

## 🛠 Troubleshooting

- **"File not found" error**  
  → Double-check the file path and filename in the script.

- **No figures appearing**  
  → Ensure `figure` commands are present and not suppressed in the script.

- **Data format mismatch**  
  → The script assumes a fixed column structure in the CSV. Make sure your file matches the expected format for marker coordinates.

---

## 📚 Need Help Digitizing?

Refer to the official [DLTdv8 tutorial](http://biomech.web.unc.edu/dltdv8_manual/#trackingTutorial) for guidance on video annotation and data export.
