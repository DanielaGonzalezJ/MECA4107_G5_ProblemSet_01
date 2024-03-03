##########################################################
# BDML - FEB 24
# Problem Set # 1
# authors: 
#           González Galvis, Daniel Enrique
#           González Junca, Daniela Natalia
#           Mendoza Potes, Valentina
#           Rodríguez Pacheco, Alfredo José
##########################################################

## Punto 2. Data Scraping

#Separate each section with labels
# Clean the workspace -----------------------------------------------------
rm(list=ls())

# Load Packages -----------------------------------------------------------

## Intalación de todos lo paquetes

if(!require(pacman)) install.packages("pacman") ; require(pacman)

require(pacman)
setwd("C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Taller I")

p_load(haven,skimr, tidyverse, forecast, ggplot2, tseries, readxl, writexl, dplyr, 
       fable, fpp2, lubridate, mFilter, urca, stargazer, quantmod, margins,ggeffects,rvest,grid,gridExtra,psych,xtable)

####Cargar Datos (Scraping)####

my_url = "https://ignaciomsarmiento.github.io/GEIH2018_sample/pages/geih_page_"
class(my_url)

table_u=list()
table=list()  

#Recorrido de todos los Chunks
for (i in 1:10){
  url=paste0(my_url,i,".html")
  print(url)
  my_html = read_html(url)
  table<- my_html %>% 
    html_table()
  table<- as.data.frame(table)
  table_u <- rbind(table_u,table)
}