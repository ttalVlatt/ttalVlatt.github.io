## -----------------------------------------------------------------------------
##
##' [PROJ: ttalVlatt.github.io]
##' [FILE: Logo Creation]
##' [INIT: 2023-05-21]
##' [AUTH: Matt Capaldi] @ttalVlatt
##
## -----------------------------------------------------------------------------

## ---------------------------
##' [Libraries]
## ---------------------------

library(tidyverse)

## ---------------------------
##' [Data Input]
## ---------------------------

bar_data <- tibble(bar_id = c(0,1,2,3,4,5,6),
               bar_val = c(0.5, 5, 3, 2, 2.5, 4.5, 0.5),
               bar_fill = c(7,1,4,2,5,3,6))

line_data <- tibble(line_id = c(0,1,3,5,6,7),
                    line_val = c(0.5, 5, 2, 4.5, 0.5, 1.5))

line2_data <- tibble(line_id = c(-0.25,1.25,2.75,5.25,5.75,7.25),
                    line_val = c(0.5, 5, 2, 4.5, 0.5, 1.5))

line3_data <- tibble(line_id = c(0.25,0.75,3.25,4.75,6.25,6.75),
                     line_val = c(0.5, 5, 2, 4.5, 0.5, 1.5))

point_data <- tibble(point_id = c(-0.25, seq(0,7, by = 0.5)),
                     point_val = c(0.25, 2, 3.25, 5.25,
                                   4.375, 3.5, 2.5, 1.75,
                                   2.25, 3.25, 3.675, 4.675,
                                   3.25, 1.25, 0.375, 1.625))

## ---------------------------
##' [Create the Logo]
## ---------------------------

ggplot() +
  geom_col(data = bar_data,
           aes(x = bar_id,
               y = bar_val,
               fill = bar_fill),
           color = "white",
           width = 0.5,
           alpha = 0.9) +
  geom_line(data = line_data,
            aes(x = line_id,
                y = line_val),
            linewidth = 2,
            color = "orange2") +
  geom_line(data = line2_data,
              aes(x = line_id,
                  y = line_val),
            linetype = 4,
            linewidth = 0.5,
            color = "orange4") +
  geom_line(data = line3_data,
            aes(x = line_id,
                y = line_val),
            linetype = 2,
            linewidth = 0.5,
            color = "orange4") +
  geom_line(data = point_data,
            aes(x = point_id,
                y = point_val),
            linewidth = 1,
            color = "orange3") +
  geom_point(data = point_data,
             aes(x = point_id,
                 y = point_val),
             shape = 21,
             size = 5,
             fill = "orange",
             color = "black",
             alpha = 0.95) +
  scale_fill_distiller(palette = "Greys") +
  theme_minimal()+
  theme(legend.position = "none",
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.line = element_line())
  
ggsave("Logo.png",
       bg = "transparent")

## -----------------------------------------------------------------------------
##' *END SCRIPT*
## -----------------------------------------------------------------------------