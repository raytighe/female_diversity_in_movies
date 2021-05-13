# Exploratory Data Analysis

library(here)
library(tidyverse)
library(ggplot2)

here::i_am('./eda/exploratory_analysis.R')

# Import and Process Data
subset <- read.csv(here('data/processed','bechdel_imdb_subset.csv'))
full_data <- read.csv(here('data/processed','bechdel_imdb_full.csv'))

# Proportion of fulling passing movies per year
agg.full_pass <- aggregate(full_pass ~ year, data = subset, FUN = mean)
ggplot(data=agg.full_pass, aes(x=year, y=full_pass, group=1)) +
  geom_line()+
  geom_point(aes(x=1993,y=0.53), colour="red")+
  scale_y_continuous(name = 'Percent of movies that pass the Bechdel Test',labels = scales::percent)+
  xlab('Year')

# Average IMDB Rating and Bechdel Test Score over years
ggplot(subset, aes(x = as.numeric(year), y = as.numeric(averageRating), color = as.factor(rating))) +
  geom_smooth(se = F) +
  labs(title ='Average IMDB Rating by Year and Bechdel Test Score',
       y='IMDb Average Rating',
       x = 'Year (1953 - 2020)') +
  scale_color_manual(name = "Bechdel Test Score", 
                     labels = c("0 - no two women", 
                                "1 - no talking", 
                                "2 - talking about a man", 
                                "3 - passes the test"),
                     values = c('Red', '#009E73', 'Blue', 'Orange'))

# Bechdel Test Scores trend
ggplot(subset, aes(x = year)) +
  geom_point(stat = 'count', aes(color = as.factor(rating))) +
  geom_line(stat = 'count', aes(color = as.factor(rating))) +
  theme(legend.position = 'right') +
  labs(title = 'Bechdel Test Scores over the years',
       subtitle = 'Count of Bechdel test film scores since 1953') +
  scale_color_manual(name = "Rating", 
                     labels = c("0 - no two women", 
                                "1 - no talking", 
                                "2 - talking about a man", 
                                "3 - passes the test"),
                     values = c('Red', '#009E73', 'Blue', 'Orange'))

# Average IMDB Rating by Year and Bechdel Test Score
ggplot(subset, aes(x = as.numeric(year), y = as.numeric(averageRating), color = as.factor(rating))) +
  geom_smooth(se = F) +
  labs(title ='Average IMDB Rating by Year and Bechdel Test Score',
       y ='IMDb Average Rating',
       x = 'Year (1953 - 2020)') +
  scale_color_manual(name = "Bechdel Test Score", 
                     labels = c("0 - no two women", 
                                "1 - no talking", 
                                "2 - talking about a man", 
                                "3 - passes the test"),
                     values = c('Red', '#009E73', 'Blue', 'Orange'))

# Average Bechdel Rating by Top 10 Most Prevalent Genres
temp <- strsplit(full_data$genres, split = ",")
rating_by_genre <- data.frame(rating = rep(full_data$rating, sapply(temp, length)),
                              genres = as.factor(unlist(temp))) %>%
  group_by(genres)  %>%
  summarise(mean_rating = mean(rating), movie_count = n()) %>%
  top_n(10, movie_count)

p<-ggplot(rating_by_genre, aes(reorder(genres, -mean_rating), mean_rating)) + 
  geom_bar(aes(fill = mean_rating >= 2),stat = "identity") +
  geom_hline(yintercept = 2,linetype="dashed", color = "#303030") +
  scale_fill_manual(labels = c("\u2265 2.0", "< 2.0"),breaks = c(TRUE, FALSE), values=c("#009E73", "#E69F00"))+
  labs(x='Movie Genre', y='Average Bechdel Rating', fill = "Average\nBechdel\nRating")+
  ggtitle('Average Bechdel Rating by Top 10 Most Prevalent Genres')
p
