#Roope Kaaronen, 9.11., Data Wrangling Exercise

install.packages("dplyr")

library(dplyr)

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

str(lrn14)
dim(lrn14)

#The data has 183 rows and 60 columns (variables)

#Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points

# questions related to deep, surface and strategic learning

deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06",  "D15", "D23", "D31")

surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")

strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")

# select the columns related to deep learning and create column 'deep' by averaging

deep_columns <- select(lrn14, one_of(deep_questions))

lrn14$deep <- rowMeans(deep_columns)

# select the columns related to surface learning and create column 'surf' by averaging

surface_columns <- select(lrn14, one_of(surface_questions))

lrn14$surf <- rowMeans(surface_columns)

# select the columns related to strategic learning and create column 'stra' by averaging

strategic_columns <- select(lrn14, one_of(strategic_questions))

lrn14$stra <- rowMeans(strategic_columns)

# choose a handful of columns to keep

keep_columns <- c("gender", "Age", "Attitude", "deep", "stra", "surf", "Points")

# select the 'keep_columns' to create a new dataset

learning2014 <- select(lrn14, one_of(keep_columns))

# see the structure of the new dataset

str(learning2014)

# print out the column names of the data
colnames(learning2014)

# change the name of the second column
colnames(learning2014)[2] <- "age"

# change the name of "Points" to "points"
colnames(learning2014)[7] <- "points"

colnames(learning2014)[3] <- "attitude"

colnames(learning2014)

# select rows where points is greater than zero

learning2014 <- filter(learning2014, points > 0)

dim(learning2014)

write.csv(learning2014, file = "learning2014.csv")

#Reading learning2014.csv

read.csv(file = "learning2014.csv")

head(learning2014)
str(learning2014)

#DATA ANALYSIS starts from here (ignore)

str(learning2014)
dim(learning2014)

install.packages("ggplot2")

library(ggplot2)

install.packages("GGally")

library(GGally)

p <- ggpairs(learning2014, mapping = aes(col = gender), lower = list(combo = wrap("facethist", bins = 20)))

p


#multiple linear model (points ~ attitude, stra, surf)
my_model2 <- lm(points ~ attitude + stra + surf, data = learning2014)

summary(my_model2)

#delete surf (not significant)
my_model3 <- lm(points ~ attitude + stra, data = learning2014)

summary(my_model3)

#simple linear model (attitude is the only statistically significant variable...)
my_model <- lm(points ~ attitude, data = learning2014)

#print scatterplot with fitted regression (attitude)
qplot(attitude, points, data = learning2014) + geom_smooth(method = "lm")

summary(my_model)

# **Note to self**: attitude is on scale 0-50! Other variables are 1-5.
head(learning2014$attitude)
head(learning2014$stra)

#Checking the assumptions of my_model (diagnostics)

par(mfrow = c(2,2))

plot(my_model, which = c(1, 2, 5))
