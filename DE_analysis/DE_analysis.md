# Overview of smRNA DE analysis steps

## Overview
### Analsysis Steps
* Generate count matrix for comparison
* Filter libraries based on correlation matrix
* Run DESeq2
* Run maSigPro, if applicable
* Run splineTimeR if applicable
### Important File locations
* Information about libraries
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/smRNA_Library_Info_Sample_Info.tsv`
* List of bad libraries
  * Libraries to be removed because of low correlation with replicates
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/bad_libraries.txt`
  * manually add to this list when looking at correlations for comparisons

## MT5 vs 8171
### Overview
* originally was 3 time points: 8DAF, 10DAF, and 12DAF
* However, all 3 8171_8DAF reps have low correlation and are removed
* Result is that can only use 10DAF and 12DAF in the analysis
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/MT5v8171/`
* Count files for DE analysis
  * `SHORTSTACK_DATA_DIR/MT5v8171_tot_counts_full.txt`
    * all smRNA from shortstack
  * `SHORTSTACK_DATA_DIR/MT5v8171_tot_counts_good.txt`
    * only smRNA with genomic placement
* Correlation heatmaps
  * `SHORTSTACK_DATA_DIR/MT5v8171smRNA_cor_heatmap.pdf`
    * Full dataset
  * `SHORTSTACK_DATA_DIR/MT5v8171smRNA_cor_heatmap_good.pdf`
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results
sbatch MT5v8171_DESeq2_submit.sh
```

## HMT5 vs HMT102
### Overview
* 4 time points: 5DAF, 10DAF, 15DAF, 20DAF
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/HMT5vHMT102`
* Count files for DE analysis
  * `SHORTSTACK_DATA_DIR/HMT5vHMT102_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/HMT5vHMT102_smRNA_cor_heatmap.pdf`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`

## HMT5 vs HMT102 Flowers
### Overview
* Single time point
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/HMT5vHMT102_flowers`
* Count file for DE analysis
  * `SHORTSTACK_DATA_DIR/HMT5vHMT102_flowers_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/HMT5vHMT102_flowers_smRNA_cor_heatmap.pdf`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`

## HMT5 vs M3246
### Overview
* 2 time points: 5DAF, 15DAF
### Files
* shortstack Data Directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/HMT5vM3246`
* Count file for DE analysis
  * `SHORTSTACK_DATA_DIR/HMT5vM3246_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/HMT5vM3246_smRNA_cor_heatmap.pdf`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`


