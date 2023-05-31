# dit script bevat algemeen bruikbare functies voor huisstijl van tabellen
# wordt beheerd door Joris (j.klingen@amsterdam.nl) en Daan (d.schmitz@amsterdam.nl)
# vul gerust aan

# Last update: 31-08-2022

library(openxlsx)
library(purrr)

# Define styles

get_table_styles <- function(){
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
    "perc" = createStyle(numFmt = "0.00%")
  )
  return(styles)
}


os_table <- function(df, 
                     path, 
                     sheet_name = "Sheet1", 
                     perc_cols_index = NULL,
                     perc_cols_pattern = NULL,
                     left_align_char_cols = TRUE,
                     left_align_index = NULL){
  
  wb <- createWorkbook()
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
  
  
  if(!is.null(perc_cols_pattern)){
    left_cols_pat <- str_which(names(df), perc_cols_pattern) 
    addStyle_dflt_grd(style = styles$perc, rows = ex_top_r, cols = left_cols_pat)
  }
  
  
  if(!is.null(perc_cols_index)){
    addStyle_dflt_grd(style = styles$perc, rows = ex_top_r, cols = perc_cols_index)
  }
  
  
  
  # default left align char cols
  if(left_align_char_cols){
    char_cols <- unname(which(sapply(df, function(x) is.character(x)|is.factor(x) )))
    addStyle_dflt_grd(style = styles$l_align, rows = ex_top_r, cols = char_cols)
  }
  
  if(!is.null(left_align_index)){
    addStyle_dflt_grd(style = styles$l_align, rows = ex_top_r, cols = left_align_index)
  }
  
  
  # Set column width to 1.5 times the amount of chars
  setColWidths(wb, sheet_name, cols, widths = nchar(names(df)) + 4)
  saveWorkbook(wb, path, overwrite=TRUE)
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


write_named_list_with_styling <- function(named_list, path){
  wb <- createWorkbook()
  styles <- get_table_styles()
  
  for (name in names(named_list)){
    df <- named_list[[name]]
    style_sheet(wb, df, name, NULL, NULL)
  }
  
  saveWorkbook(wb, path)
}



  

