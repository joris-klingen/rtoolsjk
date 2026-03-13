categorize_cut <- function(x, 
                   breaks = NULL, # numerieke vector bijv c(0, 20, 40, 100)
                   start_label = 'lager dan ',
                   end_label = ' en hoger',
                   sep = ' - ',
                   prefix = '',
                   suffix = '',
                   ordered = T,
                   start_label_overwrite = NULL,
                   end_label_overwrite = NULL){

  # Converteert gegeven continue variabele naar een categorische variabele met labels. Output: (ordered) factor met labeled levels
  #
  # x                     : vector van num of int, gegeven continue variabele.
  # breaks                : vector van num, breekpunten: plekken waar de continue schaal wordt opgeknipt, incl min en max
  # start_label           : str, label vóór het getal in de eerste categorie, default 'lager dan '
  # end_label             : str, label na het getal in de laatste categorie, default ' en hoger'
  # sep                   : str, label tussen de getallen in de overige categorieën, default ' - '
  # prefix                : str, prefix voor elk getal in de categorielabels, bijv. '€', default ''
  # suffix                : str, suffix voor elk getal in de categorielabels, bijv. '%', default ''
  # ordered               : bool, geef aan of output factor ordered moet zijn, default T
  # start_label_overwrite : str, geef de eerste categorie een andere naam, default NULL
  # end_label_overwrite   : str, geef de laatste categorie een andere naam, default NULL
  
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



