3 + 4
#just script plane, not interactive

3+4
#space is good practice to make code more readable
#there are instances in which you need to make it in certain codes but well seen when done

weight_kg <- 55
#assign operator: <- 
# other languages use = an nocht <-
#R traditionally uses = for something different historically in functions, stick with <- in R for good practice
#shortcut (alt + -)
#rules for decicing which name to give an object
#1 explicit name (weight_kg = weight in kg), if called mickey <- 27, it wouldn´t make sense
#2 not too long bc of typos and informative
#3 object names cannot start w/ a number x2<-works but a variable may not be named x2
#4 R is case sensitive Weight_kg<-34 is something different than weight_kg55
#5 use underscores instead of dots bc dots have meaning
#6 donot use umbers as names for objects and names cannot be used if reserved like basic grammar like "if, for" (is highlighter in different color then)
#7 same case like #6 for other function names; variable is not called mean bc mean is a function-name (do not use as shortcut) but is not blue, so take care; my_mean woud work but not mean...
#8 style suggestion: my_mean vs MY_MEAN or myMEAN -> either is fine but be consistent, there are online suggestions but not mandatory

my_weight_kg <- 50
(my_weight_kg <- 50)
#shortcut to get feedback
#you have several ways to look which object has been saved in a shortcut
#() assignment and echoing on console at once -> is stoed AND shown in console, otherwise it would only be stored
my_weight_kg

#arythmetic operations with object feasible after assignment and subsequent storage
2.2 * weight_kg

weight_kg <- 57
2.2 * weight_kg
#new value for weight_kg -> overwrite of old value

weight_lb <- 2.2 * weight_kg
#storage as new variable

weight_kg <- 100
#remodicication of value
#value same as before bc value is updated but that doesn´t change value of variable that has been changed before unless command is not rerun
#57 -> 100 and boths needs to be rerun to make it work as it does not affect lines of command made before
#save as xxxxx.R if R is not shown as modality

#ctrl + S = shortcut for saving 



