# Ideas for running smRNA analysis

## Want to see the profile of read lengths - Libraries are 1x76

## Steps, in my mind:
* Filter out tRNA, rRNA, snRNA, and snoRNAs
* Map to genome (Bowtie, I guess)
* Get counts of reads
* Use DESeq2 to find DE smRNAs
* ID potential miRNAs
  * ShortStack
  * miRDeep-P
  * Compare to miRBase
* Compare DE results to miRNA results
* BLAT results vs miRBase mature.fa file

## Using ShortStack
* get from conda
* test out with one library

## mirDeep-P2
* download code
* need to preprocess the reads - collapse repeated reads
  * use fastx-toolkit to get readname-readcount
* Run process

## General counts
* divide genome into 500bp chunks
* Run bowtie (or use results from ShortStack)
* Use a feature-counter to get readcounts in each window







## JGI uses ShortStack


## Using databases to find smRNA's
* `http://www.plantcell.org/content/31/2/315`
* Paper's approach:
  1. Only keep sequences 10-34 nt long
  2. Align to genome (they use Bowtie2)
  3. Use miRBase and tasiRNA database to find those types of smRNAs
  4. Use DESeq2 to assess differential expression

## Remove some smRNA types and then cluster base on normalized counts
* `https://www.frontiersin.org/articles/10.3389/fpls.2016.01459/full`
* Paper's approach
  1. Only keep reads 18-34 nt in length
  2. Map to reference (they use Bowtie)
  3. Exclude matches to rRNAs, tRNAs, snRNAs, and snoRNAs
  4. Then they do normalization and clustering, but I don't think that's the \
direction we should go in

## Another paper
* `https://bmcgenomics.biomedcentral.com/articles/10.1186/s12864-019-5947-z#Sec20`
* Paper's approach:
  1. Filter out tRNAs, rRNAs, snoRNAs, and snRNAs using Infernal program and \
the Rfam database
  2. Reads filtered using the Triticeae Repeat Sequence Database
    * we'd have to find something similar...
  3. Map to reference (they use Bowtie)
  3. Identify sRNA candidates with 2 programs: next steps
  4. miRDeep-P
  5. ShortStack
  6. DE analysis using DESeq2

## To remove rRNAs, etc
* can use BLAST/BLAT to compare seq reads to the RNA seqs
  * I worry this will take FOREVER
* Can use Infernal program for this, but need to figure out how


## What I'm going to try: Infernal
* Get tRNA sequences from Rfam database
* generate covariance model .cm file with cmbuild
* calibrate the model with cmcalibrate XXX.cm
  * test how long it will take with cmcalibrate --forecast XXX.cm
* Search one of the prepped libraries using cmsearch


* I downloaded the tRNA seed alignement file from Rfam
  * searched Rfam for tRNA
  * clicked on "Alignmen" on left
  * downloaded file in Stockholm format

```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering
cmbuild tRNA.cm tRNA_seed_alignment_RF00005.stockholm.txt
cmcalibrate --forecast tRNA.cm
cmcalibrate tRNA.cm
```

* Alternatively
```
module load python/3.7-anaconda-2019.07
source activate infernal_rfam

cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering
wget ftp://ftp.ebi.ac.uk/pub/databases/Rfam/14.1/Rfam.cm.gz
gunzip Rfam.cm.gz
cmpress Rfam.cm

# continue with Userguide pg. 27 and 28

# look at prepped file
# 

# convert fastq to fasta
module load python/3.7-anaconda-2019.07
source activate seqtk_env
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGACY_1
gunzip -c GGACY_1.prepped.fastq.gz | head -4000 | seqtk seq -A - > \
GGACY_1_short.fasta 

gunzip -c GGACY_1.prepped.fastq.gz | seqtk seq -A - > \
GGACY_1.fasta

source activate infernal_rfam
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering
cmscan --rfam --cut_ga --nohmmonly --tblout GGACY_1_short.tblout --fmt 2 \
--clanin Rfam.14.1.clanin Rfam.cm \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGACY_1/GGACY_1_short.fasta \
> GGACY_1_short.cmscan

cmscan --rfam --cut_ga --nohmmonly --tblout GGACY_1_100k.tblout --fmt 2 \
--clanin Rfam.14.1.clanin Rfam.cm \
/global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/GGACY_1/GGACY_1_100k.fasta \
> GGACY_1_100k.cmscan

* ways to make the output smaller:
--textw 20
* this makes all lines only 20 characters long - essentially, the output is 
   unusable, but I don't think I'll use the  
--noali
* omits the alignement section - very vew of the reads are aligning to this
  list, so may not make a big difference
```

```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering

grep rRNA GGACY_1_100k.tblout > GGACY_1_100k.rRNA
grep tRNA GGACY_1_100k.tblout > GGACY_1_100k.tRNA
grep nucleolar GGACY_1_100k.tblout > GGACY_1_100k.snoRNA

cat GGACY_1_100k.rRNA GGACY_1_100k.tRNA GGACY_1_100k.snoRNA > \
GGACY_1_100k.comboRNA

# the formatting is goofy on the output, so can't use "cut" to get the read
#   names; can try it in R, but need to figure out what kind of delimiter to use


/global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering/GGACY_1_100k.comboRNA
```
