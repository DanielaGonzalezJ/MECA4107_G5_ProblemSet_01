##########################################################
# BDML - FEB 24
# Problem Set # 1
# authors: 
##########################################################


#Separate each section with labels
# Clean the workspace -----------------------------------------------------
rm(list=ls())
cat("\014")


# Load Packages -----------------------------------------------------------

## Install Packages

if(!require(pacman)) install.packages("pacman") ; require(pacman)


p_load(rio, # import/export data
       tidyverse, # tidy-data
       skimr, # summary data
       gridExtra, ## visualizing missing data
       corrplot, ## Correlation Plots 
       stargazer, ## tables/output to TEX.
       rvest, ## Web Scraping Package
       MASS)   


# Load data ---------------------------------------------------------------
my_url = "https://ignaciomsarmiento.github.io/GEIH2018_sample/"
browseURL(my_url) ## Ir a la página

my_html = read_html(my_url) ## leer el html de la página
class(my_html) ## ver la clase del objeto

#View(my_html)

my_html %>% html_elements("h2")

# plot data ---------------------------------------------------------------

plot(dta$gdpgr, dta$gdpcapgr, pch="*")
