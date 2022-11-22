# database functies Onderzoek en Statistiek

library(yaml)
library(DBI)

db_con_ar <- function(db_config = NULL, path = "H:/db_configs/analyse_ruimte.yml"){
  
  
  
  
  if(in_adw()){
    db_config <- yaml.load_file(path)$default
  } else {
    # to do: get dbconfig van windows credential store 
    db_config <- yaml.load_file(path)$default
    
  }
  
  con <- dbConnect(RPostgres::Postgres(),
                   host = db_config$host,
                   dbname = db_config$dbname,
                   user = db_config$user,
                   password = db_config$password,
                   port = db_config$port,
                   bigint="integer")
  
}



db_con_ref <- function(db_config = NULL, path = "H:/db_configs/referentiedb.yml"){
  
  library(yaml)
  library(DBI)
  
  
  if(in_adw()){
    db_config <- yaml.load_file(path)$default
  } else {
    # to do: get dbconfig van windows credential store 
    db_config <- yaml.load_file(path)$default
    
  }
  
  
  con <- dbConnect(RPostgres::Postgres(),
                   host = db_config$host,
                   dbname = db_config$dbname,
                   user = db_config$user,
                   password = db_config$password,
                   port = db_config$port,
                   bigint="integer")
  
  return(con)
  
}