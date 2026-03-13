library(rlang)


if(!exists("rkit")) {

  # create rkit environment
  rkit <- new.env(parent=globalenv())

  local_files <- c(
    'table.R',
    'lookups.R',
    'ggtheme.R',
    'geolocate.R',
    'get_geoms.R',
    'categorize.R',
    'charts.R',
    'colors.R'
  )

  for (f in local_files) {
    source(file.path('R', f), local = rkit)
  }

  # activate
  attach(rkit)

}

rk_show_functions <- function(env = rkit) {
  print(names(env))
  cat(paste("Functions in rkit: "))
  cat(paste(names(env), collapse = " \n "))
}


# print
cat(' Functions from rkit loaded... \n',
    '\n',
    '...to show all functions: rk_show_functions()')
