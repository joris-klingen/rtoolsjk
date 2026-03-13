library(rlang)


if(!exists("rtools")) {

  # create rtools environment
  rtools <- new.env(parent=globalenv())

  # source all R files locally
  rtools_dir <- file.path(dirname(sys.frame(1)$ofile %||% "."), ".")

  local_files <- c(
    'db_configs.R',
    'table.R',
    'lookups.R',
    'ggtheme.R',
    'statistiek_hulpfuncties.R',
    'geolocate.R',
    'get_geoms.R',
    'vacature_tools.R',
    'categorize.R',
    'charts.R',
    'colors.R'
  )

  for (f in local_files) {
    source(file.path('R', f), local = rtools)
  }

  # activate
  attach(rtools)

}

# attach(rtools)

show_functions <- function(env = rtools) {
  print(names(env))

  cat(paste("Functions in rtools: "))

  cat(paste(names(env), collapse = " \n "))
}


# print
cat(' Functions from rtoolsjk loaded... \n',
    '\n',
    '...to show all functions: show_functions()')



