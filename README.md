# Forest Fires

Miniproyecto de analítica de datos con algoritmos de machine learning. Estudia
los incendios forestales del **Parque Natural de Montesinho**, en la zona
noreste de Portugal, y busca qué factores se relacionan con la temperatura, con
la propagación del fuego y con el área quemada.

## El dataset

`forestfires.csv` tiene 517 registros de 1999 a 2000. De las 13 variables, las
que usa el análisis:

| Variable | Significado |
|----------|-------------|
| `temp` | temperatura en °C |
| `RH` | humedad relativa en % |
| `wind` | velocidad del viento en km/h |
| `ISI` | índice de propagación inicial |
| `FFMC`, `DMC`, `DC` | índices de combustible y humedad del material |
| `area` | superficie quemada en hectáreas |

`month`, `day`, `ffmc`, `dmc` y `dc` son factores.

## Qué hace el script

### Exploración

Resumen dimensional, `print`, `summary`, y luego dos tablas de frecuencia:

```r
table(forestfires$month)   # agosto, septiembre y marzo concentran más incendios
table(forestfires$day)     # viernes, sábado y domingo concentran más incendios
```

Y el área total quemada por mes, que es donde se ve la estacionalidad:

```r
area_por_mes <- forestfires %>%
  group_by(month) %>%
  summarise(area_total = sum(area)) %>%
  arrange(desc(area_total))
```

La lectura que hace el script: julio y agosto son los meses más calurosos y el
calor seco favorece la inflamabilidad de la vegetación, pero agosto no encabeza
el ranking porque llovió algunos días de ese mes.

### Cuatro modelos sobre cada relación

El script repite el mismo esquema para tres relaciones distintas
(temperatura–viento, temperatura–humedad e ISI–viento). Para cada una:

| Modelo | Código |
|--------|--------|
| Regresión lineal múltiple | `lm()` |
| Máquina de vectores de soporte | `svm(..., type = "eps-regression")` con kernel radial y con sigmoid |
| Random Forest | `randomForest(..., ntree = 500)` |
| Árbol de decisión | `rpart(...)` con `rpart.plot()` |

En cada caso compara **número de vectores de soporte**: el kernel radial
necesita unos 460–478 vectores y el sigmoid unos 512–514, porque interactúan
muchas más variables.

### El árbol de propagación

El modelo más interesante es el que predice el área quemada, y para eso usa el
logaritmo:

```r
modelo_temp_wind <- rpart(log(area + 1) ~ temp + wind,
                          data = forestfires, method = "anova")
```

El `log(area + 1)` está porque el área tiene una distribución muy sesgada:
casi todos los incendios queman cero o una fracción de hectárea y unos pocos
quemaron cientos. Sin el logaritmo, esos pocos casos mandan sobre todo el
modelo.

## Cómo ejecutarlo

```r
source("forestfiresanalisis.R")
```

El script va instalando lo que falta con `if (!require(...)) install.packages(...)`,
así que la primera ejecución descarga los paquetes.

## Paquetes

`ggplot2`, `dplyr`, `rpart`, `e1071` (para `svm`), `rpart.plot`, `randomForest`.

```r
install.packages(c("ggplot2", "dplyr", "rpart", "e1071", "rpart.plot", "randomForest"))
```

Se fijó `set.seed(123)` al principio para que el Random Forest y cualquier otra
muestra aleatoria dé el mismo resultado en cada ejecución.
