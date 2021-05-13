# Diversity in Movies

### Description
This project and report was the final project in the capstone course of the statistics masters program I completed in May of 2021 at George Mason University. In this project, my teammates and I infer which movie characteristics are most associated with passing the Bechdel test, a heuristic for measuring female diversity in movies, based on data from Bechdeltest.com and IMDb.com. 

In this study, we explored the gender diversity of movies based on the Bechdel test. An exploratory analysis
showed an increasing proportion of movies tend to pass the Bechdel test over the past several decades. Upon a
deep look with both a regression analysis and random forest analysis, we found specific genres like romance to
be highly associated with passing the Bechdel test, and action to be highly associated with not passing the
Bechdel test. This suggests some genres, not all, are associated with the Bechdel test results. Specifically, our
study implied that action movies continue to lack female representation, even though overall movies are
increasingly becoming more diverse. Altogether, these findings do indicate an improvement in gender diversity
in the U.S. movie industry but reveal some potential underlying factors that affect gender diversity. Future
studies and analyses can include additional movie characteristics, such as investment and revenue, which are
not included in this study, to further study diversity in the film industry.

### Data Source Links
* IMDb: https://www.imdb.com/interfaces/
* Bechdel Test: http://bechdeltest.com/api/v1/getMoviesByTitle?title=

### Setup for Full Reproducibility
* Step 1: Download the IMDb datasets title.ratings.tsv.gz and title.basics.tsv.gz, uncompress, and put in data/raw
* Step 2: Download the Bechdeltest.com dataset as a .json file and put in data/raw
* Step 3: Execute data/process_raw_data.R to merge and preprocess datasets
* Step 4: Execute files in the eda and analysis folders

### File Structure
```
re_movies_4
│    README.md
│    Diversity in Movies Final Report.pdf
│
└───data
│    │   process_raw_data.R
│    │
│    └───processed
│    │    │ bechdell_imdb_merged.csv
│    │
│    └───raw (raw data files not checked in)
│         │ title.ratings.tsv
│         │ title.basics.tsv
│         │ getMoviesByTitle.json
│ 
└───eda
│    │ exploratory_analysis.R
│
└───analysis
     │ logistic_regression.R
     │ random_forest.R
```
