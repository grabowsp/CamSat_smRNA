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



