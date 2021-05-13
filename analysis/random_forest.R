# Random Forest

library(here)
library(tidyverse)
library(randomForest)
library(ggplot2)
set.seed(123)

subset <- read.csv(here('data/processed','bechdel_imdb_subset.csv'))

#force variable to numeric, fill NA's with mean (only 5 to fill)
subset$runtimeMinutes <- as.numeric(subset$runtimeMinutes)
subset$runtimeMinutes[is.na(subset$runtimeMinutes)] <- mean(subset$runtimeMinutes, na.rm = TRUE)

# make full_pass and mostly_pass a factor
subset$full_pass <- as.factor(subset$full_pass)
subset$full_pass <- as.factor(subset$full_pass)

## 4-Class response
classtree1 <- randomForest(as.factor(rating) ~ year + runtimeMinutes + averageRating + romance + 
                             horror + comedy + mystery + drama + fantasy + thriller + adventure +
                             crime + action + other_genre + numVotes, data = subset, norm.votes = TRUE , importance = TRUE)

importance(classtree1)
imp <- varImpPlot(classtree1,type = 1)
imp <- as.data.frame(imp)
imp$varnames <- rownames(imp) 

ggplot(imp, aes(x = reorder(varnames, MeanDecreaseAccuracy), y = MeanDecreaseAccuracy)) + 
  geom_point() +
  geom_segment(aes(x =varnames,xend = varnames,y=0,yend=MeanDecreaseAccuracy)) +
  ylab("Mean Decrease Accuracy") +
  xlab("Variable Name") +
  coord_flip() +
  labs(title = "(a) 4-Class Response")

# Binary response
classtree.binary <- randomForest(as.factor(full_pass) ~ year + runtimeMinutes + averageRating + romance + 
                                   horror + comedy + mystery + drama + fantasy + thriller + adventure +
                                   crime + action + other_genre + numVotes, data = subset, norm.votes = TRUE , importance = TRUE)

importance(classtree.binary)
imp2 <- varImpPlot(classtree.binary,type = 1)
imp2 <- as.data.frame(imp2)
imp2$varnames <- rownames(imp2) 

ggplot(imp2, aes(x=reorder(varnames, MeanDecreaseAccuracy), y=MeanDecreaseAccuracy)) + 
  geom_point() +
  geom_segment(aes(x=varnames,xend=varnames,y=0,yend=MeanDecreaseAccuracy)) +
  ylab("Mean Decrease Accuracy") +
  xlab("Variable Name") +
  coord_flip() +
  labs(title = "(b) Binary Response")


# Without Year variable
# 4-Class response
classtree2 <- randomForest(as.factor(rating) ~ runtimeMinutes + averageRating + romance + 
                             horror + comedy + mystery + drama + fantasy + thriller + adventure +
                             crime + action + other_genre + numVotes, data = subset, norm.votes = TRUE , importance = TRUE)

importance(classtree2)
imp3 <- varImpPlot(classtree2,type = 1)

# Binary response
classtree.binary2 <- randomForest(as.factor(full_pass) ~ runtimeMinutes + averageRating + romance + 
                                    horror + comedy + mystery + drama + fantasy + thriller + adventure +
                                    crime + action + other_genre + numVotes, data = subset, norm.votes = TRUE , importance = TRUE)

importance(classtree.binary2)
imp4 <- varImpPlot(classtree.binary,type = 1)
