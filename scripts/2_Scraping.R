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

my_url_base <- "https://ignaciomsarmiento.github.io/GEIH2018_sample/page"
my_url_pages <- c(1:10)  # Create a vector of page numbers (integers)
my_url_ext <- ".html"

my_urls <- paste0(my_url_base, my_url_pages, my_url_ext)  # Concatenate all elements

my_url_base_GH <- "https://ignaciomsarmiento.github.io/GEIH2018_sample/pages/geih_page_" 
my_url_ext_GH <- ".html"

my_urls_GH <- paste0(my_url_base_GH, my_url_pages, my_url_ext_GH)  # Concatenate all elements

my_html = list()
table_1 = list()


for (i in 1:length(my_urls_GH)) {
  url <- my_urls_GH[i]
  #browseURL(url)  # Print the full URL
  my_html[[i]] = read_html(url)
  table_1[[i]] <- my_html[[i]] %>%  html_table()
  #table_1[[i]] <- as.data.frame(table[[i]])
    }

my_html[[1]]
table_1[[1]]
table_1[[1]][1]

#----------------------------------------------------------------------------