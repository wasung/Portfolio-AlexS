library(ggplot2)
library(scales)
library(ggpubr)
library(bayesplot)
library(matrixStats)
library(cowplot)

plot_covars <- function(filename){ 
  
  load(paste0("~/Portfolio-AlexS/Opdracht 4 - Reproducible Science/4b - Nature article files/Results/", filename,'-stanfit.Rdata'))
  out <- rstan::extract(fit)
  alpha = data.frame(as.matrix(out$alpha))
  plot_labels <- c("School Closure",
                   "Self Isolation",
                   "Public Events",
                   "First Intervention",
                   "Lockdown", 'Social distancing')
  colnames(alpha) = plot_labels
  first.intervention = alpha[,c(1,2,3,5,6)] + alpha[,4]
  data1 = mcmc_intervals_data(first.intervention,prob=.95,transformation=function(x) 1-exp(-x),point_est="mean")
  data1$type = "First Intervention"
  
  data2 = mcmc_intervals_data(alpha[,c(1,2,3,5,6)],  prob = .95,transformation=function(x) 1-exp(-x),point_est="mean")
  data2$type = "Later Intervention"
  data = rbind(data1,data2[1:5,])
  colQuantiles(data.matrix(first.intervention),probs=c(.025,.975))
  
  levels(data$parameter) = gsub("t(", "", levels(data$parameter), fixed=TRUE)
  levels(data$parameter) = gsub(")", "", levels(data$parameter), fixed=TRUE)
  data$parameter = (as.character(data$parameter))
  
  no_point_est <- all(data$point_est == "none")
  x_lim <- range(c(data$ll, data$hh))
  x_range <- diff(x_lim)
  x_lim[1] <- x_lim[1] - 0.05 * x_range
  x_lim[2] <- x_lim[2] + 0.05 * x_range
  layer_vertical_line <- if (0 > x_lim[1] && 0 < x_lim[2]) {
    vline_0(color = "gray90", size = 0.5)
  } else {
    geom_blank(
      mapping = NULL, data = NULL,
      show.legend = FALSE, inherit.aes = FALSE)
  }
  args_outer <- list(mapping = aes_(x = ~ll, xend = ~hh, y = ~parameter, 
                                    yend = ~parameter))
  args_inner <- list(mapping = aes_(x = ~l, xend = ~h, y = ~parameter, 
                                    yend = ~parameter), size = 2, show.legend = FALSE)
  args_point <- list(mapping = aes_(x = ~m, y = ~parameter), 
                     data = data, size = 4, shape = 21)
  
  args_point$color <- "blue"
  
  point_func <- geom_point
  layer_outer <- do.call(geom_segment, args_outer)
  layer_inner <- do.call(geom_segment, args_inner)
  layer_point <- do.call(point_func, args_point)
  
  data$parameter = factor(as.character(data$parameter),levels=plot_labels[order(plot_labels)[6:1]])
  p = ggplot(data) +theme_pubr() +  geom_point(aes(x=m,y=parameter,colour=type),position = position_dodge(-.5)) + 
    geom_linerange(aes(xmin=ll,xmax=hh,y=parameter,colour=type),
                   position = position_dodge(-.5)) + 
    scale_x_continuous(breaks=seq(0,1,.25),labels = c("0%\n(no effect on transmissibility)",
                                                      "25%","50%","75%","100%\n(ends transmissibility)"),
                       expand=c(0.005,0.005),expression(paste("Relative % reduction in  ",R[t])))  +
    scale_colour_manual(name = "",
                        values = c(("coral4"), ("seagreen"))) + 
    
    geom_vline(xintercept=1,colour="darkgray") +
    scale_y_discrete("Governmental intervention\n") +
    #geom_vline(xintercept=0,colour="darkgray") + 
    theme(plot.margin = margin(0, 2, 0, .5, "cm"))
  #+ guides(fill=guide_legend(nrow=2))
  p    
  ggsave(filename = paste0("~/Portfolio-AlexS/Opdracht 4 - Reproducible Science/4b - Nature article files/covars-alpha-reduction", filename,".png"),
         p,height=4,width=8)
}