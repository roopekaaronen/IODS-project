# ROOPE KAARONEN, 23.11.2018
# IODS COURSE PROJECT, DATA WRANGLING EXERCISE

# read data
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)

gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")


# structure and dimension
str(hd)
str(gii)
dim(hd)
dim(gii)
View(gii)
library(dplyr)

# rename columns
colnames(hd) <- c("Rank", "Country", "HDI", "Life.Exp.", "Exp.Ed", "Mean.Ed", "GNI", "GNIminusHDI")
colnames(gii) <- c("Rank", "Country", "GII", "Maternal.Mortality", "Adol.Birth", "Parliament", "Female.Ed", "Male.Ed", "Labour.F", "Labour.M")

# mutate, add two columns
gii <- mutate(gii, FM.Ed = Female.Ed / Male.Ed, FM.Lab = Labour.F / Labour.M)

# join the two datasets
human <- inner_join(hd, gii, by = "Country")
dim(human)
str(human)

# Observations: 195
# Variables: 19

# Finally, write the csv
write.csv(human, file = "human.csv")

# All is set. DATA WRANGLING OVER ~~