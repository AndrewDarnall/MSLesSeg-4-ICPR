# Data Preparation


The following is a brief guide on how to, once obtained, format the data in order to use it in the model.

1) Extract the compressed `.zip` of the dataset into the `~/00-Raw-Data/` directory

2) Copy the `train` and `test` directories from the `unzipped` directory into the `~/01-Pre-Processed-Data` directory and change into that `dir`

3) Once in the `~/01-Pre-Processed-Data` directory, run the `formatting` scripts on both the `train` and `test` set so that there is no temporal correlation between the `scans`

- For the `training` set

```bash
bash ./scripts/01-mslesseg_train_preproc.sh ./train
```

- For the `test` set

```bash
bash ./scripts/02-mslesseg_test_preproc.sh ./test/test 93
```

- For the `test` set ***with*** the `segmentation masks`

```bash
bash ./scripts/02-mslesseg_test_preproc.sh ./test/test_MASK 93
```

---

After performing these simple processing steps, you may now head to the `~/notebooks` directory and run the `notebook`

---