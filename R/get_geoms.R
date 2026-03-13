library(sf)

rk_get_geom <- function(areas = 'wijken',
                        ref_year = 2022,
                        exclude_water = T){


  geom <- st_read(
    paste('https://gitlab.com/os-amsterdam/datavisualisatie-onderzoek-en-statistiek/-/raw/develop/public/geo/amsterdam',
          ref_year,
          paste0(areas,'-', ref_year,'-zw-geo.json'),
          sep = '/'))


  return(geom)


}
