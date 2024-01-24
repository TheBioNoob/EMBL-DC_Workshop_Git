#ggplot1 was olf and problematic and not available in repositories anymore, so ggplot2
#define aesthetics and draw by adding layers

plt <- ggplot(
  data = surveys_complete,
  mapping = aes(x = weight, y = hindfoot_length)
)
#aes=aesthetics, x maps column of imput data frame to x, then y
str(plt) #at the top it calls it a ggplot object, is very complicated
#layer is missing calles geometry -> how to depict data?

plt +    #+ bc layers
  geom_point() #scatter plot

plt + 
  geom_point() +
  ggtitle("My first plot!")

#environment ist saveable as an R document, if you clean it wrong, you can recapitulate and repoen it
#rm lets you clean single variables
rm(my_list)

surveys_complete <- read_csv("surveys_complete.csv")
#bc we were in the folder already -> git -> id didn´t need the previous path
#R doesn´t like the \ but it likes the /

#1.define ggf plot object
#plt <-  ggplot(data=<data.frame>, mapping = <aesthetics>)
#x aesthetics
#y aesthetics
#color aesthetis
#shape aesthetics
#----
#2. add geometr ylaxer(s)
#geometry functions have predictable names
#geom_{point, line , bar histogram, violin, hex, ...}

plt <- ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point()

plt+
  ggtitle("Weights vs hindfoot length")

install.packages("hexbin")
library(hexbin)
#provides new geometry - geom:hex - hexagonal heatmap -> scatterplot and counting how many points fall in each bin?
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_hex()

ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1) #control the point transparency -> densities are shown
  photon = alpha/transparency, RGB is color
?geom_point

  #add color
ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, color = "blue")

#easier to write:
ggplot(
  data = surveys_complete, 
  mapping = aes(
    x = weight,
    y = hindfoot_length,
    color = species_id
  ) 
) +
  geom_point(alpha = 0.25) #applies to everything, entire plot for the plot is given, if something else were added it would be colored, too


ggplot(data = surveys_complete, mapping = aes(x = weight, y = hindfoot_length)) +
  geom_point(alpha = 0.1, aes(color = species_id)) # aesthetic applies only to point, only the aesthetics for the points

#Exercise: scatterplot (weight vs species_id colored by plot type)
ggplot(
  data = surveys_complete, 
  mapping = aes(
    x = species_id, 
    y = weight,
    color = plot_type)
  ) + 
  geom_point()
  




#boxplots
#w/ NA will be excluded but plot will succeed
ggplot(
  data = surveys_complete, 
  mapping = aes(
    x = species_id, 
    y = weight)
) + 
  geom_boxplot()
#limitation is bimodel distribution or weird distribution this plot doesn´t show us
#good middle ground to overlay both geometries to get a sense of how the single data points distribute
ggplot(
  data = surveys_complete, 
  mapping = aes(
    x = species_id, 
    y = weight)
) + 
  geom_boxplot() + 
  geom_jitter() #adding a little value for each x coordinate

#refine it further by setting point transparency
ggplot(
  data = surveys_complete, 
  mapping = aes(
    x = species_id, 
    y = weight)
) + 
  geom_boxplot() + 
  geom_jitter(alpha = 0.3, color = "salmon") 

#remove the boxplot in the background
ggplot(
  data = surveys_complete, 
  mapping = aes(
    x = species_id, 
    y = weight)
) + 
  geom_boxplot(outlier.shape = NA) 
  geom_jitter(alpha = 0.3, color = "salmon")
#box is 25%, rest is 75%
#what comes first, comes first
  ggplot(
    data = surveys_complete, 
    mapping = aes(
      x = species_id, 
      y = weight)
  ) + 
    geom_boxplot(outlier.shape = NA, fill = NA) 
  geom_jitter(alpha = 0.3, color = "salmon")#usually not more than 3 to max 4 overlayered
#indnentations (which he turned off) are to see, where you are
#crtl + shift + I -> aligns the code but not anything all people subscribe to
  
#Exercise: produce a violin plot of weight by species_id
?geom_violin
ggplot(
  data = surveys_complete,
  mapping = aes(
  x = species_id,
  y = weight)
) +
  geom_violin(color = "green", 
  ) #not pretty, change scale, in log!
#for annotation an p values you need another data!

#transform into log scale
ggplot(
  data = surveys_complete,
  mapping = aes(
    x = species_id,
    y = weight)
) +
  geom_violin() +
  scale_y_log10() +
  ylab("Weight (log10)")
  

#Exercise
#Boxplot + jittered scatterplot of hindfoot_length + species_id. Boxplot should be in front of the dots and filled with white.
ggplot(
  data = surveys_complete,
  mapping = aes(
    x = species_id,
    y = hindfoot_length)
) +
  geom_jitter (outlier.shape = NA) +
  geom_boxplot(alpha = 0.3, color = "firebrick") 
#decimal codes ("fffffff" decimal code for white) possible for colors or rbg(0-1 x 3 -> .3, .3, .3)
#colors
#"red", "green"
#rgb(red=0.3, green=o.3, blue=0.3)
# #dedede hexadecimal code


#color to be plotID (categorical)
ggplot(
  data = surveys_complete,
  mapping = aes(
    x = species_id,
    y = hindfoot_length)
) +
  geom_jitter (alpha = 0.3, aes(color = factor(plot_id))) + #rgb(.3,.3,3.)) +
  geom_boxplot(outlier.shape = NA) 
#numeric vector -> numeric column are interpreted as continuous variables and continuous gradient of color
#can force ggplot to take on a factor and categorical variable:


yearly_count <- surveys_complete %>% 
  count(year, genus)

ggplot(data = yearly_count, mapping = aes(x = year, y = n)) +
  geom_line()
#looks shitty, bc genera are all plotted together

#give each group a genus


yearly_count <- surveys_complete %>% 
  count(year, genus)

ggplot(data = yearly_count,
       mapping = aes(
         x = year, 
         y = n, 
         group = genus)) +  #not groupby, aesthetic function so this is a parameter and the other is a defined function
  geom_line()

#coloring by genus
yearly_count <- surveys_complete %>% 
  count(year, genus)

ggplot(
  data = yearly_count, 
  mapping = aes(
    x = year,
    y = n, 
    color = genus)) +  #not groupby, aesthetic function so this is a parameter and the other is a defined function
  geom_line()

#combine pipe with gg plot function
yearly_count <- surveys_complete %>% 
  ggplot(mapping = aes(x = year, y = n, color = genus)) +
  geom_line()
#OR
yearly_count_graph <- surveys_complete %>%
  count(year, genus) %>% 
  ggplot(mapping = aes(x = year, y = n, color = genus)) +
  geom_line()
#variable contains the plot

#separate all the lines in singles -> matrix plot generation for each genus
ggplot(
  data = yearly_count, 
  mapping = aes(
    x = year, 
    y = n)) +
  geom_line() +
  facet_wrap(facets = vars(genus))  #specity the facets
#lattice of plots
#scales are cmparable

#remake yearly_count
#separation by sex -> two lines per pannel
surveys_complete %>% 
  count(year, genus, sex) %>% 
  ggplot(
  mapping = aes(
    x = year, 
    y = n,
    color = sex)) +
  geom_line() +
  facet_wrap(facets = vars(genus))


#organize the plot to split the sexes and orgnize subplots into standardized way
#matrix of plots -> bigger and clearer plot and will make them comparable
surveys_complete %>% 
  count(year, genus, sex) %>% 
  ggplot(
    mapping = aes(
      x = year, 
      y = n,
      color = sex)) +
  geom_line() +
  facet_grid(           #controls a grid of columns
    rows = vars(sex),
    cols = vars(genus)
  )


surveys_complete %>% 
  count(year, genus, sex) %>% 
  ggplot(
    mapping = aes(
      x = year, 
      y = n,
      color = sex)) +
  geom_line() +
  facet_grid(           
    rows = vars(genus)
  ) #rows organized 

surveys_complete %>% 
  count(year, genus, sex) %>% 
  ggplot(
    mapping = aes(
      x = year, 
      y = n,
      color = sex)) +
  geom_line() +
  facet_grid(           
    cols = vars(genus)
  ) #columns organized



#customization - can become massive and extensive
plt <- surveys_complete %>% 
  count(year, genus, sex) %>% 
  ggplot(
    mapping = aes(
      x = year, 
      y = n,
      color = sex)) +
  geom_line() +
  facet_wrap(facets = vars(genus) #scales = "free"_y, free_x) +
  
  scale_color_manual(
  values = c("tomato", "dodgerblue"), 
  labels = c("female", "male"),
  name = "Sex") +
  xlab("Year of observation") +                                            #rename axis
  ylab("Number of individuals") +
  ggtitle("Observed genera over time")
  theme_bw(base_size = 14) +  #variation on the default theme and set base font size
  theme(
    legend.position = "bottom",                         #remove the legend with "none" after 
    aspect.ratio = 1,                                   #width = height but now axia are not readable anymore
    axis.text.x = element_text(
      angle = 45, 
      hjust = 1),  #rotate the angles     
    plot.title = element_text(hjust = 0.5),             # 0-1 and 0.5 is middle
    panel.grid = element_blank()                        #remove grid
  )
plt   #needs to be retyped to be executed
ggsave(filename="data/plot.pdf",
       plot = plt, 
       width = 20,
       height = 20)    #save current plot to disk
                      #saving is the same as exporting
                      #theme is a preset -> default bckgr = white, grids grey, etc.

#add text -> geom_text -> annotate genes
#gverate new column with genes he wants to label -> use column any only dots left that have a label

#be cautious when there are too many different axis -> it might not have been done with the same scale
#package for p values




