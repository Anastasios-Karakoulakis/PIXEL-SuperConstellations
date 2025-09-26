# PIXEL Detection

**PIXEL** is a novel detection framework for very large constellations under **AWGN** and **phase noise**.  
It introduces a grid-based approach that significantly reduces the detection complexity while maintaining near-optimal performance.

This repository contains a full MATLAB implementation of the algorithms described in:

> **Anastasios Karakoulakis, Thrassos K. Oikonomou, Dimitrios Tyrovolas, Sotiris A. Tegos, Nestor D. Chatzidiamantis, and George K. Karagiannidis,  
> "PIXEL: A Novel Detection Algorithm for Super Constellations", 2025.**

---

## Motivation

Next-generation wireless systems demand **super-constellations** (e.g., QAM-4096, APSK, GAM) that support large symbol sets while remaining robust to phase noise.  
However, efficient detection in such constellations is challenging:

- **GAP-D** achieves accurate detection under AWGN and phase noise but requires an **exhaustive search over all constellation points**, leading to prohibitive complexity.  
- Decision regions induced by GAP-D are **irregular in the I/Q plane**, making fast detection impractical.  

**PIXEL** addresses these challenges by:  
- **Pixelizing the I/Q plane** into a uniform grid of cells.  
- Assigning each cell to a small set of candidate symbols derived from the GAP-D metric.  
- Achieving **O(1) detection complexity** with near-optimal accuracy, independent of constellation geometry.  

This makes PIXEL a **scalable and flexible solution** for large constellations in high-throughput communication systems.

---

## Algorithms

### 1. **GAP-D (Baseline)**
- Evaluates the metric for *all* constellation points.  
- High accuracy, but complexity grows linearly with constellation size.

### 2. **Fast Square Detection (Algorithm 1)**  
- Divides the complex plane into **K×K grid cells**.  
- Each cell is preassigned to its closest constellation point.  
- Each received symbol is detected by locating its cell → **O(1) complexity**.  
- Extremely fast, but approximation errors can appear.

### 3. **Super Square PIXEL Detection (Algorithm 2)**  
- Each cell stores the **N nearest constellation points** (instead of only 1).  
- At runtime:
  1. Received symbol is mapped to its cell.  
  2. Only the **local N candidates** are refined using GAP-D.  
- Provides **ML-like performance** with a fraction of the complexity.  

---
---

## Installation

Requirements:
- MATLAB R2021a or later  
- Communications Toolbox (for `qammod`, `awgn`, `symerr`)  

Clone the repo and add to your MATLAB path:

```bash
git clone https://github.com/<your-username>/PIXEL-Detection.git
```

In MATLAB:
```matlab
addpath(genpath('PIXEL-Detection'));
```

---

## Usage

To run a simulation:

```matlab
main_simulation
```

This evaluates **GAP-D**, **Fast Square**, and **PIXEL** detection under AWGN + phase noise.  
Results (SER and runtimes) are saved into `results/`.

You can modify:
- **Constellation** in `main_simulation.m` (QAM, GAM, APSK).  
- **SNR range** (`snr_values`).  
- **Grid size (K)** and **candidates per cell (N)**.  

---

## Reproduce Paper Results

To reproduce results from the PIXEL paper:

1. Open `main_simulation.m`.  
2. Select a large constellation, e.g.:  
   ```matlab
   constellation = qammod(0:4096-1,4096,"UnitAveragePower",true);
   const_name = "QAM4096";
   ```
3. Adjust parameters:  
   ```matlab
   snr_values = 20:5:40;
   grid_sizes = 2.^(7:12);
   N_values   = 2.^(0:3);
   ```
4. Run the script:
   ```matlab
   main_simulation
   ```
5. Results will be saved in `/results/`.

---

## Example Results

### Constellation partitioned into PIXEL grid
*(example for QAM-256, K=128)*  

![PIXEL Grid Example](figures/grid_example.png)

### SEP vs SNR
Comparison of GAP-D, Fast Square, and PIXEL detection.  

![SEP vs SNR](figures/sep_results.png)

### Runtime Benchmark
Measured at SNR = 30 dB, QAM-256:

| Algorithm      | SEP       | Runtime (s) |
|----------------|-----------|-------------|
| GAP-D          | 1.23e-04  | 2.35        |
| Fast Square    | 1.30e-04  | 0.15        |
| PIXEL (N=2)    | 1.24e-04  | 0.72        |

---

## Repository Structure

```
PIXEL-Detection/
│
├── main_simulation.m         # Main script (runs all algorithms)
├── functions/                # Helper functions
│   ├── GAP_D.m               # GAP-D baseline
│   ├── Pixel_detection.m     # Super Square PIXEL (Algorithm 2)
│   ├── Pixel_detection_N_1.m # Fast Square (Algorithm 1)
│   ├── preprocessing_*.m     # Grid preprocessing routines
│   └── utils/                # Other utilities
│
├── results/                  # Output .mat results
└── figures/                  # Example plots for README
```

---

## Contributing

Contributions are welcome!  
Possible directions:
- Improving vectorization and speed.  
- Adding more visualization or plotting scripts.  

---

## Citation

If you use this code, please cite:

```
@article{karakoulakis2025pixel,
  author  = {Anastasios Karakoulakis and Thrassos K. Oikonomou and Dimitrios Tyrovolas and Sotiris A. Tegos and Nestor D. Chatzidiamantis and George K. Karagiannidis},
  title   = {PIXEL: A Novel Detection Algorithm for Super Constellations},
  year    = {2025},
  journal = {IEEE Communications Letters}
}
```

---

## License

This project is released under the **MIT License**.  
See [LICENSE](LICENSE) for details.

---

## Contact

Maintainer: **Anastasios Karakoulakis**  
Email: *tkarakoulakis@gmail.com*  


