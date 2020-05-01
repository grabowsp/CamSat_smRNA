# Script for generating fasta-type files from DE summary tables
##  Fasta-type files can be used for comparing to miRNA databases

# Arguments


## module load python/3.7-anaconda-2019.07
## source activate R_analysis

#######

args = commandArgs(trailingOnly = TRUE)

### LOAD DATA ###

data_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists/'

comp <- args[1]
#comp <- 'HMT5vHMT102'

list_type <- args[2]
#list_type <- 'TC'

if(list_type == 'General'){in_file_suf <- '_DE_smRNAs_List1.txt'}
if(list_type == 'TC'){in_file_suf <- '_DE_smRNAs_List2.txt'}
if(list_type == 'Full'){in_file_suf <- '_DE_smRNAs_List3.txt'}

file_in <- paste(data_dir, comp, '_', list_type, in_file_suf, sep = '')
data <- read.table(file_in, header = T, stringsAsFactors = F, sep = '\t')

### SET OUTPUTS ###
out_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas/'

out_file <- paste(out_dir, comp, '_', list_type, '_DE_smRNA.fa', sep = '')

##################

fa_locus_name <- paste('>locus_', data$locus_name, sep = '')

fa_vec <- rep(NA, times = (nrow(data)*2))

seq_inds <- seq(nrow(data)) * 2 
name_inds <- seq_inds -1

fa_vec[name_inds] <- fa_locus_name
fa_vec[seq_inds] <- data$maj_seq

write.table(fa_vec, file = out_file, quote = F, sep = ' ', row.name = F,
  col.names = F)

quit(save = 'no')

