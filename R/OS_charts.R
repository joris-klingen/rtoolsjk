get_txt_color_based_on_bg <- function(colors){
  hcl <- farver::decode_colour(colors, "rgb", "hcl")
  txt_color <- ifelse(hcl[, "l"] > 50, "black", "white")
  return(txt_color)
}

os_barchart <- function(data, x, y, labels=F, sort=F, fill_color="#004699"){
  if (sort==T){
    print(data)
    data <- data %>% 
      mutate("{{ x }}" := fct_reorder({{ x }}, {{ y }}))
  }
  
  lbl_color = 
  
  fig <- ggplot(data, aes(x = {{ x }}, y = {{ y }})) + 
    geom_bar(stat = "identity", fill=fill_color)
  
  if (labels==T){
    fig <- fig + 
      geom_text(
        aes(label=round({{ y }} * 100, 0),  hjust = 1.8), 
        color=get_txt_color_based_on_bg(fill_color),
        fontface="bold"
        )
  }
  
  max_y <- data %>% summarise(max = max({{ y }}, na.rm=TRUE)) %>% pull(max)
  fig <- fig + 
    theme_os(orientation="horizontal", drop_axis_titles = T) + 
    scale_y_continuous(
      labels = scales::percent, 
      limits = c(0, max_y * 1.03), 
      ) +
    coord_flip() 
  
  return(fig)
}


os_base_bar <- function(
    data, 
    x, 
    y, 
    color_col, 
    colors, 
    position = "stack",
    invert_legend = F, 
    flip = F
){
  colors <- rev(colors)
  text_color <- get_txt_color_based_on_bg(colors)
  
  fig <- ggplot(
    data, 
    aes(x = {{ x }}, y = {{ y }}, fill = {{ color_col }})
  ) +
    geom_col(width = 0.8, position = position) +
    scale_fill_manual(values=colors) +
    scale_color_manual(values=text_color) +
    guides(fill = guide_legend(reverse = T)) +
    geom_hline(yintercept = 0) +
    theme_os(
      orientation=ifelse(flip == T, "horizontal", "vertical"), drop_axis_titles = T)
  
  return(fig)
}


format_abs <- function(x){
  return(format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE))
}

os_stacked_bar_abs <- function(
    data, 
    x, 
    y, 
    color_col, 
    colors, 
    invert_legend = F, 
    flip = F,
    hide_label_value = 0
){
  fig <- os_base_bar(
    data=data, 
    x = {{ x }}, 
    y = {{ y }}, 
    color_col = {{ color_col }},
    colors = colors, 
    position = "stack",
    invert_legend = invert_legend, 
    flip = flip
  )
  
  label <- data %>% pull({{ y }})
  if (hide_label_value > 0){
    label <- ifelse(label < hide_label_value, "", format_abs(round(label, 0)))
  }
  
  fig <- fig + 
    geom_text(aes(
      label = label,
      color={{ color_col }}),
      position = position_stack(0.5),
      show.legend=FALSE,
      fontface="bold"
    ) + 
    scale_y_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE))
  
  if (flip){
    fig <- fig + coord_flip()
  }
  
  return(fig)
}


os_stacked_bar_perc <- function(
    data, 
    x, 
    y, 
    color_col, 
    colors, 
    invert_legend = F, 
    flip = F,
    hide_label_value = 0
){
  fig <- os_base_bar(
    data=data, 
    x = {{ x }}, 
    y = {{ y }}, 
    color_col = {{ color_col }},
    colors = colors, 
    position = "stack",
    invert_legend = invert_legend, 
    flip = flip
  )
  
  label <- data %>% pull({{ y }})
  if (hide_label_value > 0){
    label <- ifelse(label < hide_label_value, str_trim(""), str_trim(label))
  }
  
  fig <- fig +
    geom_text(aes(
      label = round(label * 100, 0),
      color={{ color_col }}),
      position = position_stack(0.5),
      show.legend=FALSE,
      fontface="bold"
    ) +
    scale_y_continuous(labels = scales::percent, breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1))
  
  if (flip){
    fig <- fig + coord_flip()
  }
  
  return(fig)
}


os_grouped_bar_perc <- function(
    data, 
    x, 
    y, 
    color_col, 
    colors, 
    invert_legend = F, 
    flip = F  
){
  fig <- os_base_bar(
    data=data, 
    x = {{ x }}, 
    y = {{ y }}, 
    color_col = {{ color_col }},
    colors = colors, 
    invert_legend = invert_legend, 
    position = "dodge",
    flip = flip
  )
  
  fig <- fig +
    geom_text(aes(
      label = round(round({{ y }} * 100, 0) , 0),
      color={{ color_col }}),
      position = position_dodge2(0.8),
      hjust = 1.3,
      show.legend = FALSE,
      fontface = "bold"
    ) +
    scale_y_continuous(labels = scales::percent, breaks=c(0, 0.2, 0.4, 0.6, 0.8, 1))
  
  if (flip){
    fig <- fig + coord_flip()
  }
  
  return(fig)
}


os_grouped_bar_abs <- function(
    data, 
    x, 
    y, 
    color_col, 
    colors, 
    invert_legend = F, 
    flip = F,
    label_outside_value = 0
){
  fig <- os_base_bar(
    data=data, 
    x = {{ x }}, 
    y = {{ y }}, 
    color_col = {{ color_col }},
    colors = colors, 
    invert_legend = invert_legend, 
    position = "dodge",
    flip = flip
  )
  
  # Voor het onderstaande blok een betere oplossing zoeken om herhaling te voorkomen
  label <- data %>% pull({{ y }}) %>% round(., 0)
  if (label_outside_value > 0 & flip == T){
    hjust <- ifelse(label < label_outside_value, -0.2, 1.2)
    txt_func <- geom_text(aes(
      label = str_trim(format(label, big.mark = ".", decimal.mark = ",", scientific = FALSE)),
      color = {{ color_col }}),
      position = position_dodge2(0.8),
      hjust = hjust,
      show.legend = FALSE,
      fontface = "bold"
    )
  } else if(label_outside_value > 0 & flip == F) {
    vjust <- ifelse(label < label_outside_value, -0.5, 1.5)
    txt_func <- geom_text(aes(
      label = str_trim(format(label, big.mark = ".", decimal.mark = ",", scientific = FALSE)),
      color = {{ color_col }}),
      position = position_dodge2(0.8),
      vjust = vjust,
      show.legend = FALSE,
      fontface = "bold"
    )
  } else {
    txt_func <- geom_text(aes(
      label = str_trim(format(label, big.mark = ".", decimal.mark = ",", scientific = FALSE)),
      color = {{ color_col }}),
      position = position_dodge2(0.8),
      show.legend = FALSE,
      fontface = "bold"
    )
  }
  
  fig <- fig +
    txt_func +
    scale_y_continuous(labels=function(x) format(x, big.mark = ".", decimal.mark = ",", scientific = FALSE))
  
  if (flip){
    fig <- fig + coord_flip()
  }
  
  return(fig)
}
