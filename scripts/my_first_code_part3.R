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

#Continuation from Tuesday - Factors --- 24.01.24

#Tools -> general -> Never (Workspace)
#set it to never and rerun the code in the beginning

str(surveys)
#several columns are integers and other ar characters but some of them contain sth that is a category rather than character (e.g. species)
#difference -> content can get limited number of values and not any range of values
#special category for handling such categorical data
#once a factor is created it can only contain a predetermined set of values (namely levels) -> not long string saved and occupying space in bits and bites -> one word is stored as 1/2..-> more efficient speed or space wise
#important for conversion and level 
surveys$sex <-  factor(surveys$sex)
#can be done on data.frame in a slightly different way but also as a vector output
#can be done on independant vector, too factor e.g. (c(1,2,1,2,2,1))
#unique values -> alphabetic sort -> levels ordered alphabetically -> F = 1, M = 2
#reassignment of levels can be forced

levels(surveys$sex) #shos levels and order is returned in waay in which they have been saved
nlevels(surveys$sex) #number of levels

#force a factor to take levels in prefered way:
sex <-  factor(c("male", "female", "female", "male"))
#putting sex in to console gives us num ebr of levels and quality
sex <- factor(sex, levels = c("male", "female")) # qualities not changed but order


#Exercise 1:
taxa <-  surveys$taxa <- factor(surveys$taxa)
levels(taxa)
nlevels(taxa)
sum(surveys$taxa == "Rabbit")
summary(surveys$taxa)
#gives number of animals

genus <-  surveys$genus <- factor(surveys$genus)
levels(genus)
nlevels(genus)


#convert factors to characters
as.character(sex)

year_fct <- factor(c(1990, 1983, 1977, 1997))
#levels have been sortes as ordered as numbers
as.numeric(year_fct) # result is shit bc chronological order is given, R has created levels for vector when it was asked to be made a factor 

#quick and dirty way to transform numbers - double transformation 
as.numeric(as.character(year_fct))
# not clean bc it does a double conversion and not what we know abt factors and that factors are encoded as levels

#better and rigt way
as.numeric(levels(year_fct))[year_fct]
#obtaining levels with middle command, then converting the levels as a numeric => sorted version of numeric
#square bracket year factor contains numbers that coorespond to levels, initial vector in the order that is wanted
#assigning the original levels the numbers! nr 1 is 1977, number 2 is 1983, number 3 is 1990... but the order is different
#indexing is associated with transformation!
#levels are always stored as character bc it is the most generic as seen on Tuesday

#rename factors
plot(surveys$sex)
snummary(surveys$sex) # NA not plotted, how do we gat that into the plot?
sex <- surveys$sex
levels(sex) #default for F and M, now add another
sex <- addNA(sex)
levels(sex)
#now modify NA to other name bc we want it to be "undefined"
levels(sex)[3] <- "undetermined"
#levels are redone and level 3 of all levels which is NA is changed to 
#to plot sth it does not need to be factor but its good for count estimations

#Exercise 2:
levels(sex)[1:2] <- c("female", "male")
plot(sex)
#changing names for f and m

#reorder sexes 
sex <- factor(sex, levels = c("undetermined", "female", "male"))







