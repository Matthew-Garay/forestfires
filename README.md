# Forest Fires

Analisis de datos con machine learning sobre los incendios del Parque Natural de Montesinho, Portugal. El `forestfires.csv` trae 517 registros del 1999 al 2000 y el script busca que factores se relacionan con la temperatura, la propagacion y el area quemada.

Para cada relacion repite el mismo esquema: regresion lineal, SVM con kernel radial y sigmoide, Random Forest y arbol de decision. El area se predice con `log(area + 1)` porque casi todos los incendios queman cero o casi nada y unos pocos quemaron cientos.

## Requisitos

R o RStudio. El script instala solo lo que le falte (ggplot2, dplyr, rpart, e1071, randomForest).

## Uso

```r
source("forestfiresanalisis.R")
```
