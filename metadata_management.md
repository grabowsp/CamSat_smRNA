# Management of Metadata

## Sample and JGI sequencing info
* Tables in Google Sheets
  * `https://docs.google.com/spreadsheets/d/1zYVVZZDSPbglKjMr2tBUldMQf-8VQ22JMs-_Zhktj6o/edit?usp=sharing`
* Combined File with sample, experimental, and prelim NERSC analysis info
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/smRNA_combo_info.txt`
* List of Library Names
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_libs.txt`
### Steps
* Manually input experiment info from Chaofu's document
* Process sample and NERSC analysis info from Chaofu's document
* Combine everything into a single table
### Process Files
* In R
* I copied sample and library info from the document sent by Chaofu, pasted \
it into TextEdit, convert to Plain Text, and processed with following code
* Also included experiment info that I manually inputted based on the info \
in the same document
```
jgi_sample_file <- '/Users/grabowsk/Desktop/smRNA_JGI_sample_summary.txt'
jgi_samp_info <- read.table(jgi_sample_file, header = F, stringsAsFactors = F, 
  sep = '\t')

jgi_samp_info <- gsub('\u2028', 'SPLIT_HERE', jgi_samp_info)
jgi_samp <- unlist(strsplit(jgi_samp_info, split = 'SPLIT_HERE'))

samp_list <- strsplit(jgi_samp, split = ' ')

# these files have a weird blank space that needs to be removed
mystery_char <- unlist(strsplit(samp_list[[1]][1], split = ''))[6]

samp_list_A <- lapply(samp_list, function(x) gsub(mystery_char, '', x))
samp_list_2 <- lapply(samp_list_A, function(x) x[-which(x == '')])

jgi_samp_df <- data.frame(
  lib_name = unlist(lapply(samp_list_2, function(x) x[1])),
  samp_name = unlist(lapply(samp_list_2, function(x) x[5])),
  samp_id = unlist(lapply(samp_list_2, function(x) x[2])),
  condition_num = unlist(lapply(samp_list_2, function(x) x[6])),
  raw_reads = unlist(lapply(samp_list_2, function(x) x[3])),
  filt_reads = unlist(lapply(samp_list_2, function(x) x[4])),
  sequencer_type = unlist(lapply(samp_list_2, function(x) x[7])),
  run_type = unlist(lapply(samp_list_2, function(x) x[8])),
  fastq_file = unlist(lapply(samp_list_2, function(x) x[9])),
  stringsAsFactors = F)


jgi_lib_file <- '/Users/grabowsk/Desktop/smRNA_JGI_Lib_summaryStats.txt'
jgi_lib_info <- read.table(jgi_lib_file, header = F, stringsAsFactors = F,
  sep = '\t')

jgi_lib_info <- gsub('\u2028', 'SPLIT_HERE', jgi_lib_info)
jgi_lib <- unlist(strsplit(jgi_lib_info, split = 'SPLIT_HERE'))

lib_list <- strsplit(jgi_lib, split = ' ')
lib_list_A <- lapply(lib_list, function(x) gsub(mystery_char, '', x))
lib_list_2 <- lapply(lib_list_A, function(x) x[-which(x == '')])


jgi_lib_df <- data.frame(
  lib_name = unlist(lapply(lib_list_2, function(x) x[1])),
  ref_genome = unlist(lapply(lib_list_2, function(x) x[2])),
  alignment_rate = unlist(lapply(lib_list_2, function(x) x[3])),
  tot_mapped_20_24 = unlist(lapply(lib_list_2, function(x) x[4])),
  align_mapped_20_24 = unlist(lapply(lib_list_2, function(x) x[5])),
  n_uniq_mapped_reads = unlist(lapply(lib_list_2, function(x) x[6])),
  unique_pct = unlist(lapply(lib_list_2, function(x) x[7])),
  m_multi_mapped_reads = unlist(lapply(lib_list_2, function(x) x[8])),
  multi_pct = unlist(lapply(lib_list_2, function(x) x[9])),
  n_unmapped = unlist(lapply(lib_list_2, function(x) x[10])),
  unmapped_pct = unlist(lapply(lib_list_2, function(x) x[11])),
  n_smRNA_loci = unlist(lapply(lib_list_2, function(x) x[12])),
  n_annot_loci = unlist(lapply(lib_list_2, function(x) x[13])),
  frac_dicer = unlist(lapply(lib_list_2, function(x) x[14])),
  n_miRNA = unlist(lapply(lib_list_2, function(x) x[15])),
  n_novel_miRNA = unlist(lapply(lib_list_2, function(x) x[16])), 
  stringsAsFactors = F)

for(i in c(3:ncol(jgi_lib_df))){
  jgi_lib_df[, i] <- as.numeric(jgi_lib_df[,i])
}

manual_info_file <- '/Users/grabowsk/Desktop/manual_smRNA_info.txt'
manual_info <- read.table(manual_info_file, header = T, sep = '\t', 
  stringsAsFactors = F)

sum(jgi_lib_df$lib_name %in% jgi_samp_df$lib_name)
# [1] 100

sum(jgi_samp_df$lib_name %in% jgi_lib_df$lib_name)
# 107

# some of the libraries were sequenced twice, so need to combine these data

jgi_samp_df_2 <- jgi_samp_df[-which(duplicated(jgi_samp_df$lib_name)), ]

jgi_samp_df_2[, c('raw_reads_2', 'filt_reads_2', 'fastq_file_2')] <- NA

for(dl in which(duplicated(jgi_samp_df$lib_name))){
  tmp_ind_2 <- which(jgi_samp_df_2$lib_name == jgi_samp_df$lib_name[dl]) 
  jgi_samp_df_2$raw_reads_2[tmp_ind_2] <- jgi_samp_df$raw_reads[dl]
  jgi_samp_df_2$filt_reads_2[tmp_ind_2] <- jgi_samp_df$filt_reads[dl]
  jgi_samp_df_2$fastq_file_2[tmp_ind_2] <- jgi_samp_df$fastq_file[dl]
}

sum(jgi_samp_df_2$lib_name %in% manual_info$LibName)
# [1] 98

setdiff(jgi_samp_df_2$lib_name, manual_info$LibName)
# [1] "GNXCB" "GNXCC"
# These 2 libraries are HMT5-25D, but 25DTF is not in any of the analyses

# Make final file:
Contains all the info from the 3 sub-files

man_sort_df <- manual_info[order(manual_info$LibName), ]

jgi_samp_3 <- jgi_samp_df_2[which(jgi_samp_df_2$lib_name %in% 
  man_sort_df$LibName), ]

jgi_samp_sort <- jgi_samp_3[order(jgi_samp_3$lib_name), ]

jgi_lib_2 <- jgi_lib_df[which(jgi_lib_df$lib_name %in% man_sort_df$LibName), ]

jgi_lib_sort <- jgi_lib_2[order(jgi_lib_2$lib_name), ]

combo_smRNA_info <- jgi_samp_sort[, c(1:4)] 
combo_smRNA_info$genotype <- man_sort_df$Sample
combo_smRNA_info$time <- man_sort_df$Time
combo_smRNA_info$experiment_note <- man_sort_df$Note

combo_smRNA_info$raw_reads <- as.numeric(jgi_samp_sort$raw_reads)
combo_smRNA_info$filt_reads <- as.numeric(jgi_samp_sort$filt_reads)
combo_smRNA_info$raw_reads_2 <- as.numeric(jgi_samp_sort$raw_reads_2)
combo_smRNA_info$filt_reads_2 <- as.numeric(jgi_samp_sort$filt_reads_2)

combo_smRNA_info[, c('fastq_file', 'fastq_file_2', 'sequencer_type', 
  'run_type')] <- jgi_samp_sort[, c('fastq_file', 'fastq_file_2', 
  'sequencer_type', 'run_type')]

combo_smRNA_info <- cbind(combo_smRNA_info, 
  jgi_lib_sort[, c(2:ncol(jgi_lib_sort))])

combo_out_file <- '/Users/grabowsk/Desktop/smRNA_combo_info.txt'
write.table(combo_smRNA_info, file = combo_out_file, quote = F, sep = '\t',
  row.names = F, col.names = T)
```

### Generate List of Libraries
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA

cut -f 1 smRNA_combo_info.txt | tail -n +2 > Cs_smRNA_libs.txt
```




