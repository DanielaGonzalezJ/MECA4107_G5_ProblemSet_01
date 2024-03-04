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
setwd("C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Repositorios/MECA4107_G5_ProblemSet_01/scripts")

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


####Primera visualización de Estadísticas descriptivas#######

est_des <- skim(table)

######### Revisar distribución mediante gráfico de barras########

a<- ggplot(table, aes(x = hoursWorkUsual )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Total Horas trabajadas", y = "N. Obs") +
  theme_classic() 

b<- ggplot(table, aes(x = log(ingtotob)  )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Log del Ingreso total", y = "N. Obs") +
  theme_classic() 

c <- ggplot(table, aes(x = estrato1 )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Hogares por estrato social", y = "N. Obs") +
  theme_classic() 

d <- grid.arrange(a, b, c, ncol = 3)

ggsave("C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Repositorios/MECA4107_G5_ProblemSet_01/views/Distribucion_1.png", plot = d, units = "in")

##### Imputación de Ingreso por Estrato para reportes de 0####

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

#Revsisión del resultados de distribución
e <- ggplot(table, aes(x = log_ingtot_1 )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Ingreso (Imputado por Estrato) en Log", y = "N. Obs") +
  theme_classic() 

ggsave("C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Repositorios/MECA4107_G5_ProblemSet_01/views/Distribucion_2.png", plot = e, units = "in")

write_xlsx(table, "C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Repositorios/MECA4107_G5_ProblemSet_01/scripts/Base_Filtrada.xlsx")

##### Estadísticas Descriptivas#######
#Renombrar Variables
table__1 <- table %>% 
  rename(Escolaridad = p6210,
         'Tiempo en este trabajo' = p6426,
         Sexo = sex,
         Edad=age,
         'Parentesco con el jefe del hogar'=p6050,
         Regimen=p6100,
         'Horas trabajadas semanal'=hoursWorkUsual,
         'Ingreso Observado'=ingtotob,
         Estrato=estrato1,
         'Ingreso Imputado'=ingtot_1,
         Oficio=oficio
  )

#seleccionar Variables de interés y exportar reportes en txt y latex
estadisticas <- dplyr::select(table__1,Edad,Sexo,'Ingreso Observado','Ingreso Imputado',Estrato,'Tiempo en este trabajo', 'Horas trabajadas semanal','Parentesco con el jefe del hogar','Oficio')
estadisticas <- data.frame(estadisticas)

stargazer(estadisticas,type = "text", title="Estadísticas Descriptivas",out="C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Repositorios/MECA4107_G5_ProblemSet_01/views/Estadisticas_Descriptivas_text",style="aer")
stargazer(estadisticas, type = "latex", title="Estadísticas Descriptivas",out="C:/Users/USER/OneDrive - Universidad de los andes/Semestre VIII/Big Data/Repositorios/MECA4107_G5_ProblemSet_01/views/Estadisticas_Descriptivas_Latex",style="aer")


