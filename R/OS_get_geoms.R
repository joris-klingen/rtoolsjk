library(sf)

os_get_geom <- function(peiljaar = 2022,
                        gebieden = 'wijken',
                        zonder_water = T){
  
  
  geom <- st_read(
    paste('https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/develop/geo/amsterdam',
          peiljaar,
          paste0(gebieden,'-', peiljaar,'-zw-geo.json'), 
          sep = '/'))
  
  
  return(geom)
  
  
}


