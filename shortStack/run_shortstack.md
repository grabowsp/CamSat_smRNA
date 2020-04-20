# Notes for running shortstack

## Overview
* Load shortstack conda environment
* Test shortstack on a single library
* run shortstack with libraries from a single comparison so that same
loci are included in the Counts file

## Test with `GGACY_1`
### Generate Submit Script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results

cp /global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering/GGACY_1/infern_GGACY_1.sh ./GGACY_1_shortstack_test1.sh
* adjust with vim
```
### Example of commands
```
LIB=GGACY_1

READFILE=/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGACY_1/GGACY_1.prepped.fastq.gz

GENOMEFILE=/global/homes/g/grabowsp/data/CamSat/Cs_genome_v2.fasta

PARENT_OUT=/global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/

ShortStack --outdir $PARENT_OUT$LIB'_test1' \
--bowtie_cores 8 --sort_mem 16G --bowtie_m all \
--mincov 4 \
--readfile $READFILE --genomefile $GENOMEFILE
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch GGACY_1_shortstack_test1.sh
```

## Try combinind the GGACY outputs
### Generate Submit Script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp GGACY_1_shortstack_test1.sh GGACY_combined_test1.sh
* adjust with vim
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch GGACY_combined_test1.sh
```

## MT5 vs 8171
* Run shortstack using libraries for the different comparisons so that 
same loci are included in the full comparison
### Overview
* Times: 8DAF, 10DAF, 12DAF
* 3 libraries for each sample and each time point
### Generate submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp GGACY_combined_test1.sh MT5vs8171_shortstack_1.sh
* adjust with vim
* I accidentally deleted the submit script after submitting it
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch MT5vs8171_shortstack_1.sh
```

## HMT5 vs HMT102
### Overview
* Times: 5DF, 10DAF, 15DAF, 20DAF
### Generate submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp MT5vs8171_shortstack_1.sh HMT5vsHMT102_shortstack_1.sh
* adjust with vim
```
### Adjust GGACY into 1 file
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGACY

mv GGACY.prepped.fastq.gz GGACY.prepped.fastq.original.gz
cat ./GGACY.prepped.fastq.original.gz ../GGACY_1/GGACY_1.prepped.fastq.gz \
> GGACY.prepped.fastq.gz
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch HMT5vsHMT102_shortstack_1.sh
```

## HMT5 vs HMT102 Flowers
### Overview
* No times, simply comparing the flowers from the two plants
### Generate submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp MT5vs8171_shortstack_1.sh HMT5vsHMT102_flowers_1.sh
* adjust with vim
```
### Adjust GGAGU into 1 file
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGAGU

mv GGAGU.prepped.fastq.gz GGAGU.prepped.fastq.original.gz
cat ./GGAGU.prepped.fastq.original.gz ../GGAGU_1/GGAGU_1.prepped.fastq.gz \
> GGAGU.prepped.fastq.gz
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch HMT5vsHMT102_flowers_1.sh
```

## HMT5 vs M3246
### Overview
* 2 Time Points
  * 5DAF, 15DAF
* HMT5 has 3 libraries for each timepoint
* M3246 has 3 libraries for 5DAF and only 2 libraries for 15DAF
### Generate Submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp HMT5vsHMT102_flowers_1.sh HMT5vsM3246_shortstack_1.sh
* adjust with vim
```
### Adjust prepped libraries into single fastq files
```
for LIB in GGAGB GGAGC GGAGG GGAGH GGAGN;
do
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/$LIB;
mv $LIB'.prepped.fastq.gz' $LIB'.prepped.fastq.original.gz';
cat ./$LIB'.prepped.fastq.original.gz' \
../$LIB'_1/'$LIB'_1.prepped.fastq.gz' > $LIB'.prepped.fastq.gz';
done
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch HMT5vsM3246_shortstack_1.sh
```

## PR33 vs PS69
### Overview
* True comparisons are Sh vs Sh and R vs R
* I will run Sh and R together in case we want to look at tissue-specific miRNAs
* 2 tissues: Sh (shoot) and R (root)
* 2 time points for each tissue: 0H and 72H
* PR33-R has 3 libraries for all time points except only 2 for R-72H
* PS69 has 3 libraries for all except only 1 for Sh-72H
  * we won't be able to use this time for DESeq2 but I'll still keep it in case we want to see modules
### Generate Submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp HMT5vsHMT102_shortstack_1.sh PR33vsPS69_shortstack_1.sh
* adjust with vim
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch PR33vsPS69_shortstack_1.sh
```

## NR130 vs NS233
### Overview
* True comparisons are Sh vs Sh and R vs R
* I will run Sh and R together in case we want to look at tissue-specific miR
NAs
* 2 tissues: Sh (shoot) and R (root)
* 2 time points for each tissue: 0H and 72H
* Each sample and all time points has 3 libraries
### Generate submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
cp HMT5vsHMT102_shortstack_1.sh NR130vsNS233_shortstack_1.sh
* adjust with vim
```
### Submit job
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results
sbatch NR130vsNS233_shortstack_1.sh
```
