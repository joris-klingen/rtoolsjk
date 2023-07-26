library(rlang)

# create os environment
os_tools <- new.env(parent=globalenv())

source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_db_configs.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_table.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_lookups.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_ggtheme.R', local = os_tools)

# oude versie
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OIS_ggtheme.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_statistiek_hulpfuncties.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_geolocate.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_get_geoms.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_vacature_tools.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_categorize.R', local = os_tools)
source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_charts.R', local = os_tools)

source('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/OS_colors.R', local = os_tools)


# activate


if(!exists("os_tools")) {
  attach(os_tools)
}

os_show_functions <- function(env = os_tools) {
  print(names(env))
  
  cat(paste("Functions in OS tools: "))

  cat(paste(names(env), collapse = " \n "))
}


# print
cat(' Functions from Tools Onderzoek en Statistiek loaded... \n',
    '\n',
    '...to show all functions: os_show_functions()')




