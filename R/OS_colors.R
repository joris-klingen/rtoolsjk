library(tidyverse)
library(jsonlite)

# Lijst met color palettes
palettes_list <- list(
  `wild` = c("#004699", "#009de6", "#53b361", "#bed200", "#ffe600", "#ff9100", "#ec0000"),
  
  `blauw` = c("#004699", "#3858a4", "#566bb0", "#707ebb", "#8992c6", "#a1a7d2", "#b8bcdd", "#d0d2e8", "#e7e8f4"),
  
  `paars` = c("#a00078", "#ad3486", "#b95195", "#c46ba3", "#cf84b2", "#da9dc1", "#e4b5d0", "#eecee0", "#f7e6ef"),
  
  `stoplicht` = c("#ec0000", "#f27d14", "#f6bd57", "#fff3a7", "#cdde87", "#96c86f", "#53b361"), 
  
  `fruitig`  = c("#a00078", "#e50082", "#009dec", "#fb9bbe", "#d48fb9", "#a4ccf3", "#ffd8e5", "#efd2e3", "#dceafa"),
  
  `waterkant` = c("#004699", "#4f65ad", "#949ccc", "#53b361", "#98d09b", "#d6ecd6", "#bed200", "#e4e894", "#f6f6d4"),
  
  `zonsondergang` = c("#004699", "#3f5aa2", "#7c84b2", "#a2bad3", "#71abdd", "#009dec", "#ffe600", "#ffbc00", "#ff9100")
)

# # work in progress, onderstaande gebruiken op basis van aantal
# palettes_list <- read_json('https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/references/OS_colors.json')


# Functie om kleuren te interpoleren
os_palettes <- function(palette = "wild", reverse = FALSE, add_other = FALSE, ...) {
  
  pal <- palettes_list[[palette]]
  if (add_other) pal <- c(palettes_list[[palette]], '#e6e6e6')
  if (reverse) pal <- rev(pal)
  colorRampPalette(pal, ...)
  
}


# Functie om kleur te veranderen
scale_color_os <- function(palette = "wild", discrete = TRUE, reverse = FALSE, add_other = FALSE, ...) {
  
  pal <- os_palettes(palette = palette, reverse = reverse, add_other = add_other)
  
  if (discrete) {
    discrete_scale("colour", paste0("os_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}

# Functie om fill te veranderen
scale_fill_os <- function(palette = "wild", discrete = TRUE, reverse = FALSE, add_other = FALSE,...) {
  
  pal <- os_palettes(palette = palette, reverse = reverse, add_other = add_other)
  
  if (discrete) {
    discrete_scale("fill", paste0("os_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}


get_os_colors <- function(type, kleur, aantal, invert = FALSE){
  # type (str): type of (oplopend, uiteenlopend, discreet)
  # kleur (str):
  #   oplopend:
  #   'blauw' |
  #   'paars' |
  #   'groen' |
  #   'roze' |
  #   'lichtblauw' |
  #   'oranje' |
  #   'lichtgroen' |
  #   'grijs'
  # uiteenlopend:
  #   'stoplicht (1-7)' |
  #   'blauw - grijs - groen (1-9)' |
  #   'paars - grijs - lichtblauw (1-9)' |
  #   'blauw - geel - groen (1-9)' |
  #   'rood - geel - lichtblauw (1-9)'
  # discreet:
  #   'discreet (1-9)' |
  #   'fruitig (1-9)' |
  #   'fruitig (1-9, anders gesorteerd)' |
  #   'waterkant (1-9)' |
  #   'waterkant (1-9, anders gesorteerd)' |
  #   'zonsondergang (1-9)'
  # aantal (str): number of colors returned
  # invert (bool, optional): invert colors. Defaults to False.
  
  
  if (!(type %in% c("oplopend", "uiteenlopend", "discreet"))){
    rlang::abort("Type should be `oplopend`, `uiteenlopend` or `discreet`")
  }
  
  
  url = "https://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/references/OS_colors.json"
  colors = fromJSON(url)
  
  colors = colors[[type]][[kleur]][[aantal]]
  
  if (invert){
    colors = rev(colors)
  }
  
  colors
}


