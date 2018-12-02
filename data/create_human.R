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



# All is set. DATA WRANGLING OVER ~~

## CONTINUED: CHAPTER 5
# Explore structure and dimensions
dim(human)
str(human)

# The data includes 195 observations of 19 variables
# The variables are renamed in the code above. M.Ed = Female.Ed / Male.Ed & FM.Lab = Labour.F / Labour.M

# mutate
library(stringr)
human$GNI <- str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

# keep only the select columns
keep <- c("Country", "FM.Ed", "FM.Lab", "Life.Exp.", "Exp.Ed", "GNI", "Maternal.Mortality", "Adol.Birth", "Parliament")

human <- dplyr::select(human, one_of(keep))

# Remove all rows with missing values
human <- filter(human, complete.cases(human))

# last indice we want to keep
last <- nrow(human) - 7

# Remove the observations which relate to regions instead of countries

human <- human[1:last, ]

# add countries as rownames
rownames(human) <- human$Country

dim(human)
str(human)
View(human)

# 155 observations from 9 variables. Looks good.

# remove the Country variable
human <- dplyr::select(human, -Country)

# Finally, write the csv
write.csv(human, file = "human.csv", row.names = TRUE) 

# END OF CH 5.

