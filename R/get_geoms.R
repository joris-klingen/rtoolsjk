library(sf)

get_geom <- function(gebieden = 'wijken',
                        peiljaar = 2022,
                        zonder_water = T){
  
  
  geom <- st_read(
    paste('https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/develop/public/geo/amsterdam',
          peiljaar,
          paste0(gebieden,'-', peiljaar,'-zw-geo.json'), 
          sep = '/'))
  
  
  return(geom)
  
  
}


