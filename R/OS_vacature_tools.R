# tools voor vacaturedata

# maakt gebruik van 
# glue()
# database functies


import_vacs_selected <- function(cols = c('reference', 'datefound'),
                                 gem_sel = NULL){
  
  query <- glue("
      SELECT {paste(paste0('\"', cols, '\"'), collapse = ', ')} 
      FROM proj_vacaturedatabase.vacatures_verrijkt
      ")
  
  query <-  ifelse(is.null(gem_sel), query, 
                   glue("{query} WHERE physicallocationmunicipality like '{toupper(gem_sel)}'"))
  
  
  vacs <- dbGetQuery(db_con_ar(), query) %>% 
    setDT()
  
  
  return(vacs)
  
  
}


