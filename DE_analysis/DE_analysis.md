# Overview of smRNA DE analysis steps

## Overview
### Analsysis Steps
* Generate count matrix for comparison
* Filter libraries based on correlation matrix
* Run DESeq2
* Run maSigPro, if applicable
* Decided not to include splineTimeR
### Important File locations
* Information about libraries
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/smRNA_Library_Info_Sample_Info.tsv`
* List of bad libraries
  * Libraries to be removed because of low correlation with replicates
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/bad_libraries.txt`
  * manually add to this list when looking at correlations for comparisons
* DESeq2 Result Directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results`
* maSigPro Result Directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results`
* Combined List Directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists`

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
* maSigPro Results
  * `MASIG_RES_DIR/MT5v8171_General_DE_genes.txt`
  * `MASIG_RES_DIR/MT5v8171_General_DE_full_mat.txt`
  * `MASIG_RES_DIR/MT5v8171_TC_DE_genes.txt`
  * `MASIG_RES_DIR/MT5v8171_TC_DE_full_mat.txt`
* Combined Results
  * `COMBO_DIR/MT5v8171_General_DE_smRNAs_List1.txt`
  * `COMBO_DIR/MT5v8171_TC_DE_smRNAs_List2.txt`
  * `COMBO_DIR/MT5v8171_Full_DE_smRNAs_List3.txt`
### DESeq2 Job
* because of Cori wait times, I ran the scripts during an interactive session
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### maSigPro Job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results/smRNA_maSigPro_submit.sh`
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results
sbatch smRNA_maSigPro_submit.sh
```
### Generate Combined Lists
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_General_lists.r \
MT5v8171

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_TC_lists.r \
MT5v8171

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_all_lists.r \
MT5v8171
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
* maSigPro Restuls
  * `MASIG_RES_DIR/HMT5vHMT102_General_DE_genes.txt`
  * `MASIG_RES_DIR/HMT5vHMT102_General_DE_full_mat.txt`
  * `MASIG_RES_DIR/HMT5vHMT102_TC_DE_genes.txt`
  * `MASIG_RES_DIR/HMT5vHMT102_TC_DE_full_mat.txt`
* Combined Results
  * `COMBO_DIR/HMT5vHMT102_General_DE_smRNAs_List1.txt`
  * `COMBO_DIR/HMT5vHMT102_TC_DE_smRNAs_List2.txt`
  * `COMBO_DIR/HMT5vHMT102_Full_DE_smRNAs_List3.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### maSigPro Job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results/smRNA_maSigPro_submit.sh`
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results
sbatch smRNA_maSigPro_submit.sh
```
### Generate Combined Lists
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_General_lists.r \
HMT5vHMT102

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_TC_lists.r \
HMT5vHMT102

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_all_lists.r \
HMT5vHMT102
```

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
* Processed List
  * `COMBO_DIR/HMT5vHMT102_flowers_General_DE_smRNAs_List1.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### Generate Final List
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
make_noTC_DE_General_list.r \
HMT5vHMT102_flowers
```

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
* maSigPro Restuls
  * `MASIG_RES_DIR/HMT5vM3246_General_DE_genes.txt`
  * `MASIG_RES_DIR/HMT5vM3246_General_DE_full_mat.txt`
  * `MASIG_RES_DIR/HMT5vM3246_TC_DE_genes.txt`
  * `MASIG_RES_DIR/HMT5vM3246_TC_DE_full_mat.txt`
* Combined Results
  * `COMBO_DIR/HMT5vM3246_General_DE_smRNAs_List1.txt`
  * `COMBO_DIR/HMT5vM3246_TC_DE_smRNAs_List2.txt`
  * `COMBO_DIR/HMT5vM3246_Full_DE_smRNAs_List3.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### maSigPro Job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results/smRNA_maSigPro_submit.sh`
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results
sbatch smRNA_maSigPro_submit.sh
```
### Generate Combined Lists
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_General_lists.r \
HMT5vM3246

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_TC_lists.r \
HMT5vM3246

Rscript \
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_all_lists.r \
HMT5vM3246
```

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
* Processed List
  * `COMBO_DIR/PR33_RvPS69_R_DE_smRNAs_List1.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### Generate Final List
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

# I had to manually run and adjust the following script to load and include
#   the correct counts
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
make_noTC_DE_General_list.r \
PR33_RvPS69_R
```

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
* Processed List
  * `COMBO_DIR/PR33_ShvPS69_Sh_DE_smRNAs_List1.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### Generate Final List
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

# I had to manually run and adjust the following script to load and include
#   the correct counts
/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
make_noTC_DE_General_list.r \
PR33_ShvPS69_Sh
```

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
* maSigPro Restuls
  * `MASIG_RES_DIR/NR130_RvNS233_R_General_DE_genes.txt`
  * `MASIG_RES_DIR/NR130_RvNS233_R_General_DE_full_mat.txt`
  * `MASIG_RES_DIR/NR130_RvNS233_R_TC_DE_genes.txt`
  * `MASIG_RES_DIR/NR130_RvNS233_R_TC_DE_full_mat.txt`
* Combined Results
  * `COMBO_DIR/NR130_RvNS233_R_General_DE_smRNAs_List1.txt`
  * `COMBO_DIR/NR130_RvNS233_R_TC_DE_smRNAs_List2.txt`
  * `COMBO_DIR/NR130_RvNS233_R_Full_DE_smRNAs_List3.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### maSigPro Job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results/smRNA_maSigPro_submit.sh`
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results
sbatch smRNA_maSigPro_submit.sh
```
### Generate Combined Lists
* I had to run these scripts interactively because R and Sh samples were run
together in shortstack
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

# Adjustements in R
comp_name <- 'NR130_RvNS233_R'

shortstack_res_file <- paste(shortstack_dir, 'NR130vNS233', '/Results.txt',
  sep = '')

shortstack_unplaced_file <- paste(shortstack_dir, 'NR130vNS233', 
  '/Unplaced.txt', sep = '')

count_file <- paste(shortstack_dir, 'NR130vNS233', '/', 'NR130vNS233', 
  '_tot_counts_full.txt', sep = '')

count_col_keep <- grep('-R', colnames(counts_ord))
counts_ord <- counts_ord[ , c(1, count_col_keep)]

/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_General_lists.r

/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_TC_lists.r

/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_all_lists.r
```

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
* maSigPro Restuls
  * `MASIG_RES_DIR/NR130_ShvNS233_Sh_General_DE_genes.txt`
  * `MASIG_RES_DIR/NR130_ShvNS233_Sh_General_DE_full_mat.txt`
  * `MASIG_RES_DIR/NR130_ShvNS233_Sh_TC_DE_genes.txt`
  * `MASIG_RES_DIR/NR130_ShvNS233_Sh_TC_DE_full_mat.txt`
* Combined Results
  * `COMBO_DIR/NR130_ShvNS233_Sh_General_DE_smRNAs_List1.txt`
  * `COMBO_DIR/NR130_ShvNS233_Sh_TC_DE_smRNAs_List2.txt`
  * `COMBO_DIR/NR130_ShvNS233_Sh_Full_DE_smRNAs_List3.txt`
### DESeq2 job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/smRNA_DESeq2_submit.sh`
### maSigPro Job
* Part of:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results/smRNA_maSigPro_submit.sh`
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results
sbatch smRNA_maSigPro_submit.sh
```
### Generate Combined Lists
* I had to run these scripts interactively because R and Sh samples were run
together in shortstack
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

# Adjustements in R
comp_name <- 'NR130_ShvNS233_Sh'

shortstack_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/'
shortstack_res_file <- paste(shortstack_dir, 'NR130vNS233', '/Results.txt',
  sep = '')
shortstack_res_0 <- read.table(shortstack_res_file, header = T,
  stringsAsFactors = F, sep = '\t', comment.char = '@')

shortstack_unplaced_file <- paste(shortstack_dir, 'NR130vNS233', 
  '/Unplaced.txt', sep = '')
shortstack_unplaced_0 <- read.table(shortstack_unplaced_file, header = T,
  stringsAsFactors = F, sep = '\t', comment.char = '@')

count_file <- paste(shortstack_dir, 'NR130vNS233', '/', 'NR130vNS233', 
  '_tot_counts_full.txt', sep = '')
counts_0 <- read.table(count_file, header = T, stringsAsFactors = F, sep = '\t')

count_col_keep <- grep('-Sh', colnames(counts_ord))
counts_ord <- counts_ord[ , c(1, count_col_keep)]

/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_General_lists.r

/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_TC_lists.r

/global/homes/g/grabowsp/tools/CamSat_smRNA/DE_analysis/\
combine_DE_all_lists.r
```



