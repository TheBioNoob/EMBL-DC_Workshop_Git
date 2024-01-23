#Vectors
weight_g <- c(50, 60, 65, 82)
#c always used for several things

animals <- c("mouse", "rat", "dog")
# "" needed bc are would otherwise search it as object and error massage
#object = container of sth, animals is object or table is one or a data table

#all terms need to be of the same type in a vector
#functions to interact w/ a vector

length(animals)
#length of a vector

#get type of data contained in the vector
class(animals)
class(weight_g)

#structure of the object
str(animals)
#chr = characters, length=2, content is...

#add ellement to beginning of vector
animals <- c("cincilla", animals)
animals
#adding in middle is shit bc you might need to break vector and reassemble it
animals <- c(animals, "frog")
animals

#datatypes
#hardly used - complex(complex numbers) and raw (bits and bites)
#numers,logicals,strings
typeof(animals)
#difference btw typeof and class unclear?

#Exercise 1:
num_char <- c(1, 2, 3, "a")
class(num_char)
#chooses one, R wants vector to be consistent and contain only one type - characters, unverstood from quotation marks in the environment
num_logical <- c(1, 2, 3, TRUE)
# num_logical <- c(1, 2, 3, TRUE) = num_logical <- c(1, 2, 3, T) -> type chosen according to numerical
class(num_logical)
char_logical <- c("a", "b", "c", T)
char_logical
tricky <- c(1, 2, 3, "4")
tricky 
#all became a character
#conversion to character
#R tries to preserve as much info as possible -> 1,2,3 can always become strings but a cannot be a number, therefore everything is a character, True is a 1 and false = 0
#hierarchy -> if logical it can become number=numeric, if numeric it can become a charater but no character cannot be numeric , lovial -> numeric and character
#string is vector of individ characters

#subsetting a vector with []
animals[2] #picking 2nd element
#R starts counting from one, first element first

#vector = "dog", "cat", "mouse"
#string = dogcatmouse

#subsetting two elements
animals[c(1,2)]

more_animals <- animals[c(1, 2, 3, 2, 1, 4)]
more_animals
#you can blacken the value and run it, no need to rewrite it

weight_g[c(F, F, T, T)]
#logicals to select something
weight_g > 63
#gives logical result
weight_g[weight_g > 63]
#true an falses are selected and then put out as number
weight_g[weight_g > 63 & weight_g < 80]
#& = two logical operators mixed with & only true if both are true
weight_g[weight_g <58 | weight_g > 80]
# <, >, == (equal), != (different), <=, >= size operators > test euqlity!
weight_g[weight_g == 65]
weight_g == 65
# which line is 65?

animals[animals == "rat" | animals == "frog"]

#writing out strings is shit with many options
#check if one of the animals is e.g. a dog -> write a logical condition for each animals to test
#%in% helps find all elements correcponding to a vector of our choice
animals %in% c("rat", "frog", "cat", "duck", "dog")
animals[animals %in% c("rat", "frog", "cat", "duck", "dog")] 

#R ability to handle missing data -> placeholder NA
heights <- c(2, 4, 4, NA, 6)
mean(heights)
#value could not be observed
#remove NA -> help-> mean it says at na.rm to remove it
mean(heights, na.rm = T)
max(heights, na.rm = T)

is.na(heights)
#checks if element is NA -> logical answer
heights[!is.na(heights)]
#!negates logical, "!"=means "not"
#NA is a placeholder for missing value, not a character, therefore data is not transformed to character, therefore NA (just like true and false) is  special value and colored in blue
#data tyle of heights
#in data R will automatically put NA there but you should put NA there!
na.omit(heights)
#does the same thing
heights[complete.cases(heights)]

heights1 <- c(63, 69, 60, 65, NA, 68, 61, 70, 61, 59, 64, 69, 63)
heights_no_na <- heights1[!is.na(heights1)]
#median of values without NA
median(heights_no_na)
median(heights, na.rm = T)
length(heights_no_na[heights_no_na > 67])
#how many are >67
sum(heights_no_na > 67) 
#logicals are transformed into numbers and if F=0 and T=1, it´s 0,1.... = 4 in sum
#sum expectes numeric or complex vector and 
