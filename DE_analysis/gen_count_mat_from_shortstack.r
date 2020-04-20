# Script for generating a smRNA counts matrix formated for DE analysis from the 
#   Counts.txt output from shortstack

# Arguments:
# [1] = the filename, with full path, of the Counts.txt file outputted by 
#         shortstack
########

args = commandArgs(trailingOnly = TRUE)

### INPUT FILES ###
count_file <- args[1]
#count_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/HMT5vHMT102/Counts.txt'
count_data <- read.table(count_file, header = F, stringsAsFactors = F,
  sep = '#')

### SET OUTPUTS ###
comp_name <- rev(unlist(strsplit(count_file, split = '/')))[2]

counts_out_full <- paste(comp_name, '_tot_counts_full.txt', sep = '')

###################
# process the inputted count_data - the Cluster_ and non-positioned smRNA
#   entries are slightly different and need to be processed accordingly

counts_colnames <- unlist(strsplit(count_data[1,1], split = '\t'))
counts_colnames <- gsub('.prepped', '', counts_colnames, fixed = T)

counts_list_1 <- strsplit(count_data[c(2:nrow(count_data)),1], split = '\t')
counts_list_2 <- lapply(counts_list_1, 
  function(x) if(sum(x == '') > 0){x[-which(x == '')]}else{x})

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

write.table(counts_for_DE, file = counts_out_full, quote = F, sep = '\t',
  row.names = F, col.names = T)

quit(save = 'no')

