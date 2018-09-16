library(tidyverse)
library(scales)
library(ggthemes)
library(here)
library(magick)

dat <- read_csv(here("AltonHotOnes.csv"))

hot_ones_yellow <- '#FFCE00'
hot_ones_red <- '#E4332F'
darkgrey <- 'grey40'
grey <- 'grey50'

family <- 'Helvetica'
face = 'bold'


hoplot <- ggplot(data = dat, mapping = aes(x = `Scoville Level`, y = `Ranking`, label = Name)) +
  scale_x_continuous(trans = log10_trans(), labels = comma, breaks = 10^(1:10), limits = c(300, 5000000)) +
  scale_y_reverse(breaks = 1:10) +
  ylab("Alton Brown's Ranking") +
  # geom_smooth(method = 'loess', se = F, color = 'grey90') +
  # geom_smooth(method = 'lm', se = F, color = 'white') +
  geom_point(color = hot_ones_red, size = 4) +
  geom_text(nudge_y = .5, color = hot_ones_yellow, fontface = face, family = family) +
  theme(rect = element_rect(fill = 'black', color = 'black'),
        text = element_text(colour = 'white'),
        panel.background = element_rect(fill = 'black', color = 'black'),
        plot.background = element_rect(color = "black"),
        panel.grid.major = element_line(color = grey),
        panel.grid.minor = element_line(color = darkgrey),
        panel.grid.minor.y = element_blank(),
        axis.text = element_text(color = grey, family = family, face = face),
        axis.title = element_text(family = family, face = face))

ggsave(filename = here('Hot_Ones_Plot.svg'), plot = hoplot, width = 8, height = 4)

width <- 1000
plot <- image_read_svg(here('Hot_Ones_Plot.svg'), width = width)
logo_raw <- image_read_svg("https://upload.wikimedia.org/wikipedia/en/2/23/Hot_Ones_by_First_We_Feast_logo.svg", width = width)

logo <- logo_raw %>%
  image_scale(width / 2) %>%
  image_background("black", flatten = TRUE) %>% 
  image_border("black", width / 4)

final_plot <- image_append(c(logo, plot), stack = TRUE)

image_write(final_plot, here("HotOnes.png"))
