#surveys data set will be reused

#loadpackage
library(tidyverse)
#if you don´t see message, then it has been previoiusly loaded
#tidyverse uses tibble, doesn´t convert characters to factors

#load data here (in my case surveys was already loaded)

str(surveys) #what are column attributes
#or view(surveys)

select(surveys, plot_id, species_id, weight)   # view certain columns, first mention table and then column topics for specification
#table was subset

select(surveys, -record_id, -species)  #exclude columns for specification

#select rows/filter data - first mention table, then column name, then year
filter(surveys, year == 1995  #several factors in one column with & and |
filter(surveys, year == 1995 & sex == F) or filter(surveys, year == 1995, sex == F)

#seuqntial selection and filtering until now, now let´s combine
surveys2 <- filter(surveys, weight < 5)
surveys_sml <- select(surveys2, species_id, sex, weight)

#nest functions
surveys_sml <- select(filter(surveys, weight < 5), species_id, sex, weight)  #first filter, then select, then store
#w/ mutiple functions its going to be messy

#pipe %>% (ctrl + shift + M) -> avoids nesting, which becomes messy
surveys %>% 
  filter(weight < 5) %>%               #refers to only weight, the rest remains the same #surveys is filtered with weight <5  #surveys only needs to be mentioned on top
  select(species_id, sex, weight)
#%in% filters differently
#2nd line is selection of columns, and filter is done in rows


#Exercise:

surveys %>% 
  filter(year < 1995) %>% 
  select(sex, weight, year) #good practice -> after %>% next line and space
  






















