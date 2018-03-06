setwd("C:/Users/HP User/Documents/ITS/TRAN5911M - Transport Dissertation")
getwd()

#install packages
install.packages("sf")
install.packages("tidyverse")
install.packages("tmap")
install.packages("dplyr")
install.packages("osmdata")


#load packages
library(sf)
library(tidyverse)
library(tmap)
library(dplyr)
library(osmdata)
library(stplanr)


#load BSS dock stations data
Stations_file = "Dock_stations/stations.shp"
Stations = st_read(Stations_file)
summary(Stations$id)
str(Stations)
plot(Stations)
mapview::mapview(Stations)


#load BSS historic trips data
trips_2018_01_file = "Trips/2018-01.csv"
trips_2018_01 = read.csv(trips_2018_01_file)
summary(trips_2018_01)
str(trips_2018_01)
summary(trips_2018_01$Edad_Usuario)
hist(trips_2018_01$Edad_Usuario, col = "green")


#create desire lines
od_mat = trips_2018_01 %>% 
  group_by(Ciclo_Estacion_Retiro, Ciclo_Estacion_Arribo) %>% 
  summarise(flow = n()) 
sum(od_mat$flow)                  #check sum with total trips
data_top = od_mat %>% 
  top_n(n = 10, wt = flow)

#sel = od_mat$Ciclo_Estacion_Retiro %in% Stations$id &
#  od_mat$Ciclo_Estacion_Arribo %in% Stations$id
#summary(sel)
#data_top = od_mat[sel, ]
#summary(data_top$Ciclo_Estacion_Retiro %in% Stations$id)

lines = od2line(flow = data_top, Stations)
mapview::mapview(lines)


#load AGEB spatial set
AGEB_file = "Geostatistical_vectors/ageb_urb/AGEB_urb_2010_5.shp"
AGEB = st_read(AGEB_file)
summary(AGEB)
str(AGEB)
plot(AGEB[2])
mapview::mapview(AGEB)


#load AGEB indicators data
indicators_file = "Geostatistical_data/basic indicators ageb mnz.csv"
indicators = read.csv(indicators_file)
summary(indicators)
str(indicators)
summary(indicators$AGEB)

