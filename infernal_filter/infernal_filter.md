# Steps for filtering with Infernal and Rfam database
* For finding and removing rRNA, tRNA, and snRNA's from the smRNA files

## Overview
### Current idea for workflow
* Generate fasta from fastq using `seqtk`
* run `cmscan` using the Rfam database and full fasta file
* Extract readnames from the Infernal .tblout file
* Remove reads from fastq file using BBTools `filterbyname.sh`

## Test with `GGACY_1`
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/infernal_filtering/GGACY_1

cp /global/cscratch1/sd/grabowsp/CamSat_smRNA/Cs_smRNA_preps/prep_CS_smRNA_submit.sh ./infern_GGACY_1.sh

sbatch infern_GGACY_1.sh
```

### Notes
* Finished ~200 million lines after 72 hrs
  * would need to split up the fasta files if want to run each library
* Identified 8670 reads out of ~200 million, so 0.1% of reads
  * is it worth running? Maybe, maybe not.
* Alternate strategy could be running DE hits against the RFam database
* Another strategy could be filtering the .bams against Rfam

