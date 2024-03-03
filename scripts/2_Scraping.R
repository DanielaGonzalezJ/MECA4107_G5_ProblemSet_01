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

