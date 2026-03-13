library(httr)
library(jsonlite)

get_json_response <- function(base_url,
                              params){
  
  get_out <- GET(url = base_url, query = params)
  
  get_out <- jsonlite::fromJSON(content(get_out, "text"))
  
  return(get_out)
  
}


add_lon_lat <- function(response){
  
  extract(response, col = centroide_ll, into = c('lon', 'lat'), regex = 'POINT\\((.*) (.*)\\)', convert = T)
  
}



get_pdok_locatie <- function(query,
                             fields = c('woonplaatsnaam', 'straatnaam', 'huisnummer', 'postcode','centroide_ll'),
                             rows = 1){
  
  lreturns <- list()
  
  for(i in seq_along(query)){
    
    loc_input <- query[[i]]
    
    cat('now loading', loc_input, i, 'from', length(query), '\n')
    
    resp <- get_json_response(base_url ='https://api.pdok.nl/bzk/locatieserver/search/v3_1/free?',
                              params = list(fl = paste(fields, collapse = ' '),
                                            rows = rows,
                                            q = loc_input))
    
    
    lreturns[[i]] <- data.frame(query = loc_input,
                                as.data.frame(resp$response$docs)
    )
    
    
  }
  
  returns <- bind_rows(lreturns)
  
  
  returns <- add_lon_lat(returns)
  
  # change col order
  returns <- returns %>% 
    select(query, any_of(fields), lat, lon)
  
  return(returns)
  
}




