#Exploratory analysis of transcriptomics data in R
#Hugo Tavares - Cambridge concipated the course

#2 yeast strains (WT vs Mut) -> Osmotic shock in 1M Sorbitol -> Time series sampling -> 3 replicates for each timepoints
#reference genomes for diff strains -> which one do we use? B6N?
#pre processing was already done


# Create a "data" directory
dir.create("data_rnaseq")                                 #define the name of folder

# Download the data provided by your collaborator
# using a for loop to automate this step
for(i in c("counts_raw.csv", "counts_transformed.csv", "sample_info.csv", "test_result.csv")){                   
  download.file(
    url = paste0("https://github.com/tavareshugo/data-carpentry-rnaseq/blob/master/data/", i, "?raw=true"),
    destfile = paste0("data_rnaseq/", i)
  )
}
#download 4 files from one github repository, name of the file changes, instead of changing name each time and wirting it 4 times -> reiteration
#for loop
#letter and each time the loop in the {} runs i is substituted by the items in c(), i is in the code - letter doesn´t matter, i is an object, so not written in quotes
#for reproducibility it is better t ohave file names in script

