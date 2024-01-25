#read in files and assign them names
library(tidyverse)                                                   #packages unload when R Studio is closed, so reload each time you close-open
raw.cts <- read_csv("data_rnaseq/counts_raw.csv")
trans_cts <- read_csv("data_rnaseq/counts_transformed.csv")
sample_info <- read_csv("data_rnaseq/sample_info.csv")
test_result <- read.csv("data_rnaseq/test_result.csv")






#preprocessing
#are there other loops
#what does ?raw mean?
#how to modifygit folder?