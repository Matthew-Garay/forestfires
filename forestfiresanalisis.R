
#Región: Parque Natural de Montesinho, Zona oreste de Portugal
# Leer el dataset
forestfires <- read.csv("forestfires.csv")
set.seed(123)
print(forestfires)
cat("Dimensiones del dataset ForestFires:", dim(forestfires), "\n")
summary(forestfires)

#Librerias usadas
if (!require(ggplot2)) install.packages("ggplot2")
library(ggplot2)

if (!require(dplyr)) install.packages("dplyr")
library(dplyr)

if (!require(rpart)) install.packages("rpart")
library(rpart)

if (!require(e1071)) install.packages("e1071")
library(e1071)

if (!require(rpart.plot)) install.packages("rpart.plot")
library(rpart.plot)

if (!require(randomForest)) install.packages("randomForest")
library(randomForest)

#Grafico de barras mes vs area quemada 
area_por_mes <- forestfires %>%
  group_by(month) %>%
  summarise(area_total = sum(area)) %>%
  arrange(desc(area_total))

library(ggplot2)
ggplot(area_por_mes, aes(x = reorder(month, -area_total), y = area_total)) +
  geom_bar(stat = "identity", fill = "blue") +
  labs(title = "Total de área quemada por mes",
       x = "Mes del año",
       y = "Área quemada total (hectáreas)") +
  theme_minimal()

#En Portugal, los meses de julio, agosto y septiembre son los más calurosos al ser verano asi como vacaciones. 
#El calor seco o poca humedad favorece la inflamabilidad de la vegetación.
#Agosto se pondria por encima pero en ese mes hubo llovio ciertos dias

#Frecuencia de incendios por mes
table(forestfires$month) #los meses de agostos,septimebre y marzo hubo mas frecuencias de incendios

#Frecuencia de incendios por dias
table(forestfires$day)   #Los Viernes Sabados y domingos hubo mucha frecuencia de incendios



#Temperatura y viento
# Modelo Regresion lineal múltiple
multi_reg <- lm(temp ~ FFMC+DMC+DC+ISI+RH+wind+area, data = forestfires)
summary(multi_reg)
ggplot() +
  geom_point(aes(x = forestfires$wind, y = forestfires$temp), colour = "red") +
  geom_line(aes(x = forestfires$wind,
                y = predict(multi_reg, newdata = forestfires)), colour = "blue") +
  ggtitle("¿Qué pasa si hay alta temperatura y alto viento?🔥") +
  xlab("Viento") +
  ylab("Temperatura")


forestfires$wind2= forestfires$wind^2
forestfires$wind3= forestfires$wind^3
forestfires$wind4= forestfires$wind^4

poly_reg <- lm (formula= temp~.,data=forestfires)

# Modelo Regresion lineal múltiple
multi_reg <- lm(temp ~ FFMC+DMC+DC+ISI+RH+wind+area, data = forestfires)
summary(multi_reg)
ggplot() +
  geom_point(aes(x = forestfires$wind, y = forestfires$temp), colour = "red") +
  geom_line(aes(x = forestfires$wind,
                y = predict(poly_reg, newdata = forestfires)), colour = "blue") +
  ggtitle("¿Qué pasa si hay alta temperatura y alto viento?🔥") +
  xlab("Viento") +
  ylab("Temperatura")

#Si temp baja pero viento alto, puede haber propagación rápida aunque el fuego inicial sea menor.
#Si temp alta pero viento bajo, puede haber incendio pero con menor propagación.

#Maquina de vectores de soporte
regression1 <- svm(formula = temp ~ wind,
                   data = forestfires,
                   type = "eps-regression",  
                   kernel = "radial")        
summary(regression1) #478 vectores de soporte


regression3 <- svm(formula = temp ~ wind,
                   data = forestfires,
                   type = "eps-regression",  
                   kernel = "sigmoid")        
summary(regression3)#514 vectores de soporte 
#Por la cantidad de cosas que intercatuan en los datos 

# Random Forest
regression1 = randomForest(temp ~ wind,
                          data = forestfires,  # Especificar el dataset completo
                          ntree = 500)
plot(regression1)

#arboles de desicion
modelo_temp_wind <- rpart(log(area + 1) ~ temp + wind,
                          data = forestfires, method = "anova")
rpart.plot(modelo_temp_wind, main = "Propagacion según temperatura y viento")
summary(modelo_temp_wind)


#Temperatura y Humedad
multi_reg_temp_rh <- lm(temp ~ FFMC + DMC + DC + ISI + RH + wind + area, data = forestfires)
summary(multi_reg_temp_rh)
ggplot() +
  geom_point(aes(x = forestfires$RH, y = forestfires$temp), colour = "red") +
  geom_line(aes(x = forestfires$RH,
                y = predict(multi_reg_temp_rh, newdata = forestfires)), colour = "blue") +
  ggtitle("¿Cómo afecta la humedad a la temperatura? 🌡️💧") +
  xlab("Humedad relativa (%)") +
  ylab("Temperatura (°C)")
# En climas más secos (RH baja), la temperatura tiende a ser más alta → mayor riesgo de incendio.
# En climas menos secos (RH sube), la temperatura tiende a ser baja → menor riesgo de incendio.


#Maquina de vectores de soporte
svm_radial_temp_rh <- svm(temp ~ RH,
                          data = forestfires,
                          type = "eps-regression",
                          kernel = "radial")
summary(svm_radial_temp_rh)#460

svm_sigmoid_temp_rh <- svm(temp ~ RH,
                           data = forestfires,
                           type = "eps-regression",
                           kernel = "sigmoid")
summary(svm_sigmoid_temp_rh)#512

# Random Forest
regression2 = randomForest(temp ~ RH,
                           data = forestfires,  # Especificar el dataset completo
                           ntree = 500)
plot(regression2)

#Arbol de desicion
modelo_arbol_temp_rh <- rpart(log(area + 1) ~ RH + temp,
                              data = forestfires,
                              method = "anova")

# Visualizar el árbol
rpart.plot(modelo_arbol_temp_rh, main = "Propagación según temperatura y humedad 🌿🔥")




#ISI indice de propagacion inicial vs Wind viento 
multi_reg_isi_wind <- lm(ISI ~ wind + FFMC + DMC + DC + RH + temp + area, data = forestfires)
summary(multi_reg_isi_wind)
ggplot() +
  geom_point(aes(x = forestfires$wind, y = forestfires$ISI), colour = "red") +
  geom_line(aes(x = forestfires$wind,
                y = predict(multi_reg_isi_wind, newdata = forestfires)), colour = "blue") +
  ggtitle("ISI vs Viento 🔥🌬️") +
  xlab("Viento") +
  ylab("ISI (propagación del fuego)")
#A mayor velocidad del viento, las llamas se inclinan y el fuego se propaga más rápidamente.
## A menor viento, el ISI suele ser bajo → el fuego se propaga más lentamente.

#maquina de vectores de soporte
svm_radial_isi_wind <- svm(ISI ~ wind, 
                           data = forestfires, 
                           type = "eps-regression", 
                           kernel = "radial")
summary(svm_radial_isi_wind)#456 vectores de soporte

svm_sigmoid_isi_wind <- svm(ISI ~ wind, 
                            data = forestfires, 
                            type = "eps-regression", 
                            kernel = "sigmoid")
summary(svm_sigmoid_isi_wind)#500 vectores de soporte

# Random Forest
regression3 = randomForest(ISI ~ wind,
                           data = forestfires,  # Especificar el dataset completo
                           ntree = 500)
plot(regression3)




#FFMC humedada del combustible fino VS ISI Indice de propagacaion inicial
multi_reg_isi_ffmc <- lm(FFMC ~ ISI + DMC + DC + RH + temp + area, data = forestfires)
summary(multi_reg_isi_ffmc)
ggplot() +
  geom_point(aes(x = forestfires$FFMC, y = forestfires$ISI), colour = "red") +
  geom_line(aes(x = forestfires$FFMC,
                y = predict(multi_reg_isi_ffmc, newdata = forestfires)), colour = "blue") +
  ggtitle("¿Cómo influye el FFMC en la propagación? 🌲🔥") +
  xlab("FFMC humedad del combustible fino") +
  ylab("ISI indice de propgacion inicial")
#Un FFMC alto o combustibles flamables, combinado con viento fuerte, resultará en un ISI muy alto o una propagacion facil. 
#Un FFMC bajo o combustibles flamables, combinado con viento fuerte, resultará en un ISI no alto o una propagacion facil. 


#maquina de vectores de soporte
svm_radial_isi_ffmc <- svm(ISI ~ FFMC, 
                           data = forestfires, 
                           type = "eps-regression", 
                           kernel = "radial")
summary(svm_radial_isi_ffmc)#438

svm_sigmoid_isi_ffmc <- svm(ISI ~ FFMC, 
                            data = forestfires, 
                            type = "eps-regression", 
                            kernel = "sigmoid")
summary(svm_sigmoid_isi_ffmc)#514


# Random Forest
 
regression4 = randomForest(ISI ~ FFMC,
                           data = forestfires,  # Especificar el dataset completo
                           ntree = 500)
plot(regression4)

modelo_arbol_isi_ffmc <- rpart(log(area + 1) ~ FFMC + ISI, data = forestfires, method = "anova")
rpart.plot(modelo_arbol_isi_ffmc, main = "Propagación según FFMC e ISI")


