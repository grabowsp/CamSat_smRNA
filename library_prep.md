# CamSat smRNA Library Prep

## Steps
1. Make file with library names
2. Prepare directory
3. Generate lib.config file
4. Make sure included libraries did not FAIL the QC steps
3. Run prepper
* use CamSat_snp_calling as template for this

## Prepare Directory for for libarary prepping
### Overview
* Directory on NERSC:
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps`
* Use Chris's prepper program to prepare the libraries for SNP calling
  * Info about prepper found in shared Google Doc
    * `https://docs.google.com/document/d/1ISRXR1s6WHnNDBQSN0eTu1-11gajfdHRouUMX03Ev3Y/edit`
* Requires setting up many subdirectories
  * Ex: CONFIG, linkerSeq, contaminant, directories with each library code...
  * Info found in GoogleDoc
### Generate Subdirectories
* Generate necessary subdirectories and copy files to `linkerSeq` directory
```
bash
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
mkdir CONFIG
mkdir contaminant
mkdir linkerSeq
cp /global/dna/projectdirs/plant/geneAtlas/HAGSC_TOOLS/PREP_TESTING/linkerSeq/* ./linkerSeq
for i in `cat ../Cs_smRNA_libs.txt`; do mkdir ./$i; done
```

## Generate lib.config file
### Overview
* Requires using the jamo module/function to get information about the \
status and location of the libraries at JGI
* Used `jamo info LIB_CODE` to get information about the libraries
  * Any 'PURGED' libraries had to be 'fetched' using \
`jamo fetch library LIB_CODE`
* Use `jamo report short_form library LIB_CODE` to get info about the \
libraries that could be put into the `lib.config` file
  * Need to include a `grep UNPROCESSED` term so that info about all \
libraries tied to a `LIB_CODE` are included in the prepping
### Get status of libraries
```
bash
module load jamo
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
for i in `cat ../Cs_smRNA_libs.txt`;
#do jamo info library $i >> smRNA_jamo_lib_info.txt; done
do jamo info library $i >> smRNA_jamo_lib_info_042020.txt; done
```
### Fetch any purged libraries
* Use `grep PURGED smRNA_jamo_lib_info.txt` to get `LIB_CODE` of any \
libraries that were not in the main storage of JGI
* Use `jamo fetch library LIB_CODE` for those libraries
* ex:
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
#for i in `grep PURGED smRNA_jamo_lib_info.txt`;
for i in `grep PURGED smRNA_jamo_lib_info_042020.txt`;
do jamo fetch library $i; done
```
* Need to wait until `jamo info library LIB_CODE` shows a state of \
`BACKUP_COMPLETE` or `RESTORED` before going on to next step
```
for i in `cat ../Cs_smRNA_libs.txt`;
do jamo info library $i; done
```
### Generate lib.config file
```
bash
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
for i in `cat smRNA_jamo_lib_info.txt`;
do jamo report short_form library $i | grep UNPROCESSED >> ./CONFIG/lib.config;
done
```
### Check if libraries have more than one fastq file
```
lib_config_file <-'/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/CONFIG/lib.config'
lib_config <- read.table(lib_config_file, header = F, sep = '\t',
  stringsAsFactors = F)

sum(duplicated(lib_config[,1]))
# 7
lib_config[duplicated(lib_config[,1]), 1]
[1] "GGACY" "GGAGB" "GGAGC" "GGAGG" "GGAGH" "GGAGN" "GGAGU"
```
### Adjust lib.config and generate Directories for the duplicated libraries
* Need to adjust the `LIB_CODE` for the duplicated libraries in the \
lib.config file
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
for LIB in GGACY GGAGB GGAGC GGAGG GGAGH GGAGN GGAGU;
do mkdir $LIB'_1';
done
```
* adjust lib.config to add '_1' to the duplicated library lines

## Check that libraries pass QC
### Overview
* use jamo to see if any `LIB_CODE`s are linked to fastq files that failed \
the JGI QC test
* compare the Failed QC test files to those in lib.config
### Looked for Failed runs
* need to load the jamo module
```
module load jamo
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
for i in `cat ../Cs_smRNA_libs.txt`;
do jamo report short_form library $i | grep 'passedQC=F' >> qc_F_report.txt;
echo $i; done
```
* the file is empty, so none of the libraries failed QC
### Check if failed runs are included in lib.config
* Did not have to run this
```
#qc_report_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/qc_F_report.txt'
qc_report <- read.table(qc_report_file, header = F, sep = ' ',
  stringsAsFactors = F)
#
#lib_config_file <- '/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/CONFIG/lib.config'
lib_config <- read.table(lib_config_file, header = F, sep = '\t',
  stringsAsFactors = F)
#
f_info <- strsplit(qc_report[,4], split = '/')
f_files <- unlist(lapply(f_info, function(x) x[[length(x)]]))
#
f_in_lc_list <- sapply(f_files, function(x) grep(x, lib_config[,6], fixed = T))
f_in_lc_length <- unlist(lapply(f_in_lc_list, length))
f_in_lc <- which(f_in_lc_length > 0)
length(f_in_lc) > 0
# [1] FALSE
```
* no overlap between QC failure and files in lib.config

## Submit prepping jobs
### Overview
* Generated sub-lists of 45 `LIB_CODE`s because launching the prepper submits \
many jobs for each `LIB_CODE`, and Chris recommended prepping 45 libraries \
at a time if use '-q 100' flag to stay withing the rules of NERSC
### Generate sub-lists
* Generate sub-lists of 45 `LIB_CODE` entries for submitting jobs
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA
split -l 45 -d Cs_smRNA_libs.txt Cs_smRNA_small_list_
```
### Copied and altered python script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps

cp /global/dna/projectdirs/plant/geneAtlas/HAGSC_TOOLS/PREP_TESTING/splittingOPP.py ./smRNA_adjusted_splittingOPP.py
```
### Submit jobs
* have submitted:
```
bash
module load python
source activate /global/dna/projectdirs/plant/geneAtlas/HAGSC_TOOLS/ANACONDA_ENVS/PREP_ENV/

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
cd ./GGACY_1
#python3 /global/dna/projectdirs/plant/geneAtlas/HAGSC_TOOLS/PREP_TESTING/splittingOPP.py \
python3 /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/smRNA_adjusted_splittingOPP.py \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps GGACY_1 -q 100
```
# worked, but does not submit jobs to cluster, only runs interactively
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps
for i in GGAGB_1 GGAGC_1 GGAGG_1 GGAGH_1 GGAGN_1 GGAGU_1;
  do
  cd ./$i;
  python3 /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/smRNA_adjusted_splittingOPP.py \
  /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps $i -q 100;
  cd ..;
  sleep 5s;
  done
```
### Generate submit job to process rest of libraries
* will prep each library in succession
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps

cp /global/cscratch1/sd/grabowsp/sg_ploidy/MNP_counts/pos_20/full_MNP_pos_depth20_00.sh ./prep_CS_smRNA_submit.sh

# adjust with vim

sbatch prep_CS_smRNA_submit.sh
```




