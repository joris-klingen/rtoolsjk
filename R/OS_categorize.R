os_cut <- function(x, 
                   breaks = NULL, # numerieke vector bijv c(0, 20, 40, 100)
                   start_label = 'lager dan ',
                   end_label = ' en hoger',
                   sep = ' - ',
                   prefix = '',
                   suffix = '',
                   ordered = T,
                   start_label_overwrite = NULL,
                   end_label_overwrite = NULL){

  # 
  #
  # 
  #
  #
  #
  #
  #
  
  n_labels <- length(breaks) - 1
  
  start <- paste0(start_label, prefix, breaks[2], suffix)
  
  end <- paste0(prefix, breaks[n_labels], suffix, end_label)
  
  midden <- c()
  
  for(i in 2:(n_labels - 1) ) {
    
    midden_add <- paste0(
      prefix, breaks[i], suffix, 
      sep,
      prefix, breaks[i + 1], suffix
    ) 
    
    
    # append
    midden <- c(midden, midden_add)
    
  }
  
  if(n_labels > 2){
    labels_manual <- c(start, midden, end)
  }else{
    labels_manual <- c(start, end)
  }
  
  
  cat('start: ', start, '\n', 
      'midden: ', midden, '\n', 
      'end: ', end, '\n')
  cat('\n')

  if(!is.null(end_label_overwrite)){
    labels_manual[n_labels] <- end_label_overwrite
  }
  
  if(!is.null(start_label_overwrite)){
    labels_manual[1] <- start_label_overwrite
  }
  
  
  cats <- cut(x, 
              breaks,
              labels = labels_manual,
              ordered_result = ordered,
              include.lowest = T
  )
  
  return(cats)
  
} 



