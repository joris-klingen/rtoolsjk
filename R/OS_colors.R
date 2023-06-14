source('http://gitlab.com/os-amsterdam/tools-onderzoek-en-statistiek/-/raw/main/R/load_all.R')

# Lijst met color palettes
os_palettes <- list(
  `wild` = c("#004699", "#009de6", "#53b361", "#bed200", "#ffe600", "#ff9100", "#ec0000"),
  
  `blauw` = c("#004699", "#3858a4", "#566bb0", "#707ebb", "#8992c6", "#a1a7d2", "#b8bcdd", "#d0d2e8", "#e7e8f4"),
  
  `roze` = c("#e50082", "#fb9cbe"),
  
  `stoplicht` = c("#ec0000", "#f27d14", "#f6bd57", "#fff3a7", "#cdde87", "#96c86f", "#53b361")
  
)

# Functie om kleuren te interpoleren
get_os_palettes <- function(palette = "wild", reverse = FALSE, ...) {
  
  pal <- os_palettes[[palette]]
  
  if (reverse) pal <- rev(pal)
  
  colorRampPalette(pal, ...)
  
}

get_os_palettes('roze')(3)

#
# Functie om kleur te veranderen
scale_color_os <- function(palette = "wild", discrete = TRUE, reverse = FALSE, ...) {
  
  pal <- get_os_palettes(palette = palette, reverse = reverse)
  
  if (discrete) {
    
    discrete_scale("colour", paste0("os_", palette), palette = pal, ...)
    
  } else {
    
    scale_color_gradientn(colours = pal(256), ...)
    
  }
  
}

# Functie om fill te veranderen
scale_fill_os <- function(palette = "wild", discrete = TRUE, reverse = FALSE, ...) {
  
  pal <- get_os_palettes(palette = palette, reverse = reverse)
  
  if (discrete) {
    
    discrete_scale("fill", paste0("os_", palette), palette = pal, ...)
    
  } else {
    
    scale_color_gradientn(colours = pal(256), ...)
    
  }
  
}

ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Species)) +
  geom_point(size = 4) +
  theme_os() +
  scale_color_os()

ggplot(iris, aes(Sepal.Width, Sepal.Length, color = Sepal.Length)) +
  geom_point(size = 4, alpha = .6) +
  theme_os() +
  scale_color_os(discrete = FALSE, palette = "roze")
