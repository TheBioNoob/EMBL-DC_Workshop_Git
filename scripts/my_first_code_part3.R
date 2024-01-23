#data.frames

#load data set
download.file(url = "https://ndownloader.figshare.com/files/2292169", destfile = "data_raw/portal_data_joined.csv")
#destination file = festfile
#data was downloaded, now it needs to be imported into R as it isn´t here but on the PC

library(tidyverse)
#when confilct, then dplyr::filter... -> force R to use the function you want from package you want and that´s how you get rid of conflicts

#read and save the data
surveys <- read_csv("data_raw/portal_data_joined.csv")
#delimiter = how does it separate stuff? with comma or sth else?
#base function is read.csv -> tidyverse is not needed for import
#read.csv reads stuff in as data frame but does not give specific info (column types...) -> you´d need to extract this info
#_csv imports it as a table that is more explicit about data types
#read csv expects comma separated values
#read_csv2 -> comma separated values 2/ semicolon instead of comma
#read_table can be specified

head(surveys)
#shows head of file - top 6 rows by deafulit
#tibble = is a kind of data frame

view(surveys)
#data frame is a collection of vectors, wehere each column is a vector and all columns are of same length
#used to look at tables
#vector has its own rule (same type or it will be coerced to be)
#numers, character ad logical combination allowed in a data frame but each vector with only one type

str(surveys)

dim(surveys)
#pivor turns row -> column
nrow(surveys)
ncol(surveys)
tail(surveys)
head(surveys)

names(surveys)
#gives column name
colnames(surveys) #is the same as names
rownames(surveys)

summary(surveys)

#Indexing and subsetting of data.tables
surveys[1, 6]
#row, then column

#extract first row
surveys[1, ]
surveys[, 1]

#extract multiple values
surveys[c(1, 2, 3), c(5,6)]
surveys[c(1, 2, 3),]

surveys[1:3, 5:6]
surveys[, -1] # exclude first column

surveys[, "sex"]
surveys["sex"]
surveys$plot_id
surveys
# $ will return vector, [] data frame - is plotted differently

#Exercise 1:
surveys_200 <- surveys[200, ]
surveys[nrow(surveys), ]
nrow(surveys)/2 # hald the rows
surveys[nrow(surveys)/2, ]


#data.frame is a list, too
my_list <- list(names = c("Nora", "Lisanna", "Francesco"), money = c(1, 6, 3, 5, 8))
str(my_list)
my_list[[1]] # first element of list extracted
my_list$names
#list is a flexible container that can contain vectors but an element could be a data.frame itself
#breakes rule of data.frame as different lengts of vectors are presen
#data.farme is simple list, but list cannot be a data.frame

surveys[[3]]



