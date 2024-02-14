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
pkg<-list("dplyr","here")
lapply(pkg, require, character.only=T)
rm(pkg)



# Load data ---------------------------------------------------------------
# I recomend you using the package here
dta<-read.table(here("stores","US90.txt"), sep="", header=TRUE)


# plot data ---------------------------------------------------------------

plot(dta$gdpgr, dta$gdpcapgr, pch="*")
