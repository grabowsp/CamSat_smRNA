# Script for generating a smRNA counts matrix formated for DE analysis from the 
#   Counts.txt output from shortstack

# Arguments:
# [1]: (character) filename of the counts file to be used by DESeq2
# [2]: (character) filename of the metadata file
# [3]: (character) name of the sample comparison - for the output filename
# [4]: (number) the width, in inches, for the heatmap
# [5]: (number) the height, in inches, for the heatmap
########

args = commandArgs(trailingOnly = TRUE)

### INPUT FILES ###
counts_file <- args[1]
counts_data <- read.table(counts_file, header = F, stringsAsFactors = F,
  sep = '\t')

info_file <- args[2]
#info_file <- paste('/global/cscratch1/sd/grabowsp/CamSat_smRNA/',
#  'smRNA_Library_Info_Sample_Info.tsv', sep = '')
samp_info <- read.table(info_file, header = T, stringsAsFactors = F, sep = '\t')

### SET OUTPUTS ###
comp_name <- args[3]

fig_out <- paste(comp_name, '_smRNA_cor_heatmap.pdf', sep = '')

hm_width <- as.numeric(args[4])
hm_height <- as.numeric(args[5])

### LOAD PACKAGES ###
library(reshape2)
library(ggplot2)

###################
# process the inputted count_data - the Cluster_ and non-positioned smRNA
#   entries are slightly different and need to be processed accordingly

info_0 <- samp_info[which(samp_info$SampleName %in% colnames(counts_data)),]
info_1 <- info_0[order(info_0$Time), c(1:3)]
info_2 <- info_1[order(info_1$Treatment), ]

full_counts_1 <- counts_data[, info_2$SampleName]

descr_names <- paste(info_2$Treatment, info_2$Time, info_2$SampleName, 
  sep = '_')

colnames(full_counts_1) <- descr_names

count_cor <- cor(x = full_counts_1, method = 'pearson')
count_cor_round <- round(count_cor, digits = 2)
count_cor_melt <- melt(count_cor_round)

gg_full_heat <- ggplot(data = count_cor_melt, aes(x=Var1, y = Var2,
  fill = value)) +
  geom_tile() +
  scale_fill_gradient2(low = 'red', high = 'darkgreen', mid = 'white',
    midpoint = 0.5, limit = c(0,1), space = 'Lab',
    name = 'Pearson\nCorrelation') +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, vjust = 1, size = 14,
    hjust = 1), axis.text.y = element_text(size = 14)) +
  coord_fixed() +
  geom_text(aes(Var2, Var1, label = value), color = 'black', size = 6)

pdf(fig_out, width = hm_width, height = hm_height)
gg_full_heat
dev.off()

quit(save = 'no')

