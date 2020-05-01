# Script for pulling out the top miRNA BLAT hits
#
# Keep BLAT hits that are either:
#   a) identical across 80+% of a mature mRNA
#   b) identical across 80+% of the sequenced smRNA when compared to
#	the hairpin/stem loop RNA sequence
#
# Arguments:
# [1]: (character) the comparison name used in naming files for comparing
#			a set of samples
# [2]: (character) the type of list used to make the BLAT results;
#			examples: 'General', 'TC', 'Full'
##################

args = commandArgs(trailingOnly = TRUE)

### INPUT FILES ###

data_dir <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/'

comp <- args[1]
#comp <- 'HMT5vHMT102'

list_type <- args[2]
#list_type <- 'General'

pmrd_mature_file <- paste(data_dir, comp, '_', list_type, 
  '_DE_smRNA_mature.psl', sep = '')
pmrd_mature_res <- read.table(pmrd_mature_file, header = F, skip = 6,
  stringsAsFactors = F, sep = '\t')

pmrd_sl_file <- paste(data_dir, comp, '_', list_type, 
  '_DE_smRNA_stemloop.psl', sep = '')
pmrd_sl_res <- read.table(pmrd_sl_file, header = F, skip = 6,
  stringsAsFactors = F, sep = '\t')

miR_mature_file <- paste(data_dir, comp, '_', list_type, 
  '_DE_smRNA_miRBase_mature.psl', sep = '')
miR_mature_res <- read.table(miR_mature_file, header = F, skip = 6,
  stringsAsFactors = F, sep = '\t')

miR_hp_file <- paste(data_dir, comp, '_', list_type,
  '_DE_smRNA_miRBase_hairpin.psl', sep = '')
miR_hp_res <- read.table(miR_hp_file, header = F, skip = 6,
  stringsAsFactors = F, sep = '\t')

blat_res_head <- system(paste('head -4 ', pmrd_mature_file, ' | tail -2'),
  intern = T)

blat_res_head_1 <- strsplit(blat_res_head, split = '\t')

blat_head <- gsub(' ', '', c(paste(unlist(blat_res_head_1[[1]])[1:18],
  unlist(blat_res_head_1[[2]]), sep = ''),
  unlist(blat_res_head_1[[1]])[19:21]))

### SET OUTPUT ###

combo_hit_file_out <- paste(data_dir, comp, '_', list_type, 
  '_DE_combo_miRNA_db_hits.txt', sep = '')

miRNA_summ_file_out <- paste(data_dir, comp, '_', list_type, 
  '_DE_miRNA_db_summary.txt', sep = '')

################
colnames(pmrd_mature_res) <- blat_head
colnames(pmrd_sl_res) <- blat_head
colnames(miR_mature_res) <- blat_head
colnames(miR_hp_res) <- blat_head

pmrd_mature_res$db <- 'pmrd_mature'
pmrd_sl_res$db <- 'pmrd_stemloop'
miR_mature_res$db <- 'miRBase_mature'
miR_hp_res$db <- 'miRBase_hairpin'

pmrd_m_good_hits <- which(pmrd_mature_res$match/pmrd_mature_res$Tsize >= 0.8)
miR_m_good_hits <- which(miR_mature_res$match/miR_mature_res$Tsize >= 0.8)

pmrd_sl_good_hits <- which(pmrd_sl_res$match/pmrd_sl_res$Qsize > 0.8)
miR_hp_good_hits <- which(miR_hp_res$match/miR_hp_res$Qsize > 0.8)

cols_to_keep <- c('match', 'mis-match', 'Qname', 'Qsize', 'Tname', 'Tsize',
  'db')

combo_hits <- rbind(pmrd_mature_res[pmrd_m_good_hits, cols_to_keep], 
  miR_mature_res[miR_m_good_hits, cols_to_keep],
  pmrd_sl_res[pmrd_sl_good_hits, cols_to_keep],
  miR_hp_res[miR_hp_good_hits, cols_to_keep])

locus_names <- unique(combo_hits$Qname)

if(length(locus_names) == 0){quit(save = 'no')}

combo_df <- data.frame(locus_name = locus_names, stringsAsFactors = F)
combo_df$candidate_miRNAs <- NA
for(i in seq(nrow(combo_df))){
  loc_na <- combo_df$locus_name[i]
  hit_inds <- which(combo_hits$Qname == loc_na)
  mirna_hits <- unique(combo_hits$Tname[hit_inds])
  mirna_vec <- paste(mirna_hits, collapse = ',')
  combo_df$candidate_miRNAs[i] <- mirna_vec
}

write.table(combo_hits, file = combo_hit_file_out, quote = F, sep = '\t',
  row.names = F, col.names = T)

write.table(combo_df, file = miRNA_summ_file_out, quote = F, sep = '\t',
  row.names = F, col.names = T)

quit(save = 'no')

