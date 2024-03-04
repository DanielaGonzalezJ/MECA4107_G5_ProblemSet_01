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
       estimatr)

##Importar ajustar base

df <- read_excel("Base_Filtrada.xlsx")
df <- as_tibble(df)
df_3 <- df %>% dplyr::select(log_ingtot_1, age)
df_3 <- df_3 %>% dplyr::mutate(agesqr = age^2)

##Modelo de regresión

mod_3 <- lm(log_ingtot_1 ~ age + agesqr, data = df_3)

##Boot function

bootf <- function(df_3, index) {
  f <- lm_robust(log_ingtot_1 ~ age + agesqr, data = df_3, subset = index)
  coefs <- f$coefficients
  b1 <- coefs[2]
  b2 <- coefs[3]
  age <- b1/2*b2
  return(age)
}

##Boot
bootmod_3 <- boot(df_3, bootf, R = 1000)
low <- quantile(boot_results$t, 0.05)
up  <- quantile(boot_results$t, 0.95)

##Tabla de regresion##No funciona

mod_3_table <- stargazer(mod_3, low, up, type = "latex",
                         se = starprep(mod_3),
                         title = "Regresión Modelo 3")
cat(mod_3_table, file = "Regmod3.tex")



##Grafico
age_values <- seq(min(df_3$age), max(df_3$age), length.out = 14091)
predicted_wage <- predict(mod_3, newdata = data.frame(age = age_values, agesqr = age_values^2))
peak_age <- age_values[which.max(predicted_wage)]

#plot
pdf("Age-Earning Profile.pdf")

plot(age_values, predicted_wage, type = 'l', xlab = 'Age', ylab = 'Wage', main = 'Age-Earning Profile')


# incluir edad máxima
abline(v = peak_age, col = "blue", lty = 2)
text(peak_age, max(predicted_wage), paste("Peak Age:", round(peak_age, 2)), pos = 3, col = "blue")
dev.off()