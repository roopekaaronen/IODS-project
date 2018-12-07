# ROOPE KAARONEN, 4.12.2018
# IODS COURSE PROJECT, DATA WRANGLING EXERCISE, CHAPTER 6


library(dplyr)
library(ggplot2)
library(tidyr)
library(corrplot)
library(MASS)
library(GGally)
###

BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep  =" ", header = T)

RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", header = TRUE, sep = '\t')

View(BPRS)
str(BPRS)
dim(BPRS)
names(BPRS)
summary(BPRS)
glimpse(BPRS)
View(RATS)
str(RATS)
dim(RATS)
names(RATS)
summary(RATS)
glimpse(RATS)


## Factor categorical variables
# Factor treatment and subject
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

# Factor variables ID and Group
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)


# Convert BPRS to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
?gather
# Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
glimpse(BPRSL)

# Convert RATS to long form
RATSL <- RATS %>%
  gather(key = WD, value = Weight, -ID, -Group) %>%
  mutate(Time = as.integer(substr(WD,3,4)))

# Glimpse the data
glimpse(RATS)

# Now, take a SERIOUS LOOK at the data

str(BPRS)
str(BPRSL)
View(BPRS)
View(BPRSL)

str(RATS)
str(RATSL)
View(RATS)
View(RATSL)

# Long and wide forms look different, alright.

# Finally, write the csvs
write.csv(RATSL, file = "RATSL.csv") 

write.csv(BPRSL, file = "BPRSL.csv") 
# WRANGLING OVER
