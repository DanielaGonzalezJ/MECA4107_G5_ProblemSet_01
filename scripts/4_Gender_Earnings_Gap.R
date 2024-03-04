##########################################################
# BDML - FEB 24
# Problem Set # 1
# authors: 
#          González Galvis, Daniel Enrique
#          González Junca, Daniela Natalia
#          Mendoza Potes, Valentina
#          Rodríguez Pacheco, Alfredo José
##########################################################

## Punto 4. Gender_Earnings_Gap

#####
# Punto 4
#####


## a. Unconditional Wage Gap:

table_4 <- table
table_4$sex_1 <- -1*(table_4$sex-1)

#table_4$sex_1 <- factor(table_4$sex_1 , levels = c(1,0), labels = c("Female", "Male"))
reg1<-lm(log_ingtot_1 ~ sex_1, data =table_4)




## b. Equal Pay for Equal Work:

<<<<<<< Updated upstream

reg2 <- lm(log_ingtot_1 ~ sex_1 + age +  I(sex_1*age) + factor(oficio) + factor(college), data =table_4) 


#a & b
stargazer(reg1, reg2, omit="oficio",type="latex",digits=2)
=======
##Reg2


#reg2 <- lm(log_ingtot_1 ~ sex_1 + factor(age) + factor(oficio) + factor(college), data =table_4)  
#stargazer(reg2,type="text",digits=7)

reg3 <- lm(log_ingtot_1 ~ sex_1 + age , data =table_4)  
stargazer(reg3,type="text",digits=7)

>>>>>>> Stashed changes


## FWL

#Regress X1 ~ sex_1 on X2 ~ age and take the residuals

<<<<<<< Updated upstream
table_4<-table_4 %>% mutate(sexResidF=lm(sex_1 ~ age  +  I(sex_1*age) + factor(oficio) + factor(college) ,table_4)$residuals) #Residuals of weight~foreign 

#Regress Y on X2 and take the residuals

table_4<-table_4 %>% mutate(litResidF=lm(log_ingtot_1 ~ age  +  I(sex_1*age)+ factor(oficio) + factor(college), table_4)$residuals) #Residuals of mpg~foreign 
=======
table_4<-table_4 %>% mutate(sexResidF=lm(sex_1 ~ age ,table_4)$residuals) #Residuals of weight~foreign 

#Regress Y on X2 and take the residuals

table_4<-table_4 %>% mutate(litResidF=lm(log_ingtot_1 ~ age, table_4)$residuals) #Residuals of mpg~foreign 
>>>>>>> Stashed changes

#Regress the residuals from step 2 on the residuals from step 1
reg4<-lm(litResidF~sexResidF , table_4)

<<<<<<< Updated upstream
stargazer(reg2,reg4, omit="oficio", type="latex",digits=2) # with stargazer we can visualize the coefficients next to each other


## OLS with Bootstrap


beta_1 <- function(data, index){
  coef(lm(log_ingtot_1 ~ sex_1 + age  +  I(sex_1*age) + factor(oficio) + factor(college), data = table_4 , subset = index))[2]
=======
stargazer(reg3,reg4,type="text",digits=7) # with stargazer we can visualize the coefficients next to each other


## FWL with Bootstrap


beta_1 <- function(data, index){
  coef(lm(log_ingtot_1 ~ sex_1 + age, data = table_4 , subset = index))[2]
>>>>>>> Stashed changes
}

beta_1(table_4, 1:nrow(table_4))
##

set.seed(86508)
#Call boot
<<<<<<< Updated upstream
boot_result_OLS <- boot(table_4, beta_1, R=1000)



##FWL with bootstrap
=======
boot(table_4, beta_1, R=1000)



##Test
>>>>>>> Stashed changes
beta_1_1 <- function(data,index){
  coef(lm(litResidF~sexResidF , data = table_4 , subset = index))[2]
}

beta_1_1(table_4, 1:nrow(table_4))
<<<<<<< Updated upstream

set.seed(86508)
#Call boot
boot_result_FWL <- boot(table_4, beta_1_1, R=1000)


## Plot and Peak Age Estimation

# Function to predict wages for a given age and gender
predict_wage <- function(age, gender) {
  # Extract coefficients from the model
  coefs <- coef(reg2)
  
  # Calculate predicted wage based on age and gender indicator
  predicted_wage <- coefs[1] + coefs[2] * gender + coefs[3] * age + coefs[4] * I(gender*age)
  return(predicted_wage)
}

# Generate age range for plotting
age_range <- seq(min(table_4$age), max(table_4$age), length.out = 100)

# Calculate predicted wages for females and males
female_wages <- predict_wage(age_range, 1)
male_wages <- predict_wage(age_range, 0)

# Plot predicted wages
plot(age_range, female_wages, type = "l", col = "blue", lwd = 2, 
     xlab = "Age", ylab = "Predicted log wage")
lines(age_range, male_wages, type = "l", col = "red", lwd = 2)
legend("topright", legend = c("Female", "Male"), col = c("blue", "red"), 
       lty = 1, lwd = 2)

=======
##

set.seed(86508)
#Call boot
boot(table_4, beta_1_1, R=1000)


## Plot 
>>>>>>> Stashed changes
