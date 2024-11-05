
scaletime <- function(d, id, unit, year, group, method = "weighted", k = 10, min = NULL, max = NULL, subset = NULL, set = NULL, rm_ego = NULL, 
                      graph = TRUE, colour_axis = TRUE, title = "Production over time", x_title = "Year", size_label = "Nb of publications", 
                      ego_level = unit, caption = T, author = "", source = Sys.Date()){
  
  id <- enquo(id)
  unit <- enquo(unit)
  year <- enquo(year)
  group <- enquo(group)
  set <- enquo(set) 
  ego_level <- enquo(ego_level) 
  
  library(cowplot)
  
  d <- d %>%
    mutate((!!year) := as.numeric(!!year))
  
  
  if (method == "weighted") {
    
    #### Option 1: comptage normalisé
    
    tab <-    d %>% 
      distinct(!!id, !!unit, .keep_all = T) %>%
      group_by(!!id) %>% 
      mutate(c = 1/n_distinct(!!unit)) %>% 
      ungroup() %>%
      group_by(!!unit) %>%
      mutate(n = sum(c)) %>%
      arrange(-n) %>% 
      ungroup() 
    
  }
  
  if (method == "complete") {
    
    #### Option 2: comptage complet
    
    tab <-    d %>% 
      distinct(!!id, !!unit, .keep_all = T) %>%
      group_by(!!id, !!unit) %>% 
      mutate(c = 1) %>%   
      group_by(!!unit) %>% 
      mutate(n = n_distinct(!!id)) %>%
      arrange(-n) %>% 
      ungroup()
    
  }
  
  if (! is.null(subset)) {
    
    tab <- tab %>%
      filter(!!set %in% subset)
    
  }
  
  if ( ! is.null(rm_ego)) {
    
    top <- tab %>%
      filter(! (!!ego_level) %in% rm_ego)
    
  }
  
  else {
    
    top <- tab
    
  }
  
  k <- min(k, nrow(tab))
  
  top <- top %>% 
    arrange(-n) %>%
    distinct(!!unit, n) %>%
    slice_head(n = k) 
  
  tab <-    tab %>% 
    right_join(select(top, !!unit)) %>% 
    select(!!id, !!unit, !!year, !!group, c) %>%
    group_by(!!unit) %>% 
    mutate(n = sum(c)) %>%
    arrange(desc(n), desc(!!year)) %>% 
    select(-n)
  
  
  lev <- select(top, !!unit) %>% pull()
  
  tab2 <- dplyr::group_by(tab, !!unit, !!year) %>%
    dplyr::summarise(freq = sum(c), !!group := factor(!!group)) %>% 
    distinct() %>%
    mutate(!!unit := factor(!!unit, levels = lev)) %>%
    as.data.frame()
  
  
  if ( ! is.null(min)) {
    
    tab2 <- tab2 %>%
      filter((!!year) >= min)
    
  } 
  
  else { min <- pull(summarise(tab2, year = min(!!year)))}
  
  if ( ! is.null(max)) {
    
    tab2 <- tab2 %>%
      filter((!!year) <= max)
    
  }
  else { max <- pull(summarise(tab2, year = max(!!year)))}
  
  
  tab2 <- tab2 %>%
    group_by(!!unit) %>% 
    mutate(!!group := names(which.max(table(!!group)))) %>% 
    ungroup() 
  
  
  
  g <-  ggplot(tab2, 
               aes(x = !!unit, 
                   y = !!year, 
                   text = paste("Unit: ", !!unit,"\nYear: ", !!year ,"\nN. of Articles: ", freq
                   ))) +
    geom_point(aes(size = freq, colour = !!group)) + 
    scale_size(range = c(2 , 6))+
    scale_y_continuous(breaks = seq(min, max, by = 2))+
    guides(size = guide_legend(order = 1, size_label)) + # , color = guide_legend("Continent")
    theme(legend.position = 'right'
          ,text = element_text(color = "#444444", size = 15)
          ,panel.background = element_rect(fill = '#FFFFFF')
          ,plot.title = element_text(size = 16)
          ,axis.title = element_text(size = 13, color = '#555555')
          ,axis.title.y = element_text(vjust = 1, angle = 90)
          ,axis.title.x = element_text(hjust = .95)
          ,axis.text.x = element_text(face = "bold", angle = 90, size = 13)
          ,axis.text.y = element_text(face = "bold", size = 13)
          ,axis.line.x = element_line(color = "grey50", size = 0.5)
          ,panel.grid.major.x = element_blank() 
          ,panel.grid.major.y = element_line( size = .2, color = "grey90" ) 
    )+
    labs(title = title, 
         x = "",
         y = x_title)+
    geom_line(data = tab2 , aes(x = !!unit, y = !!year, group = !!unit, colour = !!group), size = 1.0, alpha = 0.3 )+
    scale_x_discrete(labels = str_to_title(str_trunc(rev(lev), 20))
                     , limits = rev(lev))+
    coord_flip()
  
  axis_text_color <- function(g) {
    
    c <- ggplot_build(g)$data[[1]]
    
    col <-  c %>% distinct(x, colour) %>% arrange(-x)
    
    g +
      theme(axis.text.y = element_text(colour = rev(col$colour)))
  }
  
  
  g <- if (isTRUE(enquo(colour_axis))) {
    
    axis_text_color(g) }
  
  else { g }
  
  if (caption == TRUE) {
    
    text <- paste0("Source : ", source, author)
    
    cowplot::ggdraw(add_sub(g, fontface = "italic", size = 11, color = "black", x = 0, y = 0.5, hjust = 0, vjust = 0.5, fontfamily = "sans", lineheight = 1, label = text
                            
    ))}
  
  else { g }
  
  
  
  
}