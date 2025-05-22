# MSLesSeg 4 ICPR

![Project-Header](./assets/imgs/01-Project-Header.jpeg)

---

## Overview

This project is based on the recently concluded **ICPR challenge** organized by the **[IP Lab](https://iplab.dmi.unict.it/)** at the **University of Catania**, led by **Dr. F. Guarnera** and **Dr. A. Rondinella**. The challenge introduced a **carefully curated** and **refined dataset** of **brain MRI scans** from patients diagnosed with various forms of **Multiple Sclerosis**. All patients are from the city of **Catania**; however, the scans were acquired using **different MRI machines** across **multiple hospitals**, introducing valuable **inter-scanner variability**.

The primary objectives of the challenge were twofold: to contribute a **novel**, **versatile dataset** to the **research community** and to **benchmark** the performance of **state-of-the-art (SOTA) models**. Participants were encouraged to explore **advanced strategies** such as **sophisticated preprocessing pipelines**, **variations in image registration spaces**, and **ensemble methods** involving **independently trained models**.

You may find the **published paper [here](https://arxiv.org/abs/2410.07924)** and the **challenge’s homepage [here](https://iplab.dmi.unict.it/mfs/ms-les-seg/)**.

---

## Our Solution

- After performing extensive tests with several architectures, such as U-Net, Trans-U-Net and SegFormer3D-based architectures, we found that not only do we obtain comparable results with the SegFormer3D models (compared to larger and more computationally-hungry models such as U-Net) but having less parameters (4.5M) there are practical applications in the medical industry for said model
- Both SegFormer3D and SegFormer3DMoE obtained a *DiceScore* of ***60*** on the ***MSLesSeg Dataset***

## Setup & Replication

To replicate the experiments you will need to:

1) Acquire the `.zip` of the `MSLesSeg` dataset from the authors of the `challenge` @ [IP Lab](https://iplab.dmi.unict.it/people/)

2) Extract the dataset into the `data` directory, specifically into the `/data/01-Pre-Processed-Data/` subdirectory

3) Then apply the proper preprocessing `scripts`

- You can find more details on how to apply the initial `preprocessing` the data [here](./data/README.md).
- You can find a `terraform` script for the provisioning of a `cloud instance` to replicate the training and experiments performed in this project [here](./cloud_infrastructure/).

### Environment Setup

The code presented in the repo has the following `dependencies`

| `Component` | `Version` |
|-------------|-----------|
| `conda`     | `25.1.1`  |
| `Python`    | `3.11`    |
| `pip`       | `25.1`    |


To manually setup the `environment` for experiment `replication`:

1) Download and install [`conda`](https://www.anaconda.com/docs/getting-started/miniconda/main)

2) Create the `virtual environment` with `conda`

```bash
conda create --name mslesseg4icpr python=3.11
```
3) Download all the required modules `modules` (make sure you are in the root of the project `~/MSLesSeg-4-ICPR`)

```bash
python -m pip install -r requirements.txt
```

4) Go into the `notebooks` directory & launch a `jupyter notebook` session

```bash
jupyter-notebook mslesseg-4-icpr.ipynb
```

5) Run the entire `notebook`

---

# Extended Reality Applications

Since our main proposed model ***SegFormer3D*** has about 4.5M parameters and requires around 17 GFLOPs to perform inference, considering a hardware platform such as the ***META Quest 3*** which can perform up to 2.4 TFLOPs, we developed a simple PoC that shows how a surgeon, ***without compromising the sterility of the operating room*** can perform inference on a newly received ***MRI scan***, in this case ***Brain MRI*** and using the recognized hand gestures with the ***quest 3***, can visualize the inference performed on the MRI scan and better asses the treatment that the patient needs, thus saving precious time and bringing ever closer two of main pillars of our society, ***technology*** and ***healthcare***

![Brain MRI VR Analysis](./assets/gifs/VR-Brain-MRI-Scan-Analysis.gif)

---

![Brain MRI VR Analysis - Inference](./assets/gifs/VR-Brain-MRI-Inference-Analysis.gif)

---


# System Specks

### Hardware

- **CPU:** Intel i7-8700 (12) @ 4.600GHz  
- **GPU:** NVIDIA GeForce RTX 4070 12GB  
- **RAM:** 32G total 

### Software

- **NVIDIA-DRIVERS:** 550.54.14
- **CUDA:** 12.4

---
