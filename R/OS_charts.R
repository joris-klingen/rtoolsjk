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
  
  fig <- ggplot(data, aes(x = {{ x }}, y = {{ y }})) + 
    geom_bar(stat = "identity", fill=fill_color)
  
  if (labels==T){
    fig <- fig + geom_text(aes(label=round({{ y }} * 100, 0),  hjust = -0.5))
  }
  
  max_y <- data %>% summarise(max = max({{ y }}, na.rm=TRUE)) %>% pull(max)
  fig <- fig + 
    theme_os(orientation="horizontal") + 
    scale_y_continuous(labels = scales::percent, limits = c(0, max_y * 1.03)) +
    coord_flip()
  
  return(fig)
}


os_stacked_barchart <- function(data, x, y, color_col, colors, flip = F){
  text_color <- get_txt_color_based_on_bg(colors)
  
  fig <- ggplot(
    data, 
    aes(x = {{ x }}, y = {{ y }}, fill = {{ color_col }})
  ) +
    geom_col() +
    geom_text(aes(
      label = scales::percent({{ y }}, 2),
      color={{ color_col }}),
      position = position_stack(0.5),
      show.legend=FALSE
    ) +
    scale_fill_manual(values=colors) +
    scale_color_manual(values=text_color) +
    scale_y_continuous(labels = scales::percent) +
    guides(fill = guide_legend(reverse = TRUE)) +
    theme_os(orientation=ifelse(flip == T, "horizontal", "vertical"))
  
  if (flip){
    fig <- fig + coord_flip()
  }
  
  return(fig)
}