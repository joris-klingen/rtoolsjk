library(httr)
library(jsonlite)

# kleuren
blauw_pal <- c("#004699", "#3858a4", "#566bb0", "#707ebb", "#8992c6", "#a1a7d2", "#b8bcdd", "#d0d2e8", "#e7e8f4")
wild_pal <- c("#004699", "#009de6", "#53b361", "#bed200", "#ffe600", "#ff9100", "#ec0000")


# stadsdelen
stadsdelen = c(E = 'West',
               M = 'Oost', 
               A = 'Centrum',
               F = 'Nieuw-West',
               N = 'Noord',
               K = 'Zuid',
               T = 'Zuidoost',
               S = 'Weesp',
               B = 'Westpoort')



get_geo_json <- function(level, year, with_water=FALSE, mra=FALSE){
  base_url = "https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/main/geo/"
  
  if (mra) {
    level = glue::glue("{level}-mra")
    base_url = glue::glue("{base_url}mra/") 
  } else {
    base_url = glue::glue("{base_url}amsterdam/")
  }
  
  if (year <= 2020 & !mra){
    # The geo-jsons at the level of Amsterdam pre 2021 are grouped in one folder
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

extract_name_code_table <- function(level, year, mra=FALSE){
  geo_json <- get_geo_json(level = level, year = year, mra = mra)
  
  df = geo_json$features$properties
  lookup <- setNames(as.character(df$naam), df$code)
  return(lookup)
}

# get_geo_json("buurten", 2021, mra=FALSE)
# get_geo_json("buurten", 2018, mra=FALSE)
# 
# get_geo_json("buurten", 2021, mra=TRUE)
# get_geo_json("buurten", 2018, mra=TRUE)
# 
# extract_name_code_table("wijken", 2020, mra=F)
# extract_name_code_table("wijken", 2020, mra=T)