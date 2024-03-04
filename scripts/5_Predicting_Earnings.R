##########################################################
# BDML - FEB 24
# Problem Set # 1
# authors: 
#           González Galvis, Daniel Enrique
#           González Junca, Daniela Natalia
#           Mendoza Potes, Valentina
#           Rodríguez Pacheco, Alfredo José
##########################################################

table <- read_excel("Base_Filtrada.xlsx")
## Punto 5. Predicting Earnings

table <- table  %>%
  mutate(maxEducLevel = ifelse(is.na(maxEducLevel), mean(maxEducLevel, na.rm=T) , maxEducLevel))


### Punto 5 

table1<- table  %>% dplyr::select(log_ingtot_1,
                           age,
                           sex, 
                           totalHoursWorked, 
                           maxEducLevel)
skim(table1)

db <- as_tibble(table1)

variables_categoricas <- c("sex", "maxEducLevel" )

db<- db %>% mutate_at(variables_categoricas, as.factor)

#Dividir la muestra
set.seed(4785)

inTrain <- createDataPartition(
  y = db$log_ingtot_1,  
  p = .70, 
  list = FALSE
)

training <- db[inTrain,]
testing <- db[-inTrain,]

##Modelos##
#Modelo 1a 
form_1<- log_ingtot_1 ~ sex
modelo1a <- lm(form_1,
               data = training)

predictions <- predict(modelo1a, testing)

score1a<- RMSE(predictions, testing$log_ingtot_1)
score1a

#Modelo 1b 
form_1b <- log_ingtot_1 ~ age + age^2
modelo1b <- lm(form_1b,
               data = training)

predictions <- predict(modelo1b, testing)
score1b<- RMSE(predictions, testing$log_ingtot_1)
score1b

#Modelo 2 
form_2 <- log_ingtot_1 ~ age + sex 
modelo2 <- lm(form_2,
              data = training)

predictions <- predict(modelo2,testing)
score2 <- RMSE(predictions, testing$log_ingtot_1)
score2

#Modelo 3
form_3 <- log_ingtot_1 ~ age + age^2 + sex 
modelo3 <- lm(form_3,
              data = training)

predictions <- predict(modelo3,testing)
score3 <- RMSE (predictions, testing$log_ingtot_1)
score3

#Modelo4 
form_4 <- log_ingtot_1 ~ age + age^2 + sex +totalHoursWorked 
modelo4 <- lm(form_4,
              data = training)

predictions <- predict(modelo4,testing)
score4 <- RMSE (predictions, testing$log_ingtot_1)
score4

#Modelo5 
form_5 <- log_ingtot_1 ~ poly(age,3,raw=TRUE) +
  sex + poly(age,3,raw=TRUE):sex + maxEducLevel
modelo5 <- lm(form_5,
              data = training)

predictions <- predict(modelo5,testing)
score5 <- RMSE (predictions, testing$log_ingtot_1)
score5

#Modelo 6
form_6 <- log_ingtot_1 ~ poly(age,3,raw=TRUE) +
  sex + poly(age,3,raw=TRUE):sex + totalHoursWorked + poly(maxEducLevel,3,raw=TRUE) + poly(maxEducLevel,3,raw=TRUE):age

modelo6 <- lm(form_6,
              data = training)

predictions <- predict(modelo6,testing)
score6 <- RMSE (predictions, testing$log_ingtot_1)
score6

predErr <- testing$log_ingtot_1 - predictions
hist(predErr, breaks = 20, main = "Distribution of Prediction Errors Model 6", xlab = "Prediction Error")

summary(predErr)

#Tabla resultados

matriz_valores <- matrix(NA, nrow = 1, ncol = 7)

# Insertar valores
matriz_valores[1, ] <- c(score1a, score1b, score2, score3, score4, score5, score6) 

rownames(matriz_valores) <- c("RMSE")
colnames(matriz_valores) <- c("Modelo 1a", "Modelo 1b", "Modelo 2", "Modelo 3", "Modelo 4", "Modelo 5", "Modelo 6")
matriz_valores

my_table <- stargazer(matriz_valores, type = "latex", title = "Tabla de ejemplo", label = "tab:ejemplo")
writeLines(my_table, "mi_tabla.tex")


#LOOCV 

ctrl <- trainControl(
  method = "LOOCV")

modelo5 <- train(form_5,
                 data = db,
                 method = 'lm', 
                 trControl= ctrl)
modelo5

score5L<-RMSE(modelo5$pred$pred, db$log_ingtot_1)

modelo6 <- train(form_6,
                 data = db,
                 method = 'lm', 
                 trControl= ctrl)
modelo6

score6L<-RMSE(modelo6$pred$pred, db$log_ingtot_1)

#Tabla resultados

matriz_valores2 <- matrix(NA, nrow = 1, ncol = 2)

# Insertar valores
matriz_valores2[1, ] <- c(score5L, score6L) 

rownames(matriz_valores2) <- c("RMSE")
colnames(matriz_valores2) <- c("Modelo 5", "Modelo 6")
matriz_valores2

my_table2 <- stargazer(matriz_valores2, type = "latex", title = "Tabla de ejemplo", label = "tab:ejemplo")
writeLines(my_table2, "mi_tabla2.tex")
