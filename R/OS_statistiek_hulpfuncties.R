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



get_valid_responses <- function(data) {
  
  df_valid <- data %>% 
    filter(rowSums(!is.na(.)) >= 1) 
  
  
  return(df_valid)
  
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
  
  
  tabel <- tabel %>% 
    os_order_labels(add_custom = c('geen zin', 'niemand weet het'))
    
    
  # Sorteren van antwoorden op volgorde van grootte
  single_labels <- c("anders, namelijk",
                     "weet ik niet, geen antwoord",
                     "weet ik niet",
                     "weet niet",
                     "geen antwoord",
                     "weet niet, geen antwoord",
                     "niet ingevuld",
                     "weet niet / geen antwoord",
                     "weet ik niet / geen antwoord",
                     "nee, ",
                     "met iemand anders, namelijk")
  
  tabel_multi <- tabel %>% 
    filter(!labels %in% single_labels) %>% 
    arrange(desc(percent))
  
  tabel_single <- tabel %>% 
    filter(labels %in% single_labels)
  
  tabel <- tabel_multi %>% 
    bind_rows(tabel_single)
  
  
  
  return(tabel)
  

  
  
}


multiple_response_cat <- function(data, 
                                  cols, 
                                  end_cats = NULL){
  
  data <- data %>% select({{ cols }})
  
  n_resps_total <- nrow(data)
  
  n_valid_resps <- nrow(get_valid_responses(df_valid))
  
  table <- data %>%
    pivot_longer(cols = everything(), 
                 names_to = 'question',
                 values_to = 'answer') %>% 
    filter(!is.na(answer)) %>% 
    group_by(answer) %>% 
    summarise(n = n(), 
              percent = n()/n_resps_total, 
              valid_percent = n()/n_valid_resps) %>% 
    mutate(answer = fct_reorder(answer, -valid_percent)) %>% 
    arrange(answer)
  
  
  if(!is.null(end_cats)) {
    table <- table %>%
      mutate(answer = fct_relevel(answer, end_cats, after = Inf)) %>% 
      arrange(answer)
  }
  
  
  # add row for respondants that did not answer this question
  n_resps_na <- n_resps_total - n_valid_resps
  
  table <- table %>%   
    bind_rows(
      tibble(answer = as.character(NA),
             n = n_resps_na,
             percent = n_resps_na/n_resps_total,
             valid_percent = NA)
    )
  
  return(table)
  
}





