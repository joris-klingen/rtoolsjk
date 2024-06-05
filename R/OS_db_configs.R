# database functies Onderzoek en Statistiek

library(yaml)
library(DBI)



get_azure_access_token <- function(){
  az_output  <- tryCatch({
    system("az account get-access-token --resource-type oss-rdbms", intern = T)
    
  },
  error=function(e){
    message("error")
  },
  warning=function(w){
    system("az login")
    az_output <- system("az account get-access-token --resource-type oss-rdbms", intern = T)
    return(az_output)
  }
  )
  
  json <- jsonlite::fromJSON(paste(az_output, collapse = ""))
  return(json$accessToken)
}


os_db_con <- function(db_config = NULL, 
                      path = file.path(Sys.getenv('USERPROFILE'), 'db_configs', 'db_configs.yml'),
                      db_name = 'refdb_cloud',
                      hard_token = FALSE){

  db_config <- yaml.load_file(path)[[db_name]]
    
  if(db_config$password == 'access_token'){
    
    if(hard_token){
      
      # to do, get token from H:/ ...  token.txt
      # overwrite after prompt when expired
      
      
      db_config$password <- rstudioapi::showPrompt(
        title = 'azure_access_token', 
        message = 'provide your azure access token'
        )
      
    } else {
      
      db_config$password <- get_azure_access_token()
      
    }
    
  }
  
  
  con <- dbConnect(RPostgres::Postgres(),
                   host = db_config$host,
                   dbname = db_config$dbname,
                   user = db_config$user,
                   password = db_config$password,
                   port = db_config$port,
                   bigint="integer")
  
}


db_con_ar <- function(db_config = NULL, 
                      path = "H:/db_configs/analyse_ruimte.yml",
                      from_env = FALSE){

  
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
  
  return(con)
  
}


