# MSLesSeg 4 ICPR

![Project-Header](./assets/imgs/01-Project-Header.jpeg)

---

## Overview

This project is based on the recently concluded **ICPR challenge** organized by the **[IP Lab](https://iplab.dmi.unict.it/)** at the **University of Catania**, led by **Dr. F. Guarnera** and **Dr. A. Rondinella**. The challenge introduced a **carefully curated** and **refined dataset** of **brain MRI scans** from patients diagnosed with various forms of **Multiple Sclerosis**. All patients are from the city of **Catania**; however, the scans were acquired using **different MRI machines** across **multiple hospitals**, introducing valuable **inter-scanner variability**.

The primary objectives of the challenge were twofold: to contribute a **novel**, **versatile dataset** to the **research community** and to **benchmark** the performance of **state-of-the-art (SOTA) models**. Participants were encouraged to explore **advanced strategies** such as **sophisticated preprocessing pipelines**, **variations in image registration spaces**, and **ensemble methods** involving **independently trained models**.

You may find the **published paper [here](https://arxiv.org/abs/2410.07924)** and the **challenge’s homepage [here](https://iplab.dmi.unict.it/mfs/ms-les-seg/)**.

---

## Our Solution

- Mention my solution here

## Results

- Talk about the obtained results

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

# Mixed Reality Application 4 Healthcare

## TODO <-----------------

- Showcase the ***SegFormer3D MoE*** model (perhaps quantized?) deployed on the ***edge device***, the **META Quest 3** in the setting for ***aiding the surgeon*** during surgery. 

# System Specks

### Hardware

- **CPU:** Intel i7-8700 (12) @ 4.600GHz  
- **GPU:** NVIDIA GeForce RTX 4070 12GB  
- **RAM:** 32G total 

### Software

- **NVIDIA-DRIVERS:** 550.54.14
- **CUDA:** 12.4

---