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
#9 be redundant with comments
#10 use auto complete to avoid typos and not to have search 10 years for shit


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
#now go to git and commit


#Exercise 1:
mass <- 47.5
age <- 122
mass <- 2 * mass
age <- age - 20
mass_index <- mass/age
#function is piece of code that executes certain things wo/ having to rerun the block of all commands and save time

sqrt(9)
#returns a value and not every function needs to return a value
#sqrt retains one argument but there are functions that need more than one -> help section
#function used on stuff that is going to be saved as new value
weight_kg <- sqrt(9)
#function _ bunch of lines of code that do certain things and give you output

?round()
#even here you can seatch
#console search -> script is for rerun and help not so use console
#fucntions have arguments, arguments can be values

#fcuntion w/ multiple arguments
round(3.14159)
#rounded to one digit but function round can round to several digits, but default is 0 (it saysin help)
round(3.14159, digits = 3)
round(3.14159, 2)
#is the same in both versions
#round has two arguments and since srguments are not named R uses position which is which

round(digits = 2, x = 3.14159)
#if argument is specified, position doesn´t matter
# here = 2 and not <- , assignment an = are two different things and used in different contexts

round(2, 3.14159)
#as arguments have order and are not specified, here it takes it as defualt
#argument is necessary if no = there
round(digits = 2)
#doesnt work
args(round)
#specifies the args
#ComplexHeatmap::add_heatmap -> write it in console function and subfunction

#how to know what is in a function, here new function written
my_function <- function(x) {
  x <- x+2
}
#curly brackets stores code for funtion
#see whats ina function by typing it into console wo/ brackets to see the parts
#or View(my_function)
#or glasses beside a function

my_result <- my_function(3)