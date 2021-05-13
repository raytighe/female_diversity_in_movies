# Logistic and LASSO Regression

library(here)
library(tidyverse)
library(glmnet)

subset <- read.csv(here('data/processed','bechdel_imdb_subset.csv'))

#force variable to numeric, fill NA's with mean (only 5 to fill)
subset$runtimeMinutes <- as.numeric(subset$runtimeMinutes)
subset$runtimeMinutes[is.na(subset$runtimeMinutes)] <- mean(subset$runtimeMinutes, na.rm = TRUE)

# make full_pass and mostly_pass a factor
subset$full_pass <- as.factor(subset$full_pass)
subset$full_pass <- as.factor(subset$full_pass)

# First Logistic Regression
logistic_regression1 <- glm(full_pass ~ 
           year + 
           runtimeMinutes + 
           averageRating + 
           romance + 
           horror +
           comedy + 
           mystery + 
           drama +
           fantasy +
           thriller +
           adventure +
           crime +
           action +
           other_genre +
           numVotes,
         data = subset, family = 'binomial')

summary(logistic_regression1)

# LASSO
x1 <- as.matrix(select(subset, year, runtimeMinutes, averageRating, numVotes,
                       action, adventure, comedy, crime, drama, fantasy, horror,
                       mystery, romance, thriller, other_genre))
# x2 has no Year variable
x2 <- as.matrix(select(subset,runtimeMinutes, averageRating, numVotes,
                       action, adventure, comedy, crime, drama, fantasy, horror,
                       mystery, romance, thriller, other_genre))
y1 <- as.matrix(select(subset, full_pass))
y2 <- as.matrix(select(subset, mostly_pass))

set.seed(123)

# LASSO Regression - Fully Pass & Year Included
cvfit1 = cv.glmnet(x1, y1, alpha = 1, family = 'binomial')
round(exp(coef(cvfit1, s = "lambda.1se")),3)

# LASSO Regression - Fully Pass & Year NOT Included
cvfit2 = cv.glmnet(x2, y1, alpha = 1, family = 'binomial')
round(exp(coef(cvfit2, s = "lambda.1se")),3)

# LASSO Regression - Mostly/Fully Pass & Year Included
cvfit2 = cv.glmnet(x1, y2, alpha = 1, family = 'binomial')
round(exp(coef(cvfit2, s = "lambda.1se")),3)

# LASSO Regression - Mostly/Fully Pass & Year NOT Included
cvfit2 = cv.glmnet(x2, y2, alpha = 1, family = 'binomial')
round(exp(coef(cvfit2, s = "lambda.1se")),3)
