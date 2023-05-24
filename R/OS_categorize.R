os_cut <- function(x, 
                   breaks = NULL, 
                   start_label = 'lager dan ',
                   end_label = ' en hoger',
                   sep = ' - ',
                   prefix = '',
                   suffix = '',
                   ordered = T,
                   start_label_overwrite = NULL,
                   end_label_overwrite = NULL){
  
  n_labels <- length(breaks)
  
  start <- paste0(start_label, prefix, breaks[2], suffix)
  
  end <- paste0(prefix, breaks[n_labels-1], suffix, end_label)
  
  midden <- c()
  
  for(i in 2:(n_labels - 3)) {
    midden_add <- paste0(
      prefix, breaks[i], suffix, 
      sep,
      prefix, breaks[i + 1], suffix
    ) 
    
    # append
    midden <- c(midden, midden_add)
    
  }
  
  labels_manual <- c(start, midden, end)
  
  if(!is.null(end_label_overwrite)){
    labels_manual[length(labels_manual)] <- end_label_overwrite
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