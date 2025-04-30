# SST plot Map

library(tidync)

mydata <- tidync("Byrne map/IMOS_aggregation_20211220T210702Z.nc") #%>% hyper_tibble()
mydata

library(raster)

dat <- stack("Byrne map/IMOS_aggregation_20211220T210702Z.nc")
dat_mean <- calc(dat, fun = mean)
plot(dat_mean)

plot_dat <- raster::as.data.frame(dat_mean, xy=T)
library(tidyverse)
plot_dat2 <- plot_dat %>% filter(x < 158) %>%
  filter(x>145) %>% filter(y > -45) %>% filter(y < -24)
library(ggplot2)
ggplot(plot_dat, aes(x=x, y = y, fill=layer, colour=layer)) + geom_raster()

library(rnaturalearth)
world <- ne_states(country="australia",returnclass = "sf")
plot(world)

ggplot(world) + geom_sf()

points <- data.frame("x" = c(153.562, 151.227, 148.223),
                     "y" = c(-27.345, -34.119, -42.597),
                     "site" = c("North Stradbroke\nIsland",
                                "Port\nHacking",
                                "Maria\nIsland"))

library(ggrepel)

ggplot(plot_dat2, aes(x=x, y = y, fill=layer, colour=layer)) + geom_raster()+
  geom_sf(data=world, inherit.aes = F, colour = "black") + 
  coord_sf(expand = c(0,0)) + xlim(c(145, 158))+
  ylim(c(-45, -24))+
  ylab("Latitude") + xlab("Longitude")+
  geom_point(data=points, aes(x=x, y=y),shape=21, size = 3,
             fill="black", col="white", inherit.aes = F)+
  geom_text_repel(data=points, aes(x=x, y=y, label=site), inherit.aes = F)+
  scale_fill_viridis_c(option = "turbo", na.value="transparent", name="Mean SST (°C)")+
  scale_colour_viridis_c(option = "turbo", na.value="transparent", name= "Mean SST (°C)") +
  theme_classic() + theme(axis.text = element_text(colour="black", size=12),
                          axis.title = element_text(face="bold", size=14),
                          panel.border = element_rect(colour="black", fill = NA),
                          legend.position= "bottom",
                          legend.title = element_text(face="bold", size=14),
                          legend.text = element_text(size=12, colour="black"),
                          legend.key.width = unit(1.5, "cm"))

#ggsave("Byrne map/SST plot.png", width=21,height = 21, dpi=600, units = "cm")
ggsave("Byrne map/SST plot.pdf", height = 21, width = 21, dpi=600, units = "cm")
#ggsave("Byrne map/SST plot.tiff", height=21, width = 21, dpi=600, units = "cm")
