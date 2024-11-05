

library(cartigraph)
library(HyperG)


hypercartigraph <- function(h, inches = .05,
                            title = "", coltitle = "white", frame = T, col = "#688994", author = "", 
                            sources = Sys.Date(), 
                            legend.title.nodes = legend.title.nodes,
                            legend.cat = legend.cat, 
                            legend.title.cat = legend.title.cat){
  
  var <- h$size
  
  # Select the values of the 2 sizes of circles that will be represented in the legend
  varvect <- seq(max(var), min(var), length.out = 3)
  
  inches <- inches
  
  # Fix the surface of the largest circle
  smax <- inches * inches * pi
  
  # Fix the radius of the circles
  # we multiply by 200 because the igraph package divides, by default,
  # radius value per 200 (version 1.2.4.1)
  siz <- sqrt((var * smax/max(var))/pi)
  size <- siz * 200
  
  h$size <- size
  
  plot.new()
  param <- par()
  oldparmar <- param$mar
  oldparusr <- param$usr
  par(mar = c(0, 0, 1.2, 0), usr = c(-1.3, 1.3, -1.3, 1.3))
  
  h$layout <- igraph::norm_coords(layout_with_fr(hypergraph2graph(h)), ymin = -1, ymax = 1, xmin = -1, 
                                  xmax = 1)
  
  plot.hypergraph(h, vertex.frame.color = "grey", vertex.color = "white", vertex.size = h$size,
                  vertex.label = h$names, 
                  mark.col = ifelse(h$cat == T, rainbow(5, alpha = 0.3)[3], rainbow(12, alpha = 0.3)[10]),
                  mark.border = ifelse(h$cat == T, rainbow(5, alpha = 1)[3], rainbow(12, alpha = 0.3)[10]),
                  vertex.label.family = "sans", vertex.label.color = "black", 
                  vertex.label.degree = -pi/2, vertex.label.cex = 0.6, rescale = F,
                  add = T)
  
  # Adjust the size parameter of the legend circles (#cartography package)
  # taking into account the selected graphic parameters
  xinch <- diff(par("usr")[1L:2])/par("pin")[1L]
  sizevect <- inches/xinch
  
  # Add the legend indicating the size of the circles
  cartography::legendCirclesSymbols(pos = "topright", title.txt = legend.title.nodes,
                                    title.cex = 0.6, values.cex = 0.5,
                                    var = varvect, inches = sizevect, #circles' size
                                    col = "white", frame = F, values.rnd = 0,
                                    style = "e") # choice of "extended" style for better readability
  
  cartography::layoutLayer(title = title, coltitle = coltitle, 
                           sources = sources,
                           author = author, 
                           frame = T, 
                           col = "#688994", 
                           scale = NULL)
  
  legend(x = -1.25, y = -0.75, legend = legend.cat, pch = 21,
         col ="#777777", 
         pt.bg = c(rainbow(5, alpha = .3)[3], rainbow(12, alpha = .3)[10]), 
         pt.cex = 2, cex = .8, bty = "n", title = legend.title.cat)
  
  par(oldparmar)
  par(oldparusr)
  
}