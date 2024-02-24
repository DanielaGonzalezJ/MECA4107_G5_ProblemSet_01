rm(list = ls())
if(!require(pacman)) install.packages("pacman") ; require(pacman)

require(pacman)
setwd("C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Taller I")

p_load(haven,skimr, tidyverse, forecast, ggplot2, tseries, readxl, writexl, dplyr, 
       fable, fpp2, lubridate, mFilter, urca, stargazer, quantmod, margins,ggeffects,rvest,grid,gridExtra)

####Cargar Datos (Scrping)####

my_url = "https://ignaciomsarmiento.github.io/GEIH2018_sample/pages/geih_page_"
class(my_url)

table_u=list()
table=list()  

for (i in 1:10){
  url=paste0(my_url,i,".html")
  print(url)
    my_html = read_html(url)
  table<- my_html %>% 
    html_table()
  table<- as.data.frame(table)
    table_u <- rbind(table_u,table)
}
names(table_u)

#####Filtrado de Datos por condiciones####

#Solo mayores de edad Mayores de edad
table <- table_u %>% filter(age>=18)

#Only on employed individuals!! <- No desempleados, No Incativois 
#No Inactivos
table <- table %>% filter(inac ==0)

# Personas que reportaron ocupar la mayor parte del tiempo trabajando
table <- table %>% filter(p6240 == 1)

# Esta ocupado
table <- table %>% filter(ocu==1)

#Salario Mayor a 0
table_u <- subset(table_u, P6500 >0)


####Estadísticas descriptivas#######

est_des <- skim(table_u)
names(table)

######### Revisar distribución########

a<- ggplot(table, aes(x = hoursWorkUsual )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Total Hours Worked", y = "N. Obs") +
  theme_bw() 

b<- ggplot(table, aes(x = log(ingtotob)  )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Ingreso total observado en miles", y = "N. Obs") +
  theme_bw() 

c <- ggplot(table, aes(x = log(ingtot) )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Ingreso total imputado en miles", y = "N. Obs") +
  theme_bw() 

grid.arrange(a, b, c, ncol = 3)

##### Imputación de Ingreso por Estrato para NAs

table = table %>% 
  group_by(estrato1) %>% 
  mutate(mean_ingtot = mean(ingtot, na.rm=T)) %>% 
  ungroup()

table = table %>% 
  mutate(ingtot_1 = ifelse(ingtot==0, 
                         yes =mean_ingtot, 
                         no=ingtot )) 
table<-  table %>%
  mutate(log_ingtot_1= log(ingtot_1))

ggplot(table, aes(x = log_ingtot_1 )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Total Income", y = "Cantidad") +
  theme_bw() 

write_xlsx(table, "Base_Filtrada.xlsx")

