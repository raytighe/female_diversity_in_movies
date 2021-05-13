# This code combines the IMDb.com and Bechdeltest.com datasets and 
# creates variables used in later analyses

library('tidyverse')
library('here')
library("rjson")

here::i_am('./data/process_raw_data.R')

# Read in Bechdel data as dataframe
bechdel <- fromJSON(file = here('./data/raw/getMoviesByTitle.json'))
do.call("rbind", bechdel)
bechdel<-data.table::rbindlist(bechdel,  fill = TRUE)

# Read in table.basic and remove leading 'tt' from ID column
imdb.title.basics <- read.delim2(here('data/raw/title.basics.tsv'),
                                fill = TRUE,
                                header = TRUE,
                                sep = "\t")
imdb.title.basics$tconst <- substring(imdb.title.basics$tconst, 3)

# Read in table.ratings and remove leading 'tt' from ID column
imdb.title.ratings <- read.delim2(here('data/raw/title.ratings.tsv'),
                                 fill = TRUE,
                                 header = TRUE,
                                 sep = "\t")
imdb.title.ratings$tconst <- substring(imdb.title.ratings$tconst, 3)

# Inner join the three data frames
temp <- inner_join(bechdel,imdb.title.basics, by = c("imdbid" = "tconst"))
merged_data <- inner_join(temp,imdb.title.ratings, by = c("imdbid" = "tconst"))

# filter out tv shows, etc.
merged_data <- filter(merged_data, titleType == 'movie')

# Check for unique IMDb IDs
duplicates <- data.frame(table(merged_data$imdbid))
duplicates[duplicates$Freq > 1,]

# Manually exclude these because they are duplicates
merged_data <- filter(merged_data, 
                      imdbid != '0035279'&
                      imdbid !='0086425' &
                      imdbid !='0117056' &
                      imdbid !='2043900' &
                      imdbid !='2457282' &
                      isAdult == 0)

# Check for duplicates again
duplicates <- data.frame(table(merged_data$imdbid))
duplicates[duplicates$Freq > 1,]

# Select relevant comments for analysis
subset <- merged_data[,c(2,6,16,17,18,19,9)]

# Create new variable for fully passing the Bechdel test
subset<-mutate(subset, full_pass = 
                 case_when(rating == 0 ~ 0,
                           rating == 1 ~ 0,
                           rating == 2 ~ 0,
                           rating == 3 ~ 1))

# create new variable for mostly or fully passing the Bechdel test
subset<-mutate(subset, mostly_pass = 
                 case_when(rating == 0 ~ 0,
                           rating == 1 ~ 0,
                           rating == 2 ~ 1,
                           rating == 3 ~ 1))

# Encode top 10 most prevalent genres as binary variables
top_genres <- c('romance','horror','comedy','mystery','drama','fantasy',
                'thriller','adventure','crime','action')

for (g in top_genres){
  subset[,g] <- ifelse(grepl(g, subset$genres, ignore.case = TRUE),
                       TRUE, FALSE)
}

# Create "other_genre" variable if a genre doesn't fall into the top 10
subset<-separate(subset, genres, into = c('genre1','genre2','genre3'), sep = ",",remove = FALSE)

subset$other_genre <- TRUE
for (i in 1:nrow(subset)){
  if ((is.element(tolower(subset$genre1[i]),top_genres) | is.na(subset$genre1[i]) == TRUE) & 
      (is.element(tolower(subset$genre2[i]),top_genres) | is.na(subset$genre2[i]) == TRUE) &
      (is.element(tolower(subset$genre3[i]),top_genres) | is.na(subset$genre3[i]) == TRUE))
  {
    subset$other_genre[i] <- FALSE 
  }
}

write.csv(subset,here('./data/processed/bechdel_imdb_full.csv'), row.names = TRUE)

subset <- select(subset, year, title, runtimeMinutes, averageRating, numVotes,
                 rating, full_pass, mostly_pass, romance, horror, comedy, mystery,
                 drama, fantasy, thriller, adventure, crime, action, other_genre)

# Since most years from 1953 - 2020 have >30 observations, we only use these years
aggregate(full_pass ~ year, data = subset, FUN = length)
subset <- filter(subset, year >= 1953 & year <= 2020)

write.csv(subset,here('./data/processed/bechdel_imdb_subset.csv'), row.names = TRUE)
