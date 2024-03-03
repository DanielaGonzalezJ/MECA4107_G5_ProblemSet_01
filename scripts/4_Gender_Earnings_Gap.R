##########################################################
# BDML - FEB 24
# Problem Set # 1
# authors: 
#           González Galvis, Daniel Enrique
#           González Junca, Daniela Natalia
#           Mendoza Potes, Valentina
#           Rodríguez Pacheco, Alfredo José
##########################################################

## Punto 4. Gender_Earnings_Gap



#####
# Punto 4
#####


## a. Unconditional Wage Gap:

table_4 <- table
table_4$sex_1 <- -1*(table_4$sex-1)

table_4$sex_1 <- factor(table_4$sex_1 , levels = c(1,0), labels = c("Female", "Male"))
reg1<-lm(log_ingtot_1 ~ sex_1, data =table_4)
stargazer(reg1,type="text",digits=7)

## b. Equal Pay for Equal Work:


ggplot(table_4, aes(x = college )) +
  geom_histogram(bins = 50, fill = "darkblue") +
  labs(x = "Total Income", y = "Cantidad") +
  theme_bw() 
