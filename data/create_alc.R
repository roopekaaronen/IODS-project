# Roope Kaaronen, IODS course University of Helsinki, 13.11.2018
# REF: P. Cortez and A. Silva. Using Data Mining to Predict Secondary School Student Performance. In A. Brito and J. Teixeira Eds., Proceedings of 5th FUture BUsiness TEChnology Conference (FUBUTEC 2008) pp. 5-12, Porto, Portugal, April, 2008, EUROSIS, ISBN 978-9077381-39-7. 

# DATA WRANGLING

# Read data
mat <- read.csv("student-mat.csv", sep = ";" , header=TRUE)
por <- read.csv("student-por.csv", sep = ";" , header=TRUE)

# Structure and dimensions
str(mat)
str(por)
dim(mat) 
dim(por)

# Access dplyr 
library(dplyr)

# common columns to use as identifiers
join_by <- c("school","sex","age","address","famsize","Pstatus","Medu","Fedu","Mjob","Fjob","reason","nursery","internet")

# Combine datasets
math_por <- inner_join(mat, por, by = join_by, suffix = c(".math", ".por"))
str(math_por)
dim(math_por)

# Dimensions: [1] 382  53

# print out the column names of 'math_por'
colnames(math_por)

# create a new data frame with only the joined columns
alc <- select(math_por, one_of(join_by))
alc
# columns that were not used for joining the data
notjoined_columns <- colnames(mat)[!colnames(mat) %in% join_by]

# print out the columns not used for joining
notjoined_columns
join_by

# FOR LOOP / IF-ELSE
# for every column name not used for joining...
for(column_name in notjoined_columns) {
  # select two columns from 'math_por' with the same original name
  two_columns <- select(math_por, starts_with(column_name))
  # select the first column vector of those two columns
  first_column <- select(two_columns, 1)[[1]]
  
  # if that first column  vector is numeric...
  if(is.numeric(first_column)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[column_name] <- round(rowMeans(two_columns))
  } else { # else if it's not numeric...
    # add the first column vector to the alc data frame
    alc[column_name] <- first_column
  }
}

# glimpse and view Str of new data
glimpse(alc)
str(alc)
View(alc)

# tidyverse time... mutations ahead!
# access ggplot2
library(ggplot2)

# define a new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# plot alcohol use
g1 <- ggplot(data = alc, aes(x = alc_use)) +
  geom_bar()
g1

# mutate again: high alc use
alc <- mutate(alc, high_use = alc_use > 2)

# plot high alc use, out of interest...
g2 <- ggplot(data = alc, aes(x = high_use)) +
  geom_bar()
g2

glimpse(alc)

# Observations: 382
# Variables: 35

# Finally, write the csv
write.csv(alc, file = "alc.csv")

# All is set. DATA WRANGLING OVER ~~