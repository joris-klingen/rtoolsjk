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



get_geo_json <- function(level, year, with_water=FALSE){
  base_url = "https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/main/geo/amsterdam/"
  if (year <= 2020){
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

extract_name_code_table <- function(level, year){
  geo_json <- get_geo_json(level = level, year = year)
  
  df = geo_json$features$properties
  lookup <- setNames(as.character(df$naam), df$code)
  return(lookup)
}