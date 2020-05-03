# Commands used for packaging files to send to Chaofu

## Files
* tar.gz of the smRNA DE lists
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists/smRNA_DE_lists_v1.0.tar.gz`
* tar.gz of miRNA database hits
  * `/global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results/smRNA_miRNA_db_hits.tar.gz`

## Make DE list .tar.gz
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/combo_DE_lists
tar -czvf smRNA_DE_lists_v1.0.tar.gz *_v1.0.txt
```

## Make BLAT db hit .tar.gz
```
cd /global/cscratch1/sd/grabowsp/CamSat_smRNA/miR_blat_results
tar -czvf smRNA_miRNA_db_hits.tar.gz *DE_combo_miRNA_db_hits.txt
```

