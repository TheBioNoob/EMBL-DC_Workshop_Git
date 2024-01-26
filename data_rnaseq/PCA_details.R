##PCA

#PCA is apparently a variance analyiss
#variable loadings, eigenvalue, eigenfactor
#dimensionality reduction technique
#large colelction of genes -> each gene is a dimnesion of data and therefore there will be many dimensions in studies
#PCA identifies the biggest contribution to the experimentsl result, which is described in the variance -> in a cerain gene and how much of that gene contributes to the variation

#setosa.io = PSA
#Eigenvectors are searched that best align with the variance
#number of PCA is = variance, first PC has the most and lowest explains nothing
#genes in 3 samples of explample here
#which value pulls away from the rest enough to be relevant to biological process
#contribution of a gene to a certain component, which in our case is sample -> gelps in ranking genes!

#funciton is not part of tidyverse and we need to convert the data to matrix format and tranpose the matrix
#matrix one column that is numbers and logicals -> only one type possible (numerical) -> have row an column names, tidyverse does not do well with matrix tho

pca_matrix <- trans_cts %>% 
  column_to_rownames("gene") %>%               #what name is to go where?
  as.matrix() %>%             
  t()                                         #transpose the matrix

sample_pca <- prcomp(pca_matrix)  #stats package - built in function and does not have to be laoded
  class(sample_pca)
  str(sample_pca)
  ?prcomp
  summary(sample_pca) #components are ordered from the ones that explain most to least variance -> proportion of variance should sum to 1 (100%) if the method is correct
  #missing data -> handle NA before you handle the dataas PCA does not contain it, add residual count adds +1 -> risks bc if counts are very low, then +1can have major impact and skew the interpretation fo the results
  #fn+f1 -> opens help page 
  
  
#similar to data frame but has numeric character
#work in rows, that´s why we did the t switch
pca_matrix[1:10, 1:5]                         #2 axis is taken
as_tibble(pca_matrix, rownames= "sample")                         #sample name is lost
                                              #to keep the identifiers = rownames
#eigenvalues
#calculation by squaring std dev
pc_eigenvalues <- sample_pca$sdev^2                                  #$ can also be used to access sublists or lists
                                                                    #values -> pc_eigenvalue = numeric (empty) 
#use data to create a tibble out of it
#there is different ways to to this
pc_eigenvalues <- tibble(PC = factor(1:length(pc_eigenvalues)),                        #creating a tibble by hand by specifying what the row and column etc is -> do it till the end (we have 36)
                  variance = pc_eigenvalues) %>% 
  mutate(pct = variance/sum(variance)*100) %>% 
  mutate(pct_cum = cumsum(pct))
  
#do the plotting, pareto_plot/chart  (cumulative line plot and bar plot -> 2 layers min, here 3)
pc_eigenvalues %>% 
  ggplot(aes(x = PC)) +
  geom_col(aes(y = pct)) +
  geom_line(aes(y = pct_cum, group = 1)) +  #group = overlap
  geom_point(aes(y = pct_cum)) +
  geom_hline(yintercept = 90) +                                                 #intersection tells us where to stop -> which components explain >90% of cavariance an which genes contibute the most to that
   labs(x = "Principal component", y = "Fraction variance explained")
#36 PC and each bar is a component and axis is how much of the data is explained by the component and are ordered from the one that explains the most variance and the least variacne on the right
#upper line is the same data but just represented in a cumulative way -> added on top op one another to 100%
#convenience functions and shortcuts exist for this
#for downstream analysis more componente and you want vairables that want >90% of the data -> what is the other stuff you want to use for further analysis?
#how much does a component explain -> if pc 1 >80% or only 15% makes a huge difference 
#pc eigenvalue = pc = given different names


##visualize the PC
pc_scores <- sample_pca$x %>%     #instead of sdev like above; needs to be done separately bc it can´t be done directly from the data.frame or a whole table
 as_tibble(rownames="sample")          #pca reduces the degree of freedom -> new coordinate for each point -> lassic vs tidyverse modern R
 
pc_scores %>% 
  ggplot(aes(x = PC1, y = PC2)) +
  geom_point()                                         #first two dimensions plot in x-y scale -> man more components to his, but only these two are looked at
                                                      #variaance in the PC space
                                                      #form this pattern alone we seen the grouping and we have no idea what the points are
 
pc_scores %>% 
  full_join(sample_info, by = "sample") %>% 
  ggplot(aes(x = PC1, y = PC2, 
             color = factor(minute),              #time is a categorical variable so we use factor to keep it that way 
             shape = strain)) +
  geom_point()
#time > gt factors in, lower time points give results
#spreading of the dots is too unspecific in this case
#scale of PC does not reflect on how much of the variance it explains

#a few steps were skipped

pc_loadings <- sample_pca$rotation %>% 
  as_tibble(rownames="gene")

top_genes <- sample_pca$rotation %>% 
  as_tibble(rownames = "gene") %>% 
  select(gene, PC1, PC2) %>% 
  pivot_longer(matches("PC"), names_to = "PC", values_to = "loading") %>% #rearrange the structure with matches
  group_by(PC) %>% 
  arrange(desc(abs(loading))) %>% 
  slice(1:10) %>%                           #top 10 genes
  pull(gene) %>%
  unique()
#pick values from top genes
top_loadings <- pc_loadings %>% 
  filter(gene %in%  top_genes)

#visualize
ggplot(data = top_loadings)+
  geom_segment(aes(x = 0, y = 0, xend = PC1, yend = PC2),                    #draws lines 
               arrow = arrow(length = unit(0.1, "in")),                        
               color="brown") +
  geom_text(aes(x = PC1, y = PC2, label = gene),                             #draws arrow tips
            nudge_y = 0.05, size = 3) +
  scale_x_continuous(expand = c(0.02, 0.02))                                #the longer the vector, the more does the gene contribute to the PC
  #no inference from PCA possible -> good as first analysis but unclear what exactly a PC is; good pointer into a direction 
  #multidimensional data is impossible to visualize -> 4dimensions are the max and therefore PCA is some form of seeing what is there, even if it´s difficult visually
  

  
  
  
##Friday
#complex pannels and visualization - one call patchwork!
#source button on top executes everything in one go
#r studio understands whole constructions 
#shift lines with one another alt+up/down key
#select with shift + up/ton arrows
#do noat save stuff in environment -> cleaning it is good practice and if your made a mistake, it is only affected by the code you currently have and not anything else


#store result of plotting in a variable
loadings_plot <- ggplot(data = top_loadings)+
  geom_segment(aes(x = 0, y = 0, xend = PC1, yend = PC2),                    #draws lines 
               arrow = arrow(length = unit(0.1, "in")),                        
               color="brown") +
  geom_text(aes(x = PC1, y = PC2, label = gene),                             #draws arrow tips
            nudge_y = 0.05, size = 3) +
  scale_x_continuous(expand = c(0.02, 0.02))   #the longer the vector, the more does the gene contribute to the PC
#if stored in a variable -> plot will not be displayed in plots

#join two plots - grab previous plots 
pca_plot <- pc_scores %>% 
  full_join(sample_info, by = "sample") %>% 
  ggplot(aes(x = PC1, y = PC2, 
             color = factor(minute),              #time is a categorical variable so we use factor to keep it that way 
             shape = strain)) +
  geom_point()

#combine them with a new library
library(patchwork)
(pca_plot | loadings_plot) # plots are positoned side by side
(pca_plot - loadings_plot) #does the same
(pca_plot / loadings_plot) #one on top, the other below like in a division
(pca_plot |pca_plot | pca_plot)/ loadings_plot #let´s say PC1/PC2, PC2/3 and PC3/4 -> display of first theree components in one fighure doing one figure
(pca_plot |pca_plot | pca_plot)/ loadings_plot +
  plot_annotation((tag_levels = "A")) # this is gg plot and therefore used the same with a + and same syntax



#shortcuts to transforming data in tibble etc
library(ggfortify)

autoplot(sample_pca) -> percentage of variance is adde on the axis

#strain vs mutant and different symbol extract()
 autoplot(sample_pca, data = sample_info, 
          colour="minute", shape = "strain") 
 
 library(broom)
 tidy(sample_pca, matrix = "eigenvalues")     #forcats as part of tidyverse
 tidy(sample_pca, matrix = "loadings")        #how to create a funtion? 
 #tsne and umaps 
 
 
 
 
 
 ##Francesco continuation
 autoplot(sample_pca, data = sample_info %>%  mutate(minute = as.factor(minute)),
          colour="minute", 
          shape = "strain") 
 
 ##visualizing DEA (differential expression results) test result table
test_results <- read_csv("data_rnaseq/test_result.csv")
test_results
#results of deseq are taken here
#gene column -> gene name
#baseMean column -> normalized expression level of a gene
#log2 FolgChange column -> amount of change betweens 2 conditions 
#lfsCE -> standard error associated to log2FolgChange value
#stat column -> statistics value computed as lof2FolgChange over lfcSE and compared to the standard normal distribution
#pvalue -> integer of the are udner the cuve computed from this statistics to infinity, pävalue associated with the change
#padj value -> p value corrected for multiple hypothesis testing -> needs to be done as we ae working with 30k genes 
#fdr correction - falase pos aka 1st error 
#comparison column = non-standard column and here for this particular expample and tells us which timepoint we are working with = comparison group 
#deseq -> normalized data and other table we are currently looking at alos gotten (1. normalization and model fitting, then calling another fucntion "results", thtat splitts the table and spmute the pvalue and log2FoldChange -> output of multiple runs of this is the test_results table)

#one way to plot the data -> MA plot (has a funny story coming from the microarray era)
#base mean against log2fold change x and y
#generate an MA plot (base mean vs log2FC), organize panels by comparison (time point). Hint: consider log-transformation baseMean -> ggmaplot is in fortify but you can go it with a general ggplot, too
ggplot(data = test_results)+
  geom_point(aes(x = baseMean, y = log2FoldChange)) +
  geom_grid(aes(time)) #my try

#solution
test_results %>% 
  ggplot(aes(x = log10(baseMean), y = log2FoldChange)) +
  geom_point(aes(alpha = 0.1)) +
  facet_wrap(facet = vars(comparison))   #or facet_grid

#defining the genes that respond to treatment -> p value
test_results %>% 
  mutate(sig = ifelse(padj < 0.01, log2FoldChange, NA)) %>%             #ifelse = 3 argument - test, if... a is valid, then do ..., if not, do ....
  ggplot(aes(x = log10(baseMean), y = log2FoldChange)) +                 #generates a new column called sig -> if yes, put it in the next column
  geom_point(alpha = 0.1) +
  geom_point(aes(y = sig), color = "tomato", size = 1) +
  facet_wrap(facets = vars(comparison))
#most tomato points at 30´
#MA plots usually have a cone shape and left is wider along y and become thinner along the x, bc genes with hifher base value change less - higher amount of reads necessary to push them away from the base line
#add a horizontal line, to know the base value
ma_plot <- test_results %>% 
  mutate(sig = ifelse(padj < 0.01, log2FoldChange, NA)) %>%             #ifelse = 3 argument - test, if... a is valid, then do ..., if not, do ....
  ggplot(aes(x = log10(baseMean), y = log2FoldChange)) +                 #generates a new column called sig -> if yes, put it in the next column
  geom_point(alpha = 0.1) +
  geom_point(aes(y = sig), color = "tomato", size = 1) +
  facet_wrap(facets = vars(comparison)) +
  geom_hline(yintercept = 0, color = "dodgerblue")
#value threshold in volcano plot is a line, here it is a curved line and shows expression level which the volcano plot hides bc expression levels are diregarded

#largest number of diff expressed genes/change - time point 30 the most different one
(ma_plot | pca_plot)

#how does expression change amongst time-points?
#how does expression change
##Visualizing expression trends
#1. Get candidate gene (aka padj < 0.01)
candidate_gene <- test_results %>% 
  filter(padj < 0.01) %>% 
  pull() %>%    #pipe friendly way t extract one column and turn it into a vector from a tibble/data.frame  
            #like test_results[, "gene] aka test_results$gene -> just here pipe friendly and is pipe firendly
            #piping is specific to tidyverse
            #filter -> changes stuff in rows, mutate changes format
  unique()  #input needs to be a vector
  
#1. get the trans-cts table in long format
trans_cts_long <- trans_cts %>% 
  pivot_longer(cols = wt_0_r1:mut_180_r3, names_to = "sample", values_to = "cts") %>% 
  full_join(sample_info, by = "sample")
#2. Fitler trans_cts_long for candidate genes and compute mean expression value for each gene in each tp and each genotype
trans_cts_mean <- trans_cts_long %>% 
  filter(gene %in% candidate_gene) %>%                 #%in% tests element in vector on left are contained in the vector on right - usually surrounded by %_% - require sth before and after!
  group_by(gene, strain, minute) %>% 
  summarize(mean_cts = mean(cts), nrep = n()) %>% 
  
#3. now ungroup -> table has a group that knows it has elements in it, drop the group
  ungroup()                                 #refers to the ungroup from before, table may look the same but

#4. plot
trans_cts_mean %>% 
  ggplot(aes(x = minute, y = mean_cts))+
  geom_line(aes(group = gene), alpha = 0.3) +
  facet_grid(rows = vars(strain))

#align them relative to mean, which will highlight the variance 
#scaling the data to improve isualization
trans_cts_mean <- trans_cts_long %>% 
  filter(gene %in% candidate_gene) %>% 
  group_by(gene) %>% 
  mutate(cts_scaled = cts - mean(cts) / sd(cts)) %>% 
  group_by(gene, strain, minute) %>% 
  summarize(mean_cts_scales = mean(cts_scaled),
            nrep = n()) %>% 
  ungroup()                                      #mutate applies the function to each group indiidually, which is sth you don´t want when you have output tables like this
#before deseq merging of techinal replicates, biological replicated are notmerged at any point


#graphics
trans_cts_mean %>% 
  ggplot(aes(x = minute, y = mean_cts_scaled)) +
  geom_line(aes(group = gene), alpha = 0.3) +
  geom_hline(yintercept = 0, color = "brown", linetype= "dashed")+
  facet_grid(rows = vars(strain))
#scale_x_continuous(breaks = unique (trans_cts_mean$minute))
#exploring the results of diff express analysis -> pbservations support the cluster analysis -> find the genes and separate them according to the visible strands
#multiple types of clustering possibl -> supervised and unupervised -> bottom up - aggregation of data from data being separated and putting them in the same cluster, other approches top -> down and given number of cluster = supervision comes into play

##clustering
#two main steps -> calculaate the distance matrix between pairs (PCA space instead of having one for per gene -> geometrich distance computed -> two dots have), other kind of distance = correlation and calculation of a value how an espression of a gene in two conditions is similar and calculate the square matrix and find groups that have similar values
#there are many that give different results
trans_cts
#1 Create a maatrix of counts
#trans_cts is in wide foramt and needs to go into matrix
hclust_matrix <- trans_cts %>% 
  select(-gene) %>% 
  as.matrix()                         #upcoming function needs matrix
rownames(hclust_matrix) <- trans_cts$gene
hclust_matrix <- hclust_matrix[candidate_gene,]

hclust_matrix <- hclust_matrix %>% #zscore transform (value - mean/SD) -> centers value to mean and sets unit euqal to SD 
  t() %>% 
  scale() %>%                               #scale transformation to column applied, aber z score needs to be computed for rows = genes -> transposition -> z score of rows -> put it back
  t()
dim(hclust_matrix)












