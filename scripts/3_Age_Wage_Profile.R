##########################################################
# BDML - FEB 24
# Problem Set # 1
# authors: 
#           González Galvis, Daniel Enrique
#           González Junca, Daniela Natalia
#           Mendoza Potes, Valentina
#           Rodríguez Pacheco, Alfredo José
##########################################################

## Punto 3. Age - Wage Profile
##Limpiar ambiente
rm(list=ls())
##Llamar librerias

if(!require(pacman)) install.packages("pacman") ; require(pacman)

p_load(tidyverse,
       skimr,
       readxl,
       sandwich,
       lmtest,
       boot,
       car,
       estimatr)

##Importar/ ajustar base

df <- read_excel("Base_Filtrada.xlsx")
df <- as_tibble(df)
df_3 <- df %>% select(log_ingtot_1, age)
df_3 <- df_3 %>% mutate(agesqr = age^2)

##Modelo de regresión

mod_3 <- lm_robust(log_ingtot_1 ~ age + agesqr, data = df_3)

##Boot function

f_boot <- function(df_3, indices) {
  sample <- df_3[indices, ]
  age_values <- seq(min(sample$age), max(sample$age), length.out = 14091)
  predicted_wage <- predict(mod_3, newdata = data.frame(age = age_values, agesqr = age_values^2))
  peak_age <- age_values[which.max(predicted_wage)]
  return(peak_age)
}

##Boot
bootmod_3 <- boot(df_3, f_boot, R = 1000)

ci_peak <- boot.ci(bootmod_3, type = "basic")

##Tabla de regresion##No funciona
stargazer(mod_3, type = "text",
          se = list(ci_peak),
          title = "Regresión Modelo 3")


##Grafico
age_values <- seq(min(df_3$age), max(df_3$age), length.out = 14091)
predicted_wage <- predict(mod_3, newdata = data.frame(age = age_values, agesqr = age_values^2))
peak_age <- age_values[which.max(predicted_wage)]

#plot
plot(age_values, predicted_wage, type = 'l', xlab = 'Age', ylab = 'Wage', main = 'Age-Earning Profile')

#intervalos

# incluir edad máxima
abline(v = peak_age, col = "blue", lty = 2)
text(peak_age, max(predicted_wage), paste("Peak Age:", round(peak_age, 2)), pos = 3, col = "blue")