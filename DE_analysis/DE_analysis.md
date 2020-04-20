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
* Data directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/MT5v8171/`
* Count files for DE analysis
  * `MT5v8171_tot_counts_full.txt`
    * all smRNA from shortstack
  * `MT5v8171_tot_counts_good.txt`
    * only smRNA with genomic placement
* Correlation heatmaps
  * `MT5v8171smRNA_cor_heatmap.pdf`
    * Full dataset
  * `MT5v8171smRNA_cor_heatmap_good.pdf`




