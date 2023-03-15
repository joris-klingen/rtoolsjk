theme_ois <- function(legend_position = "bottom"){
  
  grDevices::windowsFonts("Corbel" = grDevices::windowsFont("Corbel"))
  font <- "Corbel"
  
  
  ggplot2::theme_bw() +
    ggplot2::theme(
      axis.text = ggplot2::element_text(family = font, size = 13),
      plot.caption = ggplot2::element_text(family = font, size = 14),
      axis.title = ggplot2::element_text(family = font, hjust = 1, size = 13),
      plot.subtitle = ggplot2::element_text(family = font, size = 15),
      legend.text = ggplot2::element_text(family = font, size = 12),
      plot.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 15),
      # legend.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 13),
      panel.grid.minor = ggplot2::element_blank(),
      strip.background = ggplot2::element_blank(),
      panel.grid.major.x = element_blank(),
      legend.title=element_blank(),
      axis.ticks.y = element_blank(),
      axis.ticks.x = element_blank(),
      legend.position=legend_position,
      panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.text = ggplot2::element_text(color = "black", family = font, face = "bold", size = 15)
    ) 
  
  
}



theme_ois_map <- function(legend_position = c(0, 0)){
  
  grDevices::windowsFonts("Corbel" = grDevices::windowsFont("Corbel"))
  font <- "Corbel"
  
  
  ggplot2::theme_bw() +
    ggplot2::theme(
      axis.line = element_blank(), 
      axis.text = element_blank(), 
      axis.ticks = element_blank(), 
      axis.title = element_blank(), 
      panel.background = element_blank(), 
      panel.grid = element_blank(), panel.spacing = unit(0, "lines"), plot.background = element_blank(), 
      legend.justification = c(0, 0), legend.position = legend_position,
      plot.caption = ggplot2::element_text(family = font, size = 14),
      plot.subtitle = ggplot2::element_text(family = font, size = 15),
      legend.text = ggplot2::element_text(family = font, size = 12),
      plot.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 15),
      legend.title = ggplot2::element_text(family = font, lineheight = 1.2, size = 13),
      panel.border = ggplot2::element_rect(fill = "transparent", color = NA),
      strip.text = ggplot2::element_text(color = "black", family = font, face = "bold", size = 15)
    ) 
  
  
}

