# Steps used for comparing DE hits to known miRNAs

## Approach
* use BLAT to compare DE sequences to know plant miRNAs


* location of fasta's
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas/`


* location of miRNA database files
  * /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs

## Test running BLAT
```
module load python/3.7-anaconda-2019.07
source activate blat_env

blat -stepSize=1 -minScore=0 -minIdentity=0 \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/\
plant_nrd_miR_stem_loop_noDupNames.txt \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas/\
HMT5vHMT102_TC_DE_smRNA.fa \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
HMT5vHMT102_TC.psl


blat -stepSize=1 -minScore=0 -minIdentity=0 \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/\
plant_nrd_miR_stem_loop_noDupNames.txt \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas/\
HMT5vHMT102_General_DE_smRNA.fa \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
HMT5vHMT102_General.psl

blat -stepSize=1 -minScore=0 -minIdentity=0 \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/\
plant_nrd_miR_mature_noDupNames.txt \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas/\
HMT5vHMT102_General_DE_smRNA.fa \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
HMT5vHMT102_General_mature.psl


```
## Adjust miRNA db so that names are not duplicated
* stem_loop
```
# module load python/3.7-anaconda-2019.07
# source activate R_analysis

db_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/plant_nrd_miR_stem_loop.txt'

db_raw <- read.table(db_file, header = F, stringsAsFactors = F)

seq_inds <- seq(nrow(db_raw)/2)*2
name_inds <- seq_inds - 1

dup_inds <- which(duplicated(db_raw[name_inds,1]))


dup_names <- names(which(table(db_raw[name_inds,1]) > 1))
for(dn in dup_names){
  dn_inds <- which(db_raw[ ,1] == dn)
  dn_length <- length(dn_inds)
  db_raw[dn_inds, 1] <- paste(db_raw[dn_inds,1], seq(dn_length), sep = '_')
}

db_sl_out <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/plant_nrd_miR_stem_loop_noDupNames.txt'

write.table(db_raw, file = db_sl_out, quote = F, row.names = F, 
  col.names = F)
```
* mature
```
# module load python/3.7-anaconda-2019.07
# source activate R_analysis

db_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/plant_nrd_miR_mature.txt'

db_raw <- read.table(db_file, header = F, stringsAsFactors = F)

seq_inds <- seq(nrow(db_raw)/2)*2
name_inds <- seq_inds - 1

dup_inds <- which(duplicated(db_raw[name_inds,1]))

dup_names <- names(which(table(db_raw[name_inds,1]) > 1))
for(dn in dup_names){
  dn_inds <- which(db_raw[ ,1] == dn)
  dn_length <- length(dn_inds)
  db_raw[dn_inds, 1] <- paste(db_raw[dn_inds,1], seq(dn_length), sep = '_')
}

db_m_out <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/plant_nrd_miR_mature_noDupNames.txt'

write.table(db_raw, file = db_m_out, quote = F, row.names = F, 
  col.names = F)

```


##
```
blat_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/HMT5vHMT102_General_mature.psl'

blat_res <- read.table(blat_file, header = F, skip = 6, 
  stringsAsFactors = F, sep = '\t')

blat_res_head <- system(paste('head -4 ', blat_file, ' | tail -2'), 
  intern = T)

blat_res_head_1 <- strsplit(blat_res_head, split = '\t')

blat_head <- gsub(' ', '', c(paste(unlist(blat_res_head_1[[1]])[1:18], 
  unlist(blat_res_head_1[[2]]), sep = ''), 
  unlist(blat_res_head_1[[1]])[19:21]))

colnames(blat_res) <- blat_head
```
* for 'mature', I think I'll use match=18 (or 17) as cutoff

