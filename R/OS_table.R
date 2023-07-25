# dit script bevat algemeen bruikbare functies voor huisstijl van tabellen
# wordt beheerd door Joris (j.klingen@amsterdam.nl) en Daan (d.schmitz@amsterdam.nl)
# vul gerust aan

# Last update: 05-06-2022

library(openxlsx)
library(purrr)

# Define styles

get_table_styles <- function(n_digits = 2){
  
  digit_format <- ifelse(n_digits == 0, '0', paste0('0.', paste(rep(0, n_digits), collapse = '')))
  
  styles <- list(
    "top_row" = createStyle(
      textDecoration = "bold",
      fgFill = "#00a0e6",
      fontColour = "white"
    ),
    "bottom_row" = createStyle(
      textDecoration = "bold",
      border = "Bottom",
      borderStyle = "thick",
      fgFill = "#B1D9F5",
      borderColour="#00a0e6"
    ),
    "font" = createStyle(fontSize = 9, fontName = "corbel"),
    "l_align" = createStyle(halign = "left"),
    "r_align" = createStyle(halign = "right"),
    "perc" = createStyle(numFmt = paste0(digit_format, '%')), 
    "digits" = createStyle(numFmt = digit_format)
  )
  return(styles)
}


os_sheet <- function(wb, 
                     df, 
                     sheet_name = "Sheet1", 
                     title_height = 14.4,
                     perc_cols_index = NULL,
                     perc_cols_pattern = NULL,
                     left_align_char_cols = TRUE,
                     left_align_index = NULL, 
                     round_digits = 2){
  
  styles <- get_table_styles(n_digits = round_digits)
  
  addWorksheet(wb, sheet_name, gridLines = TRUE)
  writeData(wb, sheet_name, df, withFilter = T)
  
  cols = 1:ncol(df)
  ex_top_r = 2:(nrow(df)+1)
  
  # Fix some parameters to prevent repetition of these "default" parameters
  addStyle_dflt <- partial(addStyle, wb = wb, sheet = sheet_name, stack = TRUE)
  addStyle_dflt_grd <- partial(addStyle_dflt, gridExpand = TRUE)
  
  # Add styles
  addStyle_dflt(style = styles$top_row, rows = 1, cols = cols)
  addStyle_dflt_grd(style = styles$font, rows = 1:(nrow(df)+1), cols = cols)
  addStyle_dflt_grd(style = styles$l_align, rows = 1, cols = cols)
  addStyle_dflt_grd(style = styles$r_align, rows = ex_top_r, cols = cols)
  
  num_cols <- grep('numeric', lapply(df, class))
  addStyle_dflt_grd(style = styles$digits, rows = ex_top_r, cols = num_cols)
  
  
  setRowHeights(wb = wb, sheet = sheet_name, rows = 1, heights = title_height)
  
  if(!is.null(perc_cols_pattern)){
    left_cols_pat <- str_which(names(df), perc_cols_pattern) 
    addStyle_dflt_grd(style = styles$perc, rows = ex_top_r, cols = left_cols_pat)
  }
  
  
  if(!is.null(perc_cols_index)){
    addStyle_dflt_grd(style = styles$perc, rows = ex_top_r, cols = perc_cols_index)
  }
  
  
  
  # default left align char cols
  if(left_align_char_cols){
    
    char_cols <- grep('factor|character', lapply(df, class))
    
    addStyle_dflt_grd(style = styles$l_align, rows = ex_top_r, cols = char_cols)
  }
  
  if(!is.null(left_align_index)){
    addStyle_dflt_grd(style = styles$l_align, rows = ex_top_r, cols = left_align_index)
  }
  
  
  # Set column width to 1.5 times the amount of chars
  setColWidths(wb, sheet_name, cols, widths = nchar(names(df)) + 4)
  
}

get_df_as_list <- function(df_or_list, sheet_name){
  
  if(is.data.frame(df_or_list)){
    named_list <- list()
    named_list[[sheet_name]] = df_or_list
    
  } else {
    named_list <- df_or_list
  }               
  
  return(named_list)
  
}


os_table <- function(df_or_list, 
                     path, 
                     sheet_name = "Sheet1", 
                     title_height = 14.4,
                     perc_cols_index = NULL,
                     perc_cols_pattern = NULL,
                     left_align_char_cols = TRUE,
                     left_align_index = NULL, 
                     round_digits = 2,
                     overwrite = T) {
  
  wb <- createWorkbook()
                    
  named_list <- get_df_as_list(df_or_list, sheet_name = sheet_name)

  for (name in names(named_list)){
    df <- named_list[[name]]
    
    os_sheet(wb = wb, 
             df = df, 
             sheet_name = name, 
             title_height = title_height,
             perc_cols_index = perc_cols_index,
             perc_cols_pattern = perc_cols_pattern,
             left_align_char_cols = left_align_char_cols,
             left_align_index = left_align_index,
             round_digits = round_digits
             )
    
  }
  
  saveWorkbook(wb, path, overwrite = overwrite)
  
  
}





style_sheet <- function(wb, df, sheet_name, add_perc_to_cols, left_align_cols){
  styles <- get_table_styles()
  addWorksheet(wb, sheet_name, gridLines = TRUE)
  writeData(wb, sheet_name, df, withFilter = T)
  
  cols = 1:ncol(df)
  ex_top_r = 2:(nrow(df)+1)
  
  # Fix some parameters to prevent repetition of these "default" parameters
  addStyle_dflt <- partial(addStyle, wb = wb, sheet = sheet_name, stack = TRUE)
  addStyle_dflt_grd <- partial(addStyle_dflt, gridExpand = TRUE)
  
  # Add styles
  addStyle_dflt(style = styles$top_row, rows = 1, cols = cols)
  addStyle_dflt_grd(style = styles$font, rows = 1:(nrow(df)+1), cols = cols)
  addStyle_dflt_grd(style = styles$l_align, rows = 1, cols = cols)
  addStyle_dflt_grd(style = styles$r_align, rows = ex_top_r, cols = cols)
  
  if(!is.null(add_perc_to_cols)){
    addStyle_dflt_grd(style = styles$perc, rows = ex_top_r, cols = add_perc_to_cols)
  }
  
  
  # left align char cols
  char_cols <- unname(which(sapply(df, function(x) is.character(x)|is.factor(x) )))
  addStyle_dflt_grd(style = styles$l_align, rows = ex_top_r, cols = left_align_cols)
  
  # overwrite left align based on index
  if(!is.null(left_align_cols)){
    addStyle_dflt_grd(style = styles$l_align, rows = ex_top_r, cols = left_align_cols)
  }
  
  # Set column width to 1.5 times the amount of chars
  setColWidths(wb, sheet_name, cols, widths = nchar(names(df)) + 4)
}




# let op, deze is kopie van os_table_list voor backward comp, vervalt op termijn
write_named_list_with_styling <- function(named_list, path, overwrite = T){
  wb <- createWorkbook()
  styles <- get_table_styles()
  
  for (name in names(named_list)){
    df <- named_list[[name]]
    style_sheet(wb, df, name, NULL, NULL)
  }
  
  saveWorkbook(wb, path, overwrite = overwrite)
}



  

