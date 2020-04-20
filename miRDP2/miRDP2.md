# Steps for miRDP2 (miRDeep-P2) analysis

## Steps
* Get miRDP2
* Format fastq file into fasta file that has counts of repeated reads
  * I think fastx-toolkit can do this
  * needs to end in _xINTEGER
* Index genome and get ncRNA index (see manual)
* Run miRDP2 on test library

## Get miRDP2
### Setup environment
* need Bowtie and ViennaRNA packages
```
module load python/3.7-anaconda-2019.07
source activate miRDP2_env
```
### Download miRDP2
* /global/homes/g/grabowsp/tools/miRDP2

## Generate Index Files
### Bowtie index of genome
* looks like it was already build by ShortStack...
```
module load python/3.7-anaconda-2019.07
source activate miRDP2_env

bowtie-build -f /global/homes/g/grabowsp/data/CamSat/Cs_genome_v2.fasta \
/global/homes/g/grabowsp/data/CamSat/Cs_genome_v2.genome 
```
### Bowtie index the ncRNA_fam.fa file
```
cd /global/homes/g/grabowsp/tools/miRDP2

bowtie-build -f  ncRNA_rfam.fa ./1.1.4/scripts/index/rfam_index
bowtie-build -f  ncRNA_rfam.fa ./1.1.3/scripts/index/rfam_index
```

## Generate Collapsed fasta files
### Get fastx-toolkit
```
module load python/3.7-anaconda-2019.07
source activate fastx_toolkit_env
```
### Test with GGACY_1
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGACY_1

cat GGACY_1_100k.fasta | fastx_collapser -i - -o GGACY_1_100k.collapsed 

gunzip -c GGACY_1.prepped.fastq.gz | fastx_collapser -i - -o GGACY_1.collapsed

sed 's/-/_x/g' GGACY_1.collapsed > GGACY_1.collapse.reformat
sed 's/>/>read/g' GGACY_1.collapse.reformat.fa > \
GGACY_1.collapse.reformat2.fa
```

## Run miRDP2
### Test with GGACY_1
#### Generate script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRDP2_results
cp /global/cscratch1/sd/grabowsp/CamSat_smRNA/shortstack_results/GGACY_1_shortstack_test1.sh ./GGACY_1_miRDP2_test1.sh
```
#### Commands
```
LIB=GGACY_1

GENOMEFILE=/global/homes/g/grabowsp/data/CamSat/Cs_genome_v2.fasta
INDEX_PRE=/global/homes/g/grabowsp/data/CamSat/Cs_genome_v2.genome

IN_PARENT=/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/
OUT_PARENT=/global/cscratch1/sd/grabowsp/CamSat_smRNA/miRDP2_results

cd $IN_PARENT$LIB

/global/homes/g/grabowsp/tools/miRDP2/1.1.3/miRDP2-v1.1.3_pipeline.bash \
-g $GENOMEFILE -x $INDEX_PRE \
#-f $IN_PARENT$LIB'/'$LIB'.collapse.reformat2.fa' \
-f GGACY_1.collapse.reformat2.fa \
-R 2 \
-o $OUT_PARENT
```
#### Submit script
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/miRDP2_results
sbatch GGACY_1_miRDP2_test1.sh
```

