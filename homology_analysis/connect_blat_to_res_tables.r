# Script to connect miRNA database BLAT results to smRNA DE tables

# Arguments:
# [1]: (character) the comparison name used in naming files for comparing
#                       a set of samples
# [2]: (character) the type of list used to make the BLAT results;
#                       examples: 'General', 'TC', 'Full'
###############################################

# module load python/3.7-anaconda-2019.07
# source activate R_analysis

args = commandArgs(trailingOnly = TRUE)

### INPUT FILES ###

comp <- args[1]
#comp <- 'HMT5vHMT102'

list_type <- args[2]
#list_type <- 'General'

table_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists/'
blat_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/'

if(list_type == 'General'){tab_suf <- '_DE_smRNAs_List1.txt'}
if(list_type == 'TC'){tab_suf <- '_DE_smRNAs_List2.txt'}
if(list_type == 'Full'){tab_suf <- '_DE_smRNAs_List3.txt'}

tab_file <- paste(table_dir, comp, '_', list_type, tab_suf, sep = '')
tab_df <- read.table(tab_file, header = T, stringsAsFactors = F, sep = '\t')

blat_file <- paste(blat_dir, comp, '_', list_type, 
  '_DE_miRNA_db_summary.txt', sep = '')
if(length(system(paste('ls ', blat_file, sep = ''), intern = T)) > 0){
  blat_df <- read.table(blat_file, header = T, stringsAsFactors = F, 
    sep = '\t')
}else{blat_df <- c()}

### SET OUTPUT ###
tab_out_file <- gsub('.txt', '_v1.0.txt', tab_file, fixed = T)

###################################

tab_df$miRNA_db_hits <- NA

col_reorder <- c(colnames(tab_df)[c(1:10)], 'miRNA_db_hits', 
  colnames(tab_df)[c(11:(ncol(tab_df)-1))])

# include this phrase in case there are no BLAT hits
if(length(blat_df) > 0){
  for(i in seq(nrow(blat_df))){
    loc_name <- gsub('locus_', '', blat_df$locus_name[i])
    tab_inds <- which(tab_df$locus_name == loc_name)
    tab_df$miRNA_db_hits[tab_inds] <- blat_df$candidate_miRNAs[i]
  }
}

tab_df_2 <- tab_df[, col_reorder]

write.table(tab_df_2, file = tab_out_file, quote = F, sep = '\t', 
  row.names = F, col.names = T)

quit(save = 'no')

