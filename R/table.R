# functions for styled excel tables

library(openxlsx)
library(purrr)

# Define styles

rk_get_table_styles <- function(n_digits = 2, font_custom = "calibri"){

  digit_format <- ifelse(n_digits == 0, '0', paste0('0.', paste(rep(0, n_digits), collapse = '')))

  styles <- list(
    "top_row" = createStyle(
      textDecoration = "bold",
      fgFill = "#004699",
      fontColour = "white"
    ),
    "bottom_row" = createStyle(
      border = "Bottom",
      borderStyle = "medium",
      borderColour="#004699"
    ),
    "total_row" = createStyle(
      textDecoration = "bold",
      border = "Bottom",
      borderStyle = "medium",
      fgFill = "#B8BCDD",
      borderColour="#004699"
    ),
    "total_column" = createStyle(
      fgFill = "#B8BCDD",
    ),
    "font" = createStyle(fontSize = 9, fontName = font_custom),
    "l_align" = createStyle(halign = "left"),
    "r_align" = createStyle(halign = "right"),
    "perc" = createStyle(numFmt = paste0(digit_format, '%')),
    "digits" = createStyle(numFmt = digit_format)
  )
  return(styles)
}


rk_sheet <- function(wb,
                     df,
                     sheet_name = "Sheet1",
                     title_height = 14.4,
                     perc_cols_index = NULL,
                     perc_cols_pattern = NULL,
                     left_align_char_cols = TRUE,
                     left_align_index = NULL,
                     round_digits = 2,
                     total_row = FALSE,
                     total_column = FALSE,
                     font_custom = 'calibri'){

  styles <- rk_get_table_styles(n_digits = round_digits,
                             font_custom = font_custom)

  addWorksheet(wb, sheet_name, gridLines = TRUE)
  writeData(wb, sheet_name, df, withFilter = T)

  cols = 1:ncol(df)
  last_col = ncol(df)
  ex_top_r = 2:(nrow(df) + 1)
  bottom_row_nr = nrow(df) + 1

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


  if(total_column == T) {
    addStyle_dflt(style = styles$total_column, rows = ex_top_r, cols = last_col)
  }


  # add blue line at bottom always
  addStyle_dflt(style = styles$bottom_row, rows = bottom_row_nr, cols = cols)


  if(total_row == T) {
    addStyle_dflt(style = styles$total_row, rows = bottom_row_nr, cols = cols)

  }


  # Set column width to 1.5 times the amount of chars
  setColWidths(wb, sheet_name, cols, widths = nchar(names(df)) + 4)

}

rk_get_df_as_list <- function(df_or_list, sheet_name){

  if(is.data.frame(df_or_list)){
    named_list <- list()
    named_list[[sheet_name]] = df_or_list

  } else {
    named_list <- df_or_list
  }

  return(named_list)

}


rk_table <- function(df_or_list,
                     path,
                     sheet_name = "Sheet1",
                     title_height = 14.4,
                     perc_cols_index = NULL,
                     perc_cols_pattern = NULL,
                     left_align_char_cols = TRUE,
                     left_align_index = NULL,
                     round_digits = 0,
                     overwrite = T,
                     total_row = F,
                     total_column = FALSE,
                     font_custom = 'calibri') {

  # Converts data to an Excel file with styled tables.
  # When given a list, creates multiple sheets.
  # Uses rk_sheet() for sheet formatting.
  #
  # df_or_list            : list(names = dataframes) or df. List names become sheet names
  # path                  : str, output file path
  # sheet_name            : str, sheet name when df is input
  # title_height          : num, title row height in pt
  # perc_cols_pattern     : str, regex pattern for percentage columns e.g. 'share_'
  # perc_cols_index       : num vector, column indices of percentage columns e.g. c(3, 4, 7)
  # left_align_char_cols  : bool, left-align all character columns
  # left_align_index      : num vector, column indices to left-align
  # round_digits          : int, digits for rounding display (formatting only, data preserved)
  # overwrite             : bool, overwrite existing file
  # total_row             : bool, apply total row styling to last row?
  # total_column          : bool, apply total column styling to last column?
  # font_custom           : str, font choice, default 'calibri'



  wb <- createWorkbook()

  named_list <- rk_get_df_as_list(df_or_list, sheet_name = sheet_name)

  for (name in names(named_list)){
    df <- named_list[[name]]

    rk_sheet(wb = wb,
             df = df,
             sheet_name = name,
             title_height = title_height,
             perc_cols_index = perc_cols_index,
             perc_cols_pattern = perc_cols_pattern,
             left_align_char_cols = left_align_char_cols,
             left_align_index = left_align_index,
             round_digits = round_digits,
             total_row = total_row,
             total_column = total_column,
             font_custom = font_custom
             )

  }

  saveWorkbook(wb, path, overwrite = overwrite)


}
