#read in files and assign them names
library(tidyverse)                                                   #packages unload when R Studio is closed, so reload each time you close-open
raw.cts <- read_csv("data_rnaseq/counts_raw.csv")
trans_cts <- read_csv("data_rnaseq/counts_transformed.csv")
sample_info <- read_csv("data_rnaseq/sample_info.csv")
test_result <- read.csv("data_rnaseq/test_result.csv")
#importdataset in environment -> csv is a textfile -> base uses read.csv/readr is part of tidyverse and imports with read_csv -> asks object it will be named
#is shitty when you have to import x amount of files and it does not write code in script and when you run the script from scratch and you have to redo it again which is shitty

#basic exploration of the data
#trans_cts -> genename vs counts
#transformed counts after preprocessing -> link to the lesson has more info on preprocessing and transformation

library(ggplot2)
#ggplot loves long data formats 
trans_cts_long <- trans_cts %>% 
  pivot_longer(names_to ="sample", values_to = "cts", cols = wt_0_r1:mut_180_r3) #cols = wt_0_1:wt_0_3 could be cols = - gene, too as we want to exclude gene or number of columns possible (column 2 to 120) but names are much more specific, esp when moving the tables around!
                                                                                 #no [] as only used for funtion calling
                                                                                 #R tells you column automatically though the %>%  as it knows where you´re working
                                                                                 #use %>% as much as possible: means I took xxx and did xxx with it and easy and nice to get the prompts

#histogram of counts according to sample
#but separation of wt and mut and timepoint necessary -> split the table and samples where they´re from
#file sample_info shows other info (strain name, minute) and is necessary or sample name separate into 3 parts


#combine info from two tables - join functions
#full join -> adding NAs to entrys that do not exist in either
#variants of the join function:
#inner join: only common items carried foward and no NA is kept
#left_join = define two tables and left table x is kept intact and is filled up with info from table y that can be found -> left table is focal table of interest and intact and whatever info there is for the rest
#right_join possible to
#cannot join >2 tables at once but step by step by addition and is more clear this way!

trans_cts_long <- full_join(trans_cts_long, sample_info, by = "sample")    #he overwrote ehat we did before, which you shouldn´t do, 3 variables now changes to 6
                                                                           #by = common denominator and only kept once bc it is used to merge

#make histogram
trans_cts_long %>% 
  ggplot(
    aes(x = cts)) +                           #define the axis
    geom_freqpoly()                           #frequency polygon

#add layers to histogram
trans_cts_long %>% 
  ggplot(aes(x = cts, colour = replicate)) +     #color by replicates
  geom_freqpoly(binwidth = 1)                     #width of plot changed to "zoom in"
                                                #bins -> 30 arbitrary bins made according to max/min data 
                                                #bin width refines range the histogram for counding -> 1 unit apart 1->2->3->4

#separate by strain and and timepoint with facet grid
trans_cts_long %>% 
  ggplot(aes(x = cts, colour = replicate)) +     #color by replicates
  geom_freqpoly(binwidth = 1)  +
  facet_grid(row = vars(strain), cols = vars(minute))
#analysis -> replicates seem reliable, some differences in replicates at time point 30 and 60 -> counts being off for certain genes -> small differences
#stron peak at 60´for wt -> just subtle differences with the naked eye

#repeat the steps for raw_counts
raw.cts_long <- raw.cts %>% 
  pivot_longer(names_to = "sample", values_to = "cts", cols = wt_0_r1:mut_180_r3)

raw.cts_long <- full_join(raw.cts_long, sample_info, by = "sample")

raw.cts_long %>% 
  ggplot(aes(x = cts, color = replicate)) +
  geom_freqpoly() +
  facet_grid(row = vars(strain), cols = vars(minute))

#modify the scale to log
raw.cts_long %>% 
  ggplot(aes(x = cts, color = replicate)) +
  geom_freqpoly() +
  facet_grid(row = vars(strain), cols = vars(minute)) +
  scale_x_log10
#1e+01 -> log transformation

#log10 directly at ggplot
raw.cts_long %>% 
  ggplot(aes(x = log10(cts), colou = replicate)) +
  geom_freqpoly() +
  facet_grid(rows = vars(strain), cols = vars(minute))
#warning massage -> removal of 465 rows containing non-finite values
#due to NA values = missingvalues an log of 0 = non-finite values = cannot be computed

log10(0)   #R changes this by deafult to -infinity and when 0 were found -> infinity cannot be plotted (says sth about zero)
#how to plot these counts at the zero in this plot? -> artificiall convert the zero to a 1 and a log transformation of 10(1)-> 0
log10(1)

#plot the 0s by changing 0 -> 1
raw.cts_long %>% 
  ggplot(aes(x = log10(cts+1), colour = replicate)) +
  geom_freqpoly(binwidth = 1) +
  facet_grid(rows = vars(strain), cols = vars(minute))
#bins are consistent but are not equal due to log
#plot Zoom makes it large!

#COMMENT:
#pr eprocessing - influence the data?
#are there other loops
#spiking


#instead of freqpolygon -> boxplot
raw.cts_long %>% 
  ggplot(aes(x = factor(minute), y = log10(cts+1), fill = strain)) +                      #x and y need to be defined!
                                                                                               #minute = number, boxplot needs facor tho and minute als numeric needs to be changes to factor
                                                                                              #fill instead of colour for boxplot
  geom_boxplot() +                                                                        #separate it by replicates 
  facet_grid(cols = vars(replicate))


#correlation between the data after looking at it rougly and in general respects
#scatterplot of trans file and correlation between sample at TO and T30  -> only one replicate -> wide format of line
trans_cts %>% 
  ggplot(aes(x = wt_0_r1, y = wt_30_r1)) +
  geom_point() +                                             # draw slope of line that shows correlation
  geom_abline(colour = "brown")


trans_cts %>% 
  ggplot(aes(x = wt_0_r1, y = wt_0_r2)) +
  geom_point() +                                             # draw slope of line that shows correlation
  geom_abline(colour = "brown")
#draws more compact and slope different from earlier plot


##look at the correlation of count data across all samples in our expeirment

trans_cts_corr <- trans_cts %>%                    #just columns with data - wide format and remove column with gene name!+ data order remaind the same and rows remain unchanged, but correlation may only be calculated for numeric data and thus gene needs to be removed
  #rm = removes object from environment so cannot be moved as column form table
  #option2 = [] -> not the best option bc you need the column number bc you may have combined other shit before and index might have changed, fixed to the index is shit
  #option3 = select
  select(-gene) %>% 
  cor(method = "spearman")                                      #normality shapiro will before but graphs earlier looked it
                                                                #baseRfunction -> creates a matrix and pairwise combination of all samples
                                                                #scatterplot as correlation matrix = plot matrix, PCA and heatmap!
install.packages("corrr")
library(corrr)    #for heatmaps

rplot(trans_cts_corr)
  theme(axis.text.x = element_text(angle = 45, hjust = 1))                #layer to modify the elements on the x-axis and their angle!
                                                                          #hjust = move it along the axis which angle would not do!, element text is the element we want to change with the funcion
  






















