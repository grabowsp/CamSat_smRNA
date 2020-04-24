# Information about libraries used for Analysis
* filter out low correlation libraries using 0.95 and correlation cutoff
  * Seems pretty liberal - could try 0.98 if want to be stricter

## MT5 vs 8171
### Highlights
* 6 of 18 libraries have low correlation
* Need to remove all 8171_8DAF libraries
* SO, can't use 8DAF in comparisons
### Raw data
* 3 time points: 8DAF, 10DAF, 12DAF
* 3 libraries/reps for each time point
### Libraries to keep
* 8171_8DAF: No libaries have high enough correlation
* 8171_10DAF: All 3
* 8171_12DAF: GNXGO, GNXGP
* MT5_8DAF: GNXGU, GNXGS
* MT5_10DAF: GNXGY, GNXGW
* MT5_12DAF: all 3
### Bad libraries
* GNXGN
  * is 8171_12DAF, but highest cor with other reps is 0.86
* GNXCZ
  * is 8171_8DAF but highest cor is 0.91 and one cor is 0.75
* GNXGA
  * is 8171_8DAF, highest cor is 0.91
* GNXGB
  * is 8171_8DAF, highest cor 0.88
* GNXGX
  * is MT5_10DAF, highest cor is 0.93
* GNXGT
  * is MT5_8DAF, highest cor is 0.89

## HMT5 vs HMT102
### Highlights
* 4 of 24 libraries have low correlation
* Can still use all time points
### Raw data
* 4 time points: 5DAF, 10DAF, 15DAF, 20DAF
* 3 libraries/reps for each time point
### Libraries to keep
* HMT102_5DAF: GNXCH, GNXCN
* HMT102_10DAF: GNXCP, GNXCS
* HMT102_15DAF: All 3 libraries
  * however, GNXCW is borderline: 0.95 and 0.93 with the reps
* HMT102_20DAF: GNXCX, GNXCY
* HMT5_5DAF: GNXBH, GNXBN
* HMT5_10DAF: all 3 libraries
* HMT5_15DAF: all 3 libraries
* HMT5_20DAF: all 3 libraries
### Bad libraries
* GNXCO
  * is HMT102_10DAF; highest cor is 0.82
* GGACY
  * is HMT102_20DAF; highest cor is 0.79
  * was a 2-library sample - maybe re-try using just one library?
* GNXCG
  * is HMT102_5DAF; highest cor is 0.94
* GNXBG
  * is HMT5_5DAF; highest cor is 0.93

## HMT5 vs HMT102 Flowers
### Highlights
* All 6 libraries show high correlation with replicates
### Raw Data
* 1 Time point
* 3 libraries/reps for each time point
### Libraries to Keep
* HMT5_flowers: all 3
* HMT102_Flowers: all 3
### Bad Libraries
* None

## HMT5 vs M3246
### Highlights
* 1 of 11 libraries has low correlation
* all time points can still be used
### Raw Data
* 2 time points: 5DAF, 15DAF
* 3 reps for each point except only 2 for M3246_15DAF
### Libraries to Keep
* HMT5_5DAF: GNXBH, HNXBN
* HMT5_15DAF: all 3 libraries
* M3246_5DAF: all 3 libraries
  * though GGAGG is borderline: 0.96 and 0.93
* M3246_15DAF: all 2 libraries
### Bad Libraries
* GNXBG
  * is HMT_5DAF; highest cor is 0.93

## PR33 vs PS69
### Highlights
* 5 of 21 with low correlation or no replicate
* Cannot use: PS69-Sh_72H; PS33-R_72H
* So, I cannot compare Sh_72H or R_72H
* I'm not sure there's much reason to do the comparison, then
### Raw Data
* 2 tissues: shoot and root
* 2 time points: 0H and 72H
* PS69-Sh_72H has only 1 rep
* PR33-R_72H has 2 reps
* Remaining time points have 3 reps
### Libraries to Keep
* PR33-R_0H: all 3 libraries
* PR33-R_72H: no libraries - low correlation between the 2 reps
* PR33-Sh_0H: all 3 libraries
* PR33-SH_72H: all 3 libraries
* PS69-R_0H: all 3 libraries
* PS69-R_72H: GNXAH; GNXAN
* PS69-Sh_0H: GNXHS; GNXHU
* PS69-Sh_72H: no libraries - only one rep
### Bad libraries
* GNXNZ
  * PR33-R_72H; 0.82 cor with rep
* GNWZY
  * PR33-R_72H; 0.82 cor with rep
* GNXAG
  * PS69-R_72H; 0.86 and 0.84 cor with other reps
* GNXHT
  * PS69-Sh_0H; 0.94 and 0.89 cor with other reps
* GNXAB
  * PS69-Sh_72H: no reps

## NR130 vs NS233
### Raw Data
* 2 tissues: shoot and root
* 2 time points: 0H and 72H
* All time points have 3 reps
### Libraries to Keep
* NR130-R_0H: all 3 libraries
* NR130-R_72H: all 3 libraries
* NR130-Sh_0H: all 3 libraries
* NR130-Sh_72H: all 3 libraries
* NS233-R_0H: all 3 libraries
* NS233-R_72H: all 3 libraries
* NS233-Sh_0H: all 3 libraries
  * GNXNP is borderline: 0.97 and 0.95
* NS233-Sh_72H: all 3 libraries 
### Bad libraries
* none


