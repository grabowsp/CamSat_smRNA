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
* DESeq2 Result Directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results`

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
* DESeq2 Results
  * `DESEQ2_RES_DIR/MT5v8171_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/MT5v8171_DESeq2_general_full_mat.txt`
  * `DESEQ2_RES_DIR/MT5v8171_DESeq2_TC_genes.txt`
  * `DESEQ2_RES_DIR/MT5v8171_DESeq2_TC_full_mat.txt`
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
* DESeq2 Results
  * `DESEQ2_RES_DIR/HMT5vHMT102_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/HMT5vHMT102_DESeq2_general_full_mat.txt`
  * `DESEQ2_RES_DIR/HMT5vHMT102_DESeq2_TC_genes.txt`
  * `DESEQ2_RES_DIR/HMT5vHMT102_DESeq2_TC_full_mat.txt`
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
* DESeq2 Results
  * `DESEQ2_RES_DIR/HMT5vHMT102_flowers_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/HMT5vHMT102_flowers_DESeq2_general_full_mat.txt`
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
* DESeq2 Results
  * `DESEQ2_RES_DIR/HMT5vM3246_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/HMT5vM3246_DESeq2_general_full_mat.txt`
  * `DESEQ2_RES_DIR/HMT5vM3246_DESeq2_TC_genes.txt`
  * `DESEQ2_RES_DIR/HMT5vM3246_DESeq2_TC_full_mat.txt`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`

## PR33-R vs PS69-R
### Overview
* Only 1 time point: 0H
  * Cannot use PS33-R_72H
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/PR33vPS69`
* Count file for DE analysis
  * `SHORTSTACK_DATA_DIR/PR33vPS69_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/PR33vPS69_smRNA_cor_heatmap.pdf`
* DESeq2 Results
  * `DESEQ2_RES_DIR/PR33_RvPS69_R_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/PR33_RvPS69_R_DESeq2_general_full_mat.txt`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`

## PR33-Sh vs PS69-Sh
### Overview
* Only 1 time point: 0H
  * Cannot use PS69-Sh_72H
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/PR33vPS69`
* Count file for DE analysis
  * `SHORTSTACK_DATA_DIR/PR33vPS69_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/PR33vPS69_smRNA_cor_heatmap.pdf`
* DESeq2 Results
  * `DESEQ2_RES_DIR/PR33_ShvPS69_Sh_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/PR33_ShvPS69_Sh_DESeq2_general_full_mat.txt`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`

## NR130-R vs NS233-R
### Overview
* 2 time points: 0H, 72H
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/NR130vNS233`
* Count file for DE analysis
  * `SHORTSTACK_DATA_DIR/NR130vNS233_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/NR130vNS233_smRNA_cor_heatmap.pdf`
* DESeq2 Resupts
  * `DESEQ2_RES_DIR/NR130_RvNS233_R_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/NR130_RvNS233_R_DESeq2_general_full_mat.txt`
  * `DESEQ2_RES_DIR/NR130_RvNS233_R_DESeq2_TC_genes.txt`
  * `DESEQ2_RES_DIR/NR130_RvNS233_R_DESeq2_TC_full_mat.txt`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`

## NR130-Sh vs NS233-Sh
### Overview
* 2 time points: 0H, 72H
### Files
* shortstack Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/NR130vNS233`
* Count file for DE analysis
  * `SHORTSTACK_DATA_DIR/NR130vNS233_tot_counts_full.txt`
* Correlation heatmap
  * `SHORTSTACK_DATA_DIR/NR130vNS233_smRNA_cor_heatmap.pdf`
* DESeq2 Resupts
  * `DESEQ2_RES_DIR/NR130_ShvNS233_Sh_DESeq2_general_genes.txt`
  * `DESEQ2_RES_DIR/NR130_ShvNS233_Sh_DESeq2_general_full_mat.txt`
  * `DESEQ2_RES_DIR/NR130_ShvNS233_Sh_DESeq2_TC_genes.txt`
  * `DESEQ2_RES_DIR/NR130_ShvNS233_Sh_DESeq2_TC_full_mat.txt`
### Submit job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`




