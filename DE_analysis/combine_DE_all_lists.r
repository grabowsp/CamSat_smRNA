# Script to combine lists from DESeq2 and maSigPro

# module load python/3.7-anaconda-2019.07
# source activate R_analysis

args = commandArgs(trailingOnly = T)

### LOAD DATA ###
comp_name <- args[1]
#comp_name <- 'MT5v8171'

# load DESeq2 and maSigPro results
deseq_res_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/DESeq2_results/'
masig_res_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/maSigPro_results/'

deseq_gen_gene_suf <- '_DESeq2_general_genes.txt'
masig_gen_gene_suf <- '_General_DE_genes.txt'
deseq_tc_gene_suf <- '_DESeq2_TC_genes.txt'
masig_tc_gene_suf <- '_TC_DE_genes.txt'

deseq_gen_gene_file <- paste(deseq_res_dir, comp_name, deseq_gen_gene_suf, 
  sep = '')
deseq_gen_gene_0 <- read.table(deseq_gen_gene_file, header = T, sep = '\t',
  stringsAsFactors = F)
deseq_tc_gene_file <- paste(deseq_res_dir, comp_name, deseq_tc_gene_suf,
  sep = '')
deseq_tc_gene_0 <- read.table(deseq_tc_gene_file, header = T, sep = '\t',
  stringsAsFactors = F)

masig_gen_gene_file <- paste(masig_res_dir, comp_name, masig_gen_gene_suf,
  sep = '')
masig_gen_gene_0 <- read.table(masig_gen_gene_file, header = T, sep = '\t',
  stringsAsFactors = F)
masig_tc_gene_file <- paste(masig_res_dir, comp_name, masig_tc_gene_suf,
  sep = '')
masig_tc_gene_0 <- read.table(masig_tc_gene_file, header = T, sep = '\t',
  stringsAsFactors = F)

# load shortstack counts and info
shortstack_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/'
shortstack_res_file <- paste(shortstack_dir, comp_name, '/Results.txt', 
  sep = '')
shortstack_res_0 <- read.table(shortstack_res_file, header = T, 
  stringsAsFactors = F, sep = '\t', comment.char = '@')

shortstack_unplaced_file <- paste(shortstack_dir, comp_name, '/Unplaced.txt', 
  sep = '')
shortstack_unplaced_0 <- read.table(shortstack_unplaced_file, header = T,
  stringsAsFactors = F, sep = '\t', comment.char = '@')

count_file <- paste(shortstack_dir, comp_name, '/', comp_name, 
  '_tot_counts_full.txt', sep = '')
counts_0 <- read.table(count_file, header = T, stringsAsFactors = F, sep = '\t')

# load bad lib list
bad_lib_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/bad_libraries.txt'
bad_libs <- read.table(bad_lib_file, header = F, stringsAsFactors = F)[,1]

# load lib info
lib_info_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/smRNA_Library_Info_Sample_Info.tsv'
lib_info <- read.table(lib_info_file, header = T, stringsAsFactors = F, 
  sep = '\t')

### SET OUTPUT ###
combo_list_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists/'
combo_out_suf <- '_Full_DE_smRNAs_List3.txt'
combo_out_file <- paste(combo_list_dir, comp_name, combo_out_suf, sep = '')

####################

deseq_gen_gene <- deseq_gen_gene_0[order(deseq_gen_gene_0$gene), ]
masig_gen_gene <- masig_gen_gene_0[order(masig_gen_gene_0$genes), ]
deseq_tc_gene <- deseq_tc_gene_0[order(deseq_tc_gene_0$gene), ]
masig_tc_gene <- masig_tc_gene_0[order(masig_tc_gene_0$genes), ]

shortstack_res <- shortstack_res_0[order(shortstack_res_0$Name), ]
shortstack_unplaced <- shortstack_unplaced_0[order(shortstack_unplaced_0[,1]),]

all_hits <- sort(union(deseq_gen_gene$gene, union(deseq_tc_gene$gene, 
  union(masig_gen_gene$genes, masig_tc_gene$genes))))

combo_df <- data.frame(locus_name = all_hits, stringsAsFactors = F)

c_deseq_gen_inds <- which(combo_df$locus_name %in% deseq_gen_gene$gene)
combo_df$deseq2_gen_pval <- NA
combo_df$deseq2_gen_pval[c_deseq_gen_inds] <- deseq_gen_gene$padj

c_deseq_tc_inds <- which(combo_df$locus_name %in% deseq_tc_gene$gene)
combo_df$deseq2_tc_pval <- NA
combo_df$deseq2_tc_pval[c_deseq_tc_inds] <- deseq_tc_gene$LRT_adj_pval

c_masig_gen_inds <- which(combo_df$locus_name %in% masig_gen_gene$genes)
combo_df$masigpro_gen_pval <- NA
combo_df$masigpro_gen_pval[c_masig_gen_inds] <- masig_gen_gene$p_val

c_masig_tc_inds <- which(combo_df$locus_name %in% masig_tc_gene$genes)
combo_df$masigpro_tc_pval <- NA
combo_df$masigpro_tc_pval[c_masig_tc_inds] <- masig_tc_gene$p_val

ss_inds <- which(shortstack_res$Name %in% combo_df$locus_name)
c_in_ss_inds <- which(combo_df$locus_name %in% shortstack_res$Name)

up_inds <- which(shortstack_unplaced[,1] %in% combo_df$locus_name)
c_in_up_inds <- which(combo_df$locus_name %in% shortstack_unplaced[,1])

combo_df$maj_seq <- NA
combo_df$maj_seq[c_in_ss_inds] <- shortstack_res$MajorRNA[ss_inds]
combo_df$maj_seq[is.na(combo_df$maj_seq)] <- combo_df$locus_name[
  is.na(combo_df$maj_seq)]

combo_df$shortstack_miRNA <- NA
combo_df$shortstack_miRNA[c_in_ss_inds] <- shortstack_res$MIRNA[ss_inds]

combo_df$locus_length <- NA
combo_df$locus_length[c_in_ss_inds] <- shortstack_res$Length[ss_inds]
combo_df$locus_length[c_in_up_inds] <- shortstack_unplaced$Length[up_inds]

combo_df$n_geno_hits <- NA
combo_df$n_geno_hits[c_in_ss_inds] <- 1
combo_df$n_geno_hits[c_in_up_inds] <- shortstack_unplaced$N_hits[up_inds]

pos_list <- strsplit(shortstack_res[ss_inds, 1], split = ':')
chr_vec <- unlist(lapply(pos_list, function(x) x[1]))
pos_2_list <- lapply(pos_list, function(x) strsplit(x[2], split = '-'))
start_vec <- as.numeric(unlist(lapply(pos_2_list, function(x) x[[1]][1])))
end_vec <- as.numeric(unlist(lapply(pos_2_list, function(x) x[[1]][2])))

combo_df$chr <- NA
combo_df$start_pos <- NA
combo_df$end_pos <- NA
combo_df$chr[c_in_ss_inds] <- chr_vec
combo_df$start_pos[c_in_ss_inds] <- start_vec
combo_df$end_pos[c_in_ss_inds] <- end_vec

#####
bad_count_cols <- which(colnames(counts_0) %in% bad_libs)
if(length(bad_count_cols) > 0){
 counts <- counts_0[, -bad_count_cols]} else{
 counts <- counts_0}

lib_info$full_name <- paste(lib_info$Treatment, lib_info$Time, 
  lib_info$SampleName, sep = '_')

for(i in c(2:ncol(counts))){
  li_ind <- which(lib_info$SampleName == colnames(counts)[i])
  colnames(counts)[i] <- lib_info$full_name[li_ind]
}

counts_ord <- counts[order(counts$GeneID), ]
counts_inds <- which(counts_ord$GeneID %in% combo_df$locus_name)
c_in_counts_inds <- which(combo_df$locus_name %in% counts_ord$GeneID)

combo_df_1 <- combo_df[, c('locus_name', 'chr', 'start_pos', 'end_pos',
  'locus_length', 'n_geno_hits', 'deseq2_gen_pval', 'deseq2_tc_pval', 
  'masigpro_gen_pval', 'masigpro_tc_pval', 'maj_seq',
  'shortstack_miRNA')]

combo_df_1[, colnames(counts_ord)[-1]] <- NA
combo_df_1[c_in_counts_inds, colnames(counts_ord)[-1]] <- counts_ord[
  counts_inds, -1]

combo_df_2 <- combo_df_1[order(combo_df_1$deseq2_gen_pval), ]

####
write.table(combo_df_2, file = combo_out_file, quote = F, sep = '\t', 
  row.names = F, col.names = T)

quit(save = 'no')

