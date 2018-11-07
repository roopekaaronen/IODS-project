# DATA WRANGLING START

library(dplyr)
dat <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", header = TRUE, sep = "\t")

str(dat)
dim(dat)
View(dat)

## The table has 183 rows and 60 columns.

dat$attitude <- dat$Attitude / 10

#Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points

# questions related to deep, surface and strategic learning

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06",  "D15", "D23", "D31")

surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging

deep_columns <- select(dat, one_of(deep_questions))

dat$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging

surface_columns <- select(dat, one_of(surface_questions))

dat$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging

strategic_columns <- select(dat, one_of(strategic_questions))

dat$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep

keep_columns <- c("gender", "Age", "attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset

learning2014 <- select(dat, one_of(keep_columns))

# see the structure of the new dataset

str(learning2014)

# change some column names

colnames(learning2014)[2] <- "age"

colnames(learning2014)[7] <- "points"

colnames(learning2014)

# select rows where points is greater than zero
learning2014 <- filter(learning2014, points > 0)
str(learning2014)

write.csv(learning2014, file = "learning2014.csv")

#Reading learning2014.csv

read.csv(file = "learning2014.csv")

# ~~~~~~~~~ DATA WRANGLING OVER ~~~~~~~~
# DATA ANALYSIS:

str(learning2014)
dim(learning2014)

# Learning2014 has 166 rows and 7 columns. Like it should. Yay.


# Access the gglot2 library
library(ggplot2)

# Graphical overview of the data
# Strongest correlations are between points and attitude.

p <- ggpairs(learning2014, mapping = aes(col = gender), lower = list(combo = wrap("facethist", bins = 20)))

p


# plot attitude vs points
p1 <- ggplot(learning2014, aes(x = attitude, y = points, col = gender)) +
  geom_point() +
  geom_smooth(method = "lm") +
  ggtitle("Student's attitude versus exam points")
# print the plot
p1

install.packages("GGally")

library(GGally)
