rk_cut <- function(x,
                   breaks = NULL,
                   start_label = 'less than ',
                   end_label = ' and above',
                   sep = ' - ',
                   prefix = '',
                   suffix = '',
                   ordered = T,
                   start_label_overwrite = NULL,
                   end_label_overwrite = NULL){

  # Converts a continuous variable to a categorical variable with labels.
  # Returns an (ordered) factor with labeled levels.
  #
  # x                     : numeric vector, continuous variable
  # breaks                : numeric vector, breakpoints including min and max
  # start_label           : str, label before the number in the first category
  # end_label             : str, label after the number in the last category
  # sep                   : str, separator between numbers in other categories
  # prefix                : str, prefix for each number, e.g. '$'
  # suffix                : str, suffix for each number, e.g. '%'
  # ordered               : bool, whether output factor should be ordered
  # start_label_overwrite : str, override name for first category
  # end_label_overwrite   : str, override name for last category

  n_labels <- length(breaks) - 1

  start <- paste0(start_label, prefix, breaks[2], suffix)

  end <- paste0(prefix, breaks[n_labels], suffix, end_label)

  middle <- c()

  for(i in 2:(n_labels - 1) ) {

    middle_add <- paste0(
      prefix, breaks[i], suffix,
      sep,
      prefix, breaks[i + 1], suffix
    )

    middle <- c(middle, middle_add)

  }

  if(n_labels > 2){
    labels_manual <- c(start, middle, end)
  }else{
    labels_manual <- c(start, end)
  }


  cat('start: ', start, '\n',
      'middle: ', middle, '\n',
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
