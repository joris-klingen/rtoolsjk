library(httr)
library(jsonlite)


# Amsterdam geo lookups (fetches from OS Amsterdam GitLab)
rk_get_geo_json <- function(level, year, with_water=FALSE, mra=FALSE){
  base_url = "https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/main/geo/"

  if (mra) {
    level = glue::glue("{level}-mra")
    base_url = glue::glue("{base_url}mra/")
  } else {
    base_url = glue::glue("{base_url}amsterdam/")
  }

  if (year <= 2020 & !mra){
    # geo-jsons at the level of Amsterdam pre 2021 are grouped in one folder
    year = "2015-2020"
  }

  if (with_water){
    url = glue::glue("{base_url}/{year}/{level}-{year}-geo.json")
  } else {
    url = glue::glue("{base_url}/{year}/{level}-{year}-zw-geo.json")
  }

  json <- jsonlite::fromJSON(url)
  return(json)
}

rk_extract_name_code_table <- function(level, year, mra=FALSE){
  geo_json <- rk_get_geo_json(level = level, year = year, mra = mra)

  df = geo_json$features$properties
  lookup <- setNames(as.character(df$naam), df$code)
  return(lookup)
}
