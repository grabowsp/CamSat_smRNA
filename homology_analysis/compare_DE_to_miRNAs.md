# Steps used for comparing DE hits to known miRNAs

## Overview
### Approach
* Generate fasta files from DE lists
* Get miRNA database files
  * miRBASE
    * `http://www.mirbase.org/`
  * PMRD
    * `http://structuralbiology.cau.edu.cn/PNRD/index.php`
* use BLAT to compare DE sequences to know plant miRNAs
### File Locations
* location of combined DE summary tables
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists`
* location of fasta's
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas/`
* location of miRNA database files
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs`
* location of blat output
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/`

## Generate fasta files
* R script
  `Rscript /global/homes/g/grabowsp/tools/CamSat_smRNA/homology_analysis/generate_fasta_locus_files.r`

```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists

module load python/3.7-anaconda-2019.07
source activate R_analysis

for COMPS in HMT5vHMT102 HMT5vM3246 MT5v8171 NR130_RvNS233_R \
NR130_ShvNS233_Sh;
do
  for LT in General TC Full;
  do
    Rscript /global/homes/g/grabowsp/tools/CamSat_smRNA/homology_analysis/\
generate_fasta_locus_files.r \
    $COMPS $LT;
    done
  done

for COMPS in HMT5vHMT102_flowers PR33_RvPS69_R PR33_ShvPS69_Sh;
do
  Rscript /global/homes/g/grabowsp/tools/CamSat_smRNA/homology_analysis/\
generate_fasta_locus_files.r \
  $COMPS General;
  done
```

## Adjust miRNA database files
* the PMRD files needed to be adjusted to adjust duplicated names
### stem_loop
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
### mature
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

## Run BLAT
```
module load python/3.7-anaconda-2019.07
source activate blat_env

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas

for FN in `ls *`;
  do
  TMP_FN=`echo $FN | awk -F'[.]' '{print $1}'`;
  blat -stepSize=1 -minScore=0 -minIdentity=0 \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/\
plant_nrd_miR_stem_loop_noDupNames.txt \
  $FN \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
$TMP_FN'_stemloop.psl';
  done

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas
for FN in `ls *`;
  do
  TMP_FN=`echo $FN | awk -F'[.]' '{print $1}'`;
  blat -stepSize=1 -minScore=0 -minIdentity=0 \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/\
plant_nrd_miR_mature_noDupNames.txt \
  $FN \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
$TMP_FN'_mature.psl';
  done

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas
for FN in `ls *`;
  do
  TMP_FN=`echo $FN | awk -F'[.]' '{print $1}'`;
  blat -stepSize=1 -minScore=0 -minIdentity=0 \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/mature.fa \
  $FN \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
$TMP_FN'_miRBase_mature.psl';
  done

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/DE_res_fastas
for FN in `ls *`;
  do
  TMP_FN=`echo $FN | awk -F'[.]' '{print $1}'`;
  blat -stepSize=1 -minScore=0 -minIdentity=0 \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRNA_dbs/hairpin.fa \
  $FN \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/\
$TMP_FN'_miRBase_hairpin.psl';
  done
```

## Edit BLAT output
* PMRD mature miRNA file
```
#blat_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/HMT5vHMT102_General_mature.psl'

blat_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/HMT5vHMT102_General_DE_smRNA_miRBase_mature.psl'

blat_res <- read.table(blat_file, header = F, skip = 6, 
  stringsAsFactors = F, sep = '\t')

blat_res_head <- system(paste('head -4 ', blat_file, ' | tail -2'), 
  intern = T)

blat_res_head_1 <- strsplit(blat_res_head, split = '\t')

blat_head <- gsub(' ', '', c(paste(unlist(blat_res_head_1[[1]])[1:18], 
  unlist(blat_res_head_1[[2]]), sep = ''), 
  unlist(blat_res_head_1[[1]])[19:21]))

colnames(blat_res) <- blat_head

good_hit_inds <- which(blat_res$match/blat_res$Tsize >= 0.8)

```
* for 'mature', I think I'll use match=18 (or 17) as cutoff

