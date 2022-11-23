## functie voor genereren chi-square test
# df: dataframe/tibble met survey data
# var_x, var_y: kolomnamen van variabelen
# digits: aantal digits geprint in plot

OS_chisq_table <- function(df, var_x, var_y, digits = 3){
  
  perc_table <- df %>% 
    filter(!is.na(.data[[var_x]]) & !is.na(.data[[var_y]])) %>% 
    tabyl(.data[[var_x]], .data[[var_y]]) %>% 
    adorn_percentages("col") %>%
    adorn_pct_formatting(digits = digits) %>%
    adorn_ns() %>%
    as_tibble() %>%
    mutate(stat = 'percentage')
  
  
  chi_list <-  chisq.test(df %>% pull(.data[[var_x]]),
                          df %>% pull(.data[[var_y]]),
                          correct = FALSE)
  
  cat('p-value for Chi sq test: ', chi_list$p.value,'\n')
  
  
  res_table <- as.data.frame.matrix(round(chi_list$stdres, digits)) %>% 
    as_tibble(., rownames = var_x) %>% 
    mutate(across(everything(), as.character)) %>% 
    mutate(stat = 'stdres')
  
  
  chi_inspect_table <- perc_table %>% 
    bind_rows(res_table) %>% 
    arrange(.data[[var_x]]) %>% 
    select(.data[[var_x]], last_col(), everything())
  
  
  return(chi_inspect_table)
}




multiple_response_binair <- function(data, cols, counted_value) {
  
  data <- data %>% select({{ cols }})
  
  
  # Maak een referentietabel met daarin het label voor elke vraag
  labels <- data %>% 
    names %>% 
    map_df(
      \(i) tibble(labels = attr(data[[i]], "label"), name = i) 
    )
  
  
  # Pas 'tabyl' toe op alle kolommen van de multiple response vraag
  tabel <- data %>% 
    map_df(., ~tabyl(.)) %>% 
    rename('answer' = 1) %>% 
    filter(answer == {{ counted_value }})
  
  
  
  # Voeg de labels toe aan de resultaten
  tabel <- bind_cols(tabel, labels)
  
  return(tabel)
  
}


multiple_response_cat <- function(data, cols){

    data <- data %>% select({{ cols }})
  
    n_cols <- ncol(data)
    
    unique_answers <-  unique(data %>% select({{ cols }}) %>% pull)
    
    unique_answers <- unique_answers[!is.na(unique_answers)]
    
    
    n_respondenten <- nrow(data)
    
    valid_respondenten <- data %>% 
      is.na %>% 
      `!` %>% 
      rowSums >= 1 
    
    valid_respondenten <- sum(valid_respondenten)
    
    
    na_respondenten <- n_respondenten - valid_respondenten
    
    n_valid_antwoorden <- data %>% 
      is.na %>% 
      `!` %>% 
      sum
    
    n_antwoorden <- n_valid_antwoorden + na_respondenten
    
    
    tabel <- data %>%
      pivot_longer(cols = everything(), 
                   names_to = 'question',
                   values_to = 'answer') %>% 
      filter(!is.na(answer)) %>% 
      group_by(answer) %>% 
      summarise(n = n(), 
                percent = n()/n_respondenten, 
                valid_percent = n()/valid_respondenten) 

    tabel_anders <- tabel %>% 
      filter(str_detect(tolower(answer), "^anders"))
    
    tabel_weet_niet <- tabel %>% 
      filter(str_detect(tolower(answer), "^weet niet|^weet ik niet"))
    
    
    
    tabel <- tabel %>%
      filter(!str_detect(tolower(answer), "^anders")) %>% 
      filter(!str_detect(tolower(answer), "^weet niet|^weet ik niet")) %>% 
      arrange(-valid_percent) %>% 
      bind_rows(tabel_anders) %>% 
      bind_rows(tabel_weet_niet) %>% 
      bind_rows(
        tibble(answer = as.character(NA),
                           n = na_respondenten,
                           percent = na_respondenten/n_respondenten,
                           valid_percent = NA)
      )
    
    
    return(tabel)
    
    
}






