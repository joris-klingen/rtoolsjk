# database functies Onderzoek en Statistiek

library(yaml)
library(DBI)


db_con_ar <- function(db_config = NULL, 
                      path = "H:/db_configs/analyse_ruimte.yml",
                      from_env = FALSE){
  
  
  if(dir.exists('G:/OIS')){
    db_config <- yaml.load_file(path)$default
  }
  
  if(from_env){
    dotenv::load_dot_env(file = '.env')
    
    db_config <- list()
    
    db_config$host <- Sys.getenv()[['REF_DB_HOST']]
    db_config$dbname <- Sys.getenv()[['REF_DB_NAME']]
    db_config$user <- Sys.getenv()[['REF_DB_USER']]
    db_config$password <- Sys.getenv()[['REF_DB_PASSWORD']]
    db_config$port <- Sys.getenv()[['REF_DB_PORT']]
    
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

db_con_basisstat <- function(db_config = NULL, 
                             path = "H:/db_configs/basisstatistiek_dev.yml",
                             from_env = FALSE){
  

  if(dir.exists('G:/OIS')){
    db_config <- yaml.load_file(path)$default
  } 
  
  if(from_env){
    dotenv::load_dot_env(file = '.env')
    
    db_config <- list()
    
    db_config$host <- Sys.getenv()[['BSK_DB_HOST']]
    db_config$dbname <- Sys.getenv()[['BSK_DB_NAME']]
    db_config$user <- Sys.getenv()[['BSK_DB_USER']]
    db_config$password <- Sys.getenv()[['BSK_DB_PASSWORD']]
    db_config$port <- Sys.getenv()[['BSK_DB_PORT']]
    
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



db_con_ref <- function(db_config = NULL, 
                       path = "H:/db_configs/referentiedb.yml",
                       from_env = F){
  
  library(yaml)
  library(DBI)
  
  
  if(dir.exists('G:/OIS')){
    db_config <- yaml.load_file(path)$default
  } 
  
  if(from_env){
    dotenv::load_dot_env(file = '.env')
    
    db_config <- list()
    
    db_config$host <- Sys.getenv()[['AR_DB_HOST']]
    db_config$dbname <- Sys.getenv()[['AR_DB_NAME']]
    db_config$user <- Sys.getenv()[['AR_DB_USER']]
    db_config$password <- Sys.getenv()[['AR_DB_PASSWORD']]
    db_config$port <- Sys.getenv()[['AR_DB_PORT']]
    
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