## IMDB project (web scraping)
library(tidyverse)
library(rvest)

url <- "https://www.imdb.com/chart/top/"

imdb <- read_html(url)

movie_name <- imdb %>%
  html_nodes("td.titleColumn") %>% 
  html_text() %>%
  str_remove_all("\n") %>%
  str_trim() %>%
  str_replace_all("\\s+", " ") %>%
  str_remove_all("^[0-9]+\\.\\s") %>%
  str_remove_all("\\s+\\(+[0-9]{4}+\\)")

year <- imdb %>%
  html_nodes("td.titleColumn") %>%
  html_text() %>%
  str_extract("[0-9]{4}") %>%
  as.numeric()

rating <- imdb %>%
  html_nodes("td.ratingColumn.imdbRating")%>%
  html_text() %>%
  str_remove_all("\n") %>%
  str_trim() %>%
  as.numeric()

# combine all to data frame
imdb_top <- data.frame(No = c(1:250), Title = movie_name , Year = year, Rating = rating) %>%
  as_tibble()
cat("IMDb Top 250 as rated by regular IMDb voters:")
imdb_top

# write to csv
write_csv(imdb_top, "imdb_top250.csv")