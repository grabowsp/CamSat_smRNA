# Script for identifying differentially expressed genes in a time course
#  experiment of a Treatment vs Control using the DESeq2 R package

# Arguments:
# [1]: (character) filename of read-count expression matrix; rows = genes, 
#        columns = read counts per library/sample; first column = gene names;
#        column names must have sample/library name
# [2]: (character) filename of metadata for sequencing libraries;
#        Must contain:
#        i) column named <SampleName> with names of technical samples/libraries
#             that corresponds to colunn names of read-count matrix
#        ii) column named <Treatment> which indicates which overall biological
#              sample, line, or treatment the library comes from 
#              ex: Control, Salt, 167 
# [3]: (character) filename of low-correlation libraries to be removed;
#        Should be one library per row
# [4]: (character) prefix for the file names that will be returned/saved
# [5]: (character) the name of the Control line or treatment as written
#        in the <Treatment> column of the sample metadata
# [6]: (character) the name of the Comparison line or treatment as written
#        in the <Treatment> column of the sample metadata
# [7]: (character) the Time Points to be compared, as written in the <Time> 
#        column of the dample metadata; 
#        time pointes separated by ',' and no spaces
#################

args = commandArgs(trailingOnly = TRUE)

# INPUT FILES #
count_file <- args[1] 
#count_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/MT5v8171/MT5v8171_tot_counts_full.txt'
counts <- read.table(count_file, header = T, stringsAsFactors = F, sep = '\t')
# NOTE: first column of matrix should be the names of the genes 

samp_meta_file <- args[2]
#samp_meta_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA//smRNA_Library_Info_Sample_Info.tsv'
samp_meta <- read.table(samp_meta_file, header = T, stringsAsFactors = F,
               sep = '\t')

bad_library_file <- args[3]
#bad_library_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/bad_libraries.txt'
bad_libs <- read.table(bad_library_file, header = F, stringsAsFactors = F)

# SET VARIABLES #
out_pre <- args[4]
#out_pre <- 'MT5v8171'

control_treatment <- args[5]
#control_treatment <- 'MT5'
comp_treatment <- args[6]
#comp_treatment <- '8171'

time_comps_in <- args[7]
#time_comps_in <- '10DAF,12DAF'
time_comps <- unlist(strsplit(time_comps_in, split = ','))

# SET CONSTANTS #
min_floor_count_cut <- 5
# any genes for which no libraries have a greater read count than this are
#   removed

p_cut <- 0.05
# the significance cutoff for the multiple testing-corrected p-values

# LOAD LIBRARYS #
library('DESeq2')

#####################
# SCRIPT
# adjust counts matrix
counts_full_0 <- counts[, -1]
rownames(counts_full_0) <- counts[,1]

# remove bad libraries
rm_lib_inds <- which(colnames(counts_full_0) %in% bad_libs[,1])
if(length(rm_lib_inds) > 0){
  counts_full <- counts_full_0[, -rm_lib_inds]
} else{
  counts_full <- counts_full_0
}

# Re-order metadata so samples are in same order as count data
ph_order <- c()
for(i in seq(ncol(counts_full))){
  temp_ind <- which(samp_meta$SampleName == colnames(counts_full)[i])
  ph_order <- c(ph_order, temp_ind)
}
samp_meta_full <- samp_meta[ph_order, ]

# adjust count and metadata to only include required libraries
control_meta_inds <- which(samp_meta_full$Treatment == control_treatment)
comp_meta_inds <- which(samp_meta_full$Treatment == comp_treatment)

meta_time_inds <- which(samp_meta_full$Time %in% time_comps)

samp_meta_2 <- samp_meta_full[
  intersect(c(control_meta_inds, comp_meta_inds), meta_time_inds), ]

counts_1 <- counts_full[, samp_meta_2$SampleName]

# Don't pre-normalize with DESeq2 because calculations require non-normalized
#   data

# Remove genes with low counts across samples
max_count <- apply(counts_1, 1, max)
low_rows <- which(max_count <= min_floor_count_cut)
counts_2 <- counts_1[-low_rows, ]
# REMOVE FOLLOWING LINE WHEN DONE TESTING!!!!
#counts_2 <- counts_2[c(1:500), ]

# format metadata
samp_meta_2$SampleName <- as.factor(samp_meta_2$SampleName)
alt_treats <- setdiff(unique(samp_meta_2$Treatment), control_treatment)
treat_order <- c(control_treatment, alt_treats)
samp_meta_2$Treatment <- factor(samp_meta_2$Treatment, levels = treat_order)
#samp_meta_2$Replicate <- as.factor(samp_meta_2$Replicate)
samp_meta_2$Time <- factor(samp_meta_2$Time, levels = time_comps)

# Analysis looking for overall differences between lines, without modeling
#  different responses across time
dds <- DESeqDataSetFromMatrix(countData = counts_2, colData = samp_meta_2, 
         design = ~ Time + Treatment)
dds <- DESeq(dds)
res <- results(dds)
keep_0_inds <- which(res$padj < p_cut)
resSig <- res[keep_0_inds, ]
res_DF <- as.data.frame(resSig)
res_DF_0 <- data.frame(gene = rownames(res_DF), res_DF, stringsAsFactors = F)

tot_0_df <- data.frame(gene = rownames(res_DF), 
  baseMean = res_DF$baseMean,
  stringsAsFactors = F)

var_0_names <- resultsNames(dds)
for(i in var_0_names){
  tmp_res <- results(dds, name = i, test = 'Wald')
  tmp_resSig <- as.data.frame(tmp_res[keep_0_inds, -1])
  tmp_colnames <- paste(i, colnames(tmp_resSig), sep = '_')
  tot_0_df[, tmp_colnames] <- tmp_resSig
}

out_gen_gene_file <- paste(out_pre, 'DESeq2_general_genes.txt', sep = '_')
write.table(res_DF_0[, c('gene', 'pvalue', 'padj')], file = out_gen_gene_file,
  quote = F, sep = '\t', row.names = F, col.names = T)

out_gen_full_file <- paste(out_pre, 'DESeq2_general_full_mat.txt', sep = '_')
write.table(tot_0_df, file = out_gen_full_file, quote = F, sep = '\t', 
  row.names = F, col.names = T)

############
# Analysis with modeling response to time; keep Time as a factor because
#   we do NOT expect fold-change to increase with time 
ddsTC <- DESeqDataSetFromMatrix(countData = counts_2, colData = samp_meta_2, 
           design = ~ Treatment + Time + Treatment:Time)
ddsTC <- DESeq(ddsTC, test = 'LRT', reduced = ~ Treatment + Time)
resTC <- results(ddsTC)
keep_inds <- which(resTC$padj < p_cut)
resTCSig <- resTC[keep_inds, ]
resTC_DF <- as.data.frame(resTCSig)

# data.frame with gene and p-value from LRT
TC_gene_df <- data.frame(gene = rownames(resTC_DF), LRT_pval = resTC_DF$pvalue,
  LRT_adj_pval = resTC_DF$padj, stringsAsFactors = F)

# Extract info from the different variables in the model
tot_df <- data.frame(gene = rownames(resTC_DF), baseMean = resTC_DF$baseMean, 
  LRT_pval = resTC_DF$pvalue, LRT_adj_pval = resTC_DF$padj, 
  stringsAsFactors = F)

var_names <- resultsNames(ddsTC)
#var_names <- var_names[-grep('^Time', var_names)]
for(i in var_names){
  tmp_res <- results(ddsTC, name = i, test = 'Wald')
  tmp_resSig <- as.data.frame(tmp_res[keep_inds, -1])
  tmp_colnames <- paste(i, colnames(tmp_resSig), sep = '_')
  tot_df[,tmp_colnames] <- tmp_resSig
}

# Write file with gene names and LRT p-values
out_gene_name <- paste(out_pre, 'DESeq2_TC_genes.txt', sep = '_')
write.table(TC_gene_df, file = out_gene_name, quote = F, sep = '\t',
  row.names = F, col.names = T)

# Write file with all the info from the LRT and non-TimevsTime comparisons
out_tot_name <- paste(out_pre, 'DESeq2_TC_full_mat.txt', sep = '_')
write.table(tot_df, file = out_tot_name, quote = F, sep = '\t',     
  row.names = F, col.names = T)

quit(save = 'no')

