# Process for generating count matrices for DESeq2 from shortstack output

## Overview
### Approach
* Use `Counts.txt` file to generate a count file formatted for DESeq2
* First try using all the smRNA counts
* Then see if/how results are affected by removing the un-placed smRNAs
### Steps
* Start with MT5vs8171
  * This comparison has 3 time points and 3 libraries per time point
    * Good replication in order to test the reliability of the approach
  * Generate DESeq2 count matrices
    1. First using all smRNA in `Counts.txt`
    2. Second using only smRNA assigned a genomic position
  * Assess results using the two matrices
    * Correlation of replicates
    * Number of DE smRNAs
    * How many un-positioned smRNAs
    * Look for Kmers from top 10 hits to see similar smRNAs show up
    * Choose the best approach
  * Generate input for maSigPro
  * Generate input for splineTimeR
  * Generalize input-genrating scripts
    * Do here, but is for other comparisons
  * Run maSigPro
  * Run splineTimeR
  * Generalize DE-program scripts
    * De here, but is for other comparisons
  * Organize Results
* Remaining comparisons
  * Generalize input-generating scripts
    * see above
  * Generalize DE-program scripts
    * see above
  * splineTimeR only for the 2 comparisons with 3+ time points
    * MT5 vs 8171
    * HMT5 vs HMT102
  * Only DESeq2 for the 2 comparisons with only 1 time point
    * HNT5 vs HMT102 Flowers
    * PR33-Sh vs PS69-Sh - PS69-Sh-72H only has 1 library
* Other posibilities
  * Sh- and R-specific DE
    * Might want to rerun shortstack with all Sh and R libraries together

## MT5 vs 8171
### File locations
* shortstack output directory
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/MT5v8171`
### Tmp R workspace
```
#####
module load python/3.7-anaconda-2019.07
source activate R_analysis
#######

data_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/MT5v8171/'
comp_name <- rev(unlist(strsplit(data_dir, split = '/')))[1]
count_file <- paste(data_dir, 'Counts.txt', sep = '')
#count_data <- read.table(count_file, header = T, stringsAsFactors = F, 
  sep = '\t')
# note - this works if remove the un-positioned smRNAs from the Counts file
count_data <- read.table(count_file, header = F, stringsAsFactors = F,
  sep = '#')

test_1 <- unlist(strsplit(count_data[1,1], split = '\t'))
test_2 <- unlist(strsplit(count_data[2,1], split = '\t'))
test_big <- unlist(strsplit(count_data[528001,1], split = '\t'))
test_big_2 <- unlist(strsplit(count_data[529001,1], split = '\t'))

test_big_sub <- test_big[-which(test_big == '')]

counts_colnames <- unlist(strsplit(count_data[1,1], split = '\t'))
counts_colnames <- gsub('.prepped', '', counts_colnames, fixed = T)

counts_list_1 <- strsplit(count_data[c(2:nrow(count_data)),1], split = '\t')
counts_list_2 <- lapply(counts_list_1, function(x) if(sum(x == '') > 0){x[-which(x == '')]}else{x})

counts_mat <- matrix(unlist(counts_list_2), nrow = length(counts_list_2),
  byrow = T)
counts_df <- data.frame(counts_mat, stringsAsFactors = F)
for(i in c(3:ncol(counts_df))){
  counts_df[,i] <- as.numeric(counts_df[,i])
}
colnames(counts_df) <- counts_colnames

counts_df$Name[which(counts_df$Name == 'NA')] <- counts_df$Locus[
  which(counts_df$Name == 'NA')]

counts_for_DE <- counts_df[, c(2, c(4:ncol(counts_df)))]
colnames(counts_for_DE)[1] <- 'GeneID'

counts_only_placed <- counts_for_DE[grep('Cluster_', counts_for_DE$GeneID), ]

counts_out_full <- paste(data_dir, comp_name, '_tot_counts_full.txt', sep = '')
counts_out_good <- paste(data_dir, comp_name, '_tot_counts_good.txt', sep = '')

write.table(counts_for_DE, file = counts_out_full, quote = F, sep = '\t',
  row.names = F, col.names = T)

write.table(counts_only_placed, file = counts_out_good, quote = F, sep = '\t',
  row.names = F, col.names = T)
```
### Generate Correlation Heatmap
```
#####
module load python/3.7-anaconda-2019.07
source activate R_analysis
#####

library(reshape2)
library(ggplot2)

data_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/MT5v8171/'
comp_name <- rev(unlist(strsplit(data_dir, split = '/')))[1]
full_counts_name <- paste(data_dir, comp_name, '_tot_counts_full.txt', sep = '')
good_counts_name <- paste(data_dir, comp_name, '_tot_counts_good.txt', sep = '')

full_counts <- read.table(full_counts_name, header = T, stringsAsFactors = F,
  sep = '\t')

good_counts <- read.table(good_counts_name, header = T, stringsAsFactors = F,
  sep = '\t')

info_file <- paste('/global/cscratch1/sd/grabowsp/CamSat_smRNA/', 
  'smRNA_Library_Info_Sample_Info.tsv', sep = '')
samp_info <- read.table(info_file, header = T, stringsAsFactors = F, sep = '\t')

info_0 <- samp_info[which(samp_info$LibName %in% colnames(full_counts)),]

info_1 <- info_0[order(info_0$Time), c(1:3)]
info_2 <- info_1[order(info_1$Sample), ]

full_counts_1 <- full_counts[, info_2$LibName]

descr_names <- paste(info_2$Sample, info_2$Time, info_2$LibName, sep = '_')

colnames(full_counts_1) <- descr_names

full_count_cor <- cor(x = full_counts_1, method = 'pearson')
full_count_cor_round <- round(full_count_cor, digits = 2)
full_count_cor_melt <- melt(full_count_cor_round)

gg_full_heat <- ggplot(data = full_count_cor_melt, aes(x=Var1, y = Var2, 
  fill = value)) + 
  geom_tile() +
  scale_fill_gradient2(low = 'red', high = 'darkgreen', mid = 'white', 
    midpoint = 0.5, limit = c(0,1), space = 'Lab', 
    name = 'Pearson\nCorrelation') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 14, 
    hjust = 1), axis.text.y = element_text(size = 14)) +
  coord_fixed() +
  geom_text(aes(Var2, Var1, label = value), color = 'black', size = 6)

full_heat_file <- paste(data_dir, comp_name, 'smRNA_cor_heatmap.pdf', sep = '')

pdf(full_heat_file, width = 12*4, height = 9*4)
gg_full_heat
dev.off()

good_counts_1 <- good_counts[, info_2$LibName]
colnames(good_counts_1) <- descr_names
good_count_cor <- cor(x = good_counts_1, method = 'pearson')
good_count_cor_round <- round(good_count_cor, digits = 2)
good_count_cor_melt <- melt(good_count_cor_round)

gg_good_heat <- ggplot(data = good_count_cor_melt, aes(x=Var1, y = Var2,
  fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = 'red', high = 'darkgreen', mid = 'white', 
    midpoint = 0.5, limit = c(0,1), space = 'Lab', 
    name = 'Pearson\nCorrelation') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 14, 
    hjust = 1), axis.text.y = element_text(size = 14)) +
  coord_fixed() +
  geom_text(aes(Var2, Var1, label = value), color = 'black', size = 6)

good_heat_file <- paste(data_dir, comp_name, 'smRNA_cor_heatmap_good.pdf', 
  sep = '')

pdf(good_heat_file, width = 12*4, height = 9*4)
gg_good_heat
dev.off()

```

### Libraries to remove if use 0.95 as correlation cutoff
* Patterns are the same in heatmaps for Full Counts and Good Counts
* Based on correlations, CANNOT use 8171_8DAF because the 3 reps have low cor
  * means that 8DAF CANNOT be used for comparisons.
#### Full Counts
* GNXGN
  * is 8171_12DAF, but highest cor with other reps is 0.86
* GNXCZ
  * is 8171_8DAF but highest cor is 0.91 and one cor is 0.75
* GNXGA
  * is 8171_8DAF, highest cor is 0.91
* GNXGB
  * is 8171_8DAF, highest cor 0.88
* GNXGX
  * is MT5_10DAF, highest cor is 0.93
* GNXGT
  * is MT5_8DAF, highest cor is 0.89

### Generate matrices for rest of the comparisons
```
module load python/3.7-anaconda-2019.07
source activate R_analysis

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results

for COMP in HMT5vHMT102 HMT5vHMT102_flowers HMT5vM3246 NR130vNS233 PR33vPS69;
  do
  cd $COMP;
  Rscript

```
