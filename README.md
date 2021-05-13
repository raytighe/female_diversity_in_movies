# Diversity in Movies

## Team Matrix Section

### Description
In this study, we infer which movie characteristics are most associated with passing the Bechdel test based on data from Bechdeltest.com and IMBb.com. 

### Data Source Links
* IMDb: https://www.imdb.com/interfaces/
* Bechdel Test: http://bechdeltest.com/api/v1/getMoviesByTitle?title=

### Setup for Full Reproducibility
* Step 1: Download the IMDb datasets title.ratings.tsv.gz and title.basics.tsv.gz, uncompress, and put in data/raw
* Step 2: Download the Bechdeltest.com dataset as a .json file and put in data/raw
* Step 3: Execute process_raw_data.R to merge and preprocess datasets
* Step 4: Execute analysis/team_matrix.R

### File Structure
```
re_movies_4
│    README.md
│
└───data
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
│    │ process_raw_data.R
│
└───analysis
│    │ team_matrix.R
│
└───visualization
     │ Visualization of data (Ge Song).Rmd
     │ Visualization of data (Haoron Li).Rmd
     │ Visualization of data (Ray Tighe).Rmd
     │ Visualization of data (Zhiruo Zhang).Rmd
	 
```
