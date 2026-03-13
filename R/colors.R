library(tidyverse)
library(jsonlite)

# color palettes
palettes_list <- list(
  `wild` = c("#004699", "#009de6", "#53b361", "#bed200", "#ffe600", "#ff9100", "#ec0000"),

  `blue` = c("#004699", "#3858a4", "#566bb0", "#707ebb", "#8992c6", "#a1a7d2", "#b8bcdd", "#d0d2e8", "#e7e8f4"),

  `purple` = c("#a00078", "#ad3486", "#b95195", "#c46ba3", "#cf84b2", "#da9dc1", "#e4b5d0", "#eecee0", "#f7e6ef"),

  `traffic_light` = c("#ec0000", "#f27d14", "#f6bd57", "#fff3a7", "#cdde87", "#96c86f", "#53b361"),

  `fruity`  = c("#a00078", "#e50082", "#009dec", "#fb9bbe", "#d48fb9", "#a4ccf3", "#ffd8e5", "#efd2e3", "#dceafa"),

  `waterfront` = c("#004699", "#4f65ad", "#949ccc", "#53b361", "#98d09b", "#d6ecd6", "#bed200", "#e4e894", "#f6f6d4"),

  `sunset` = c("#004699", "#3f5aa2", "#7c84b2", "#a2bad3", "#71abdd", "#009dec", "#ffe600", "#ffbc00", "#ff9100")
)


# interpolate colors from palette
rk_palettes <- function(palette = "wild", reverse = FALSE, add_other = FALSE, ...) {

  pal <- palettes_list[[palette]]
  if (add_other) pal <- c(palettes_list[[palette]], '#e6e6e6')
  if (reverse) pal <- rev(pal)
  colorRampPalette(pal, ...)

}


# custom color scale
rk_scale_color <- function(palette = "wild", discrete = TRUE, reverse = FALSE, add_other = FALSE, ...) {

  pal <- rk_palettes(palette = palette, reverse = reverse, add_other = add_other)

  if (discrete) {
    discrete_scale("colour", paste0("rk_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}

# custom fill scale
rk_scale_fill <- function(palette = "wild", discrete = TRUE, reverse = FALSE, add_other = FALSE,...) {

  pal <- rk_palettes(palette = palette, reverse = reverse, add_other = add_other)

  if (discrete) {
    discrete_scale("fill", paste0("rk_", palette), palette = pal, ...)
  } else {
    scale_color_gradientn(colours = pal(256), ...)
  }
}


rk_get_colors <- function(type, color, n, invert = FALSE){
  # type (str): "sequential", "diverging", or "discrete"
  # color (str): name of the color palette (use Dutch keys from colors.json)
  # n (str): number of colors returned
  # invert (bool): reverse color order. Defaults to FALSE.

  # map English type names to JSON keys
  type_map <- c(sequential = "oplopend", diverging = "uiteenlopend", discrete = "discreet")

  if (!(type %in% names(type_map))){
    rlang::abort("Type should be `sequential`, `diverging` or `discrete`")
  }

  json_type <- type_map[[type]]

  url = "references/colors.json"
  colors = fromJSON(url)

  colors = colors[[json_type]][[color]][[n]]

  if (invert){
    colors = rev(colors)
  }

  colors
}
