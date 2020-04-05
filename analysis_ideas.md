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

```


