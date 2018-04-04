setwd("C:/Users/HP User/Documents/ITS/TRAN5911M - Transport Dissertation")
getwd()

#install packages
#install.packages("sf")
#install.packages("tidyverse")
#install.packages("tmap")
#install.packages("dplyr")
#install.packages("osmdata")
#install.packages("stplanr")

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
plot(Stations[1])
mapview::mapview(Stations)


#load BSS historic trips data
trips_2011_01_file = "Trips/2011-01.csv"
trips_2011_01 = read.csv(trips_2011_01_file)
summary(trips_2011_01)
str(trips_2011_01)
summary(trips_2011_01$Edad_Usuario)
hist(trips_2011_01$Edad_Usuario, col = "green")


#create desire lines
od_mat = trips_2011_01 %>% 
  group_by(Ciclo_Estacion_Retiro, Ciclo_Estacion_Arribo) %>% 
  summarise(flow = n()) 
sum(od_mat$flow)                  #check sum with total trips
data_top <- top_n(x = od_mat, n = 5, wt = flow)
summarize(data_top)

#sel = od_mat$Ciclo_Estacion_Retiro %in% Stations$id &
#  od_mat$Ciclo_Estacion_Arribo %in% Stations$id
#summary(sel)
#data_top = od_mat[sel, ]
#summary(data_top$Ciclo_Estacion_Retiro %in% Stations$id)

desire_lines = od2line(flow = data_top, zones = Stations)
mapview::mapview(desire_lines)


#load AGEB spatial set
AGEB_file = "Geostatistical_vectors/ageb_urb/AGEB_urb_2010_5.shp"
AGEB = st_read(AGEB_file)
summary(AGEB)
str(AGEB)

#filter CDMX AGEBs
AGEB_AZ <- filter(AGEB, grepl("0900200", CVEGEO, perl = T))
AGEB_CY <- filter(AGEB, grepl("0900300", CVEGEO, perl = T))
AGEB_CJ <- filter(AGEB, grepl("0900400", CVEGEO, perl = T))
AGEB_GM <- filter(AGEB, grepl("0900500", CVEGEO, perl = T))
AGEB_IZ <- filter(AGEB, grepl("09006000", CVEGEO, perl = T))
AGEB_IP <- filter(AGEB, grepl("09007000", CVEGEO, perl = T))
AGEB_MC <- filter(AGEB, grepl("09008000", CVEGEO, perl = T))
AGEB_MA <- filter(AGEB, grepl("090090", CVEGEO, perl = T))
AGEB_AO <- filter(AGEB, grepl("090100", CVEGEO, perl = T))
AGEB_TH <- filter(AGEB, grepl("0901100", CVEGEO, perl = T))
AGEB_TL <- filter(AGEB, grepl("090120", CVEGEO, perl = T))
AGEB_XO <- filter(AGEB, grepl("090130", CVEGEO, perl = T))
AGEB_BJ <- filter(AGEB, grepl("090140", CVEGEO, perl = T))
AGEB_CH <- filter(AGEB, grepl("090150", CVEGEO, perl = T))
AGEB_MH <- filter(AGEB, grepl("090160", CVEGEO, perl = T))
AGEB_VC <- filter(AGEB, grepl("090170", CVEGEO, perl = T))

#set BSS coverage area
AGEB_BSS <- rbind.data.frame(AGEB_BJ, AGEB_CH, AGEB_MH)
AGEB_CDMX <- rbind.data.frame(AGEB_AZ, AGEB_CY, AGEB_CJ, AGEB_GM, AGEB_IZ, AGEB_IP, 
                              AGEB_MC, AGEB_MA, AGEB_AO, AGEB_TH, AGEB_TL, AGEB_XO, 
                              AGEB_BJ, AGEB_CH, AGEB_MH, AGEB_VC)
mapview::mapView(AGEB_BSS[2])
mapview::mapView(AGEB_CDMX[2])

#load AGEB indicators data
indicators_file = "Geostatistical_data/basic indicators ageb.csv"
indicators = read.csv(indicators_file)
summary(indicators)
str(indicators)

indicators$ï..ENTIDAD <- formatC(indicators$ï..ENTIDAD, width = 2, flag = "0")
indicators$MUN <- formatC(indicators$MUN, width = 3, flag = "0")
indicators$LOC <- formatC(indicators$LOC, width = 4, flag = "0")
indicators$AGEB <- formatC(indicators$AGEB, width = 4, flag = "0")

indicators$clave <- paste0(indicators$ï..ENTIDAD, indicators$MUN, indicators$LOC, indicators$AGEB)
str(indicators$clave)

mergedzones <- merge(AGEB_BSS, indicators, by.x=c("CVEGEO"), by.y=c("clave"))
mapview::mapview(mergedzones[2])

#zones_joined = left_join(x = AGEB_CDMX$CVEGEO, y = indicators$clave)
