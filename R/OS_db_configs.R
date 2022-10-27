# database functies Onderzoek en Statistiek

library(yaml)

db_con_ar <- function(db_config = NULL){
  

  if(in_adw()){
    db_config <- yaml.load_file("H:/db_configs/analyse_ruimte.yml")$default
  } else {
    # to do: get dbconfig van windows credential store 
  }
  
  con <- dbConnect(RPostgres::Postgres(),
                   host = "10.243.17.34",
                   dbname = "mdbdataservices",
                   user = db_config$user,
                   password = db_config$password,
                   port = "5432",
                   bigint="integer")
  
}



db_con_ref <- function(db_config = NULL){
  
  library(yaml)
  library(DBI)
  
  
  if(in_adw()){
    db_config <- yaml.load_file("H:/db_configs/referentiedb.yml")$default
  } else {
    # to do: get dbconfig van windows credential store 
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