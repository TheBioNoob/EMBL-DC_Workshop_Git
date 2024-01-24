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
  



surveys %>% 
    mutate(weight_kg = weight/1000) %>%  #mention new column, what to we want with the previous column?
    View()    #makes intermediate table
  
surveys %>% 
  mutate(weight_kg = weight/1000, weight_lb = weight_kg * 2.2) %>%       # new column weight in kg, use values from new column in kg and multiplying to get new lb column
  head()

#remove the NA´s
surveys_weigh_conv <-  surveys %>% 
  filter(!is.na(weight)) %>%   # identify NAs and negate them
  mutate(weight_kg = weight/1000, weight_lb = weight_kg * 2.2) %>%       # new column weight in kg, use values from new column in kg and multiplying to get new lb column
  # head()   #option to see if it worked
  select(-weight) 
  #mutate makes new column by default
  #-weight removes additional columns not needed

#differences in weight between male and female by tidyverse functions, general R function possible too but not explored
#slit apply and combine paradigm -> spilt data intro groups -> apply analysis like mean function -> combine results in new table
surveys %>% 
  filter(!is.na(sex)) %>%   #remove na for sex
  group_by(sex) %>% 
  summarize(mean_weight = mean(weight, na.rm = T))   # new column mean_weight, mean of which column and remove NA
#newcolumn found in help section
#mean would expect numeric but you´re providing a group data.frame

surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% # exclude this shit
  group_by(sex, species_id) %>% #groups them
  summarize(mean_weight = mean(weight, na.rm = T)) %>% 
  print(n=15)   #or tail


surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight, na.rm = T), min_weight = min(weight))


#arrange data
surveys %>% 
  filter(!is.na(weight), !is.na(sex)) %>% 
  group_by(sex, species_id) %>% 
  summarize(mean_weight = mean(weight, na.rm = T), min_weight = min(weight)) %>%   #na.rm could be excluded here as it was done on top already but if it weren´t, it would be fine here
  arrange(min_weight)    # expects to mention the column it wants your to order by -> ascending order
  arrange(desc(min_weight) #or arrange(max_weight)
  
#summarize can be substituted with count
surveys_new <- surveys %>%    #do when table will be used for different aspects later on
  count(sex, species) %>%   #alternate way of counting observations in data, what we did in summarize and group by
  arrange(species, desc(n))


#Exercise 1:
#1
surveys %>% 
  count(plot_type)
#2
surveys %>% 
  select(hindfoot_length) %>% 
  group_by(species_id)
  summarize(mean_hfl = mean(hindfoot_length, na.rm = T), min_hfl_ = min(hindfoot_length, na.rm = T), max_hfl = max(hindfoot_length, na.rm = T)) %>% 
  n = n()
  
#solution
surveys %>% 
  filter(!is.na(hindfoot_length)) %>% 
  group_by(species_id) %>% 
  summarize(
    mean_hindfoot_length = mean(hindfoot_length), 
    min_hindfoot_length = min(hindfoot_length),
    max_hindfoot_length = max(hindfoot_length),
    n = n()
  ) %>% 
  View()

#3
surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(year) %>%   #all values from each year are kept together
  filter(weight == max(weight)) %>%   #keep rows where weight is equal to max weight, retains other columns and then selection of wante columns
  select(year, genus, species_id, weight) %>% 
  arrange(year) %>% 
  unique()
  View()
  
#convert table from long format to wide format
#row to column
#wide -> long
surveys_gw <- surveys %>% 
  filter(!is.na(weight)) %>% 
  group_by(plot_id, genus) %>% 
  summarize(mean_weight = mean(weight))
  
str(surveys_gw)

surveys_wide <- surveys_gw %>% 
  pivot_wider(names_from = genus, values_from = mean_weight, values_fill = 0) #turn and fill NA(missing data) as 0 #values fill is specific to NA, only for pivor #replace_na?
#if pivor is in a function then go back to point where it worked and behaves as it 
  

#long -> wide
#when plotting things ggplot wants data to be in long format, conversion is important and useful
#key is repeated for each of the plot id and value is beside that!
surveys_long <- surveys_wide %>% 
  pivot_longer(names_to = "genus", values_to = "mean_weight", cols = -plot_id )    #"" bc name of column, what to use, plod id kept and what is to be transferred

str(surveys_long)


#Exercise 1:
#1
surveys_new <- surveys %>% 
  pivot_longer(names_to = "measurement", values_to = "value", cols = c(hindfoot_length, weight)) %>%
  View()

#2
surveys_new %>% 
  group_by(year, measurement, plot_id) %>% 
  summarize(mean_value = mean(value, na.rm = T)) %>%
  pivot_wider(names_from = measurement, values_from = mean_value)
  
  

#Export the Data
#create a table
surveys_complete <- surveys %>% 
  filter(!is.na(weight), 
         !is.na(hindfoot_length),
         !is.na(sex))

write_csv(surveys_complete, file = "surveys_complete.csv")    #name of the table, name of the file we want to call it
#store it in other place: write_csv(surveys_complete, file = "data_raw/surveys_complete.csv") #right click enables you to find path with clicking but typing is better and you can always check in your directory
#there is a package that reads excel files
  
  
  
  
