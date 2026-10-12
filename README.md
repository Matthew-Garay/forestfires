<div align="center">

# 🔥 Forest Fires — Analítica con Machine Learning

**Miniproyecto de analítica de datos** con algoritmos de machine learning sobre incendios forestales del Parque Natural de Montesinho (Portugal).

[![R](https://img.shields.io/badge/R-4.x-276DC3?style=flat-square&logo=r&logoColor=white)](https://www.r-project.org/)
[![ML](https://img.shields.io/badge/Machine%20Learning-Regresi%C3%B3n%20y%20Random%20Forest-6f42c1?style=flat-square)]()
[![Datasets](https://img.shields.io/badge/Registros-517-2ea44f?style=flat-square)]()

</div>

---

## 📖 Descripción

Análisis de datos y **machine learning** sobre los **incendios forestales del Parque Natural de Montesinho**, Portugal (1999–2000). El dataset `forestfires.csv` contiene **517 registros** con variables meteorológicas (temperatura, humedad, viento, índices FWI) y el área quemada. El script busca qué factores se relacionan con la **temperatura, la propagación (ISI) y el área quemada**.

Es un miniproyecto académico que compara múltiples algoritmos sobre el mismo problema de regresión.

## ✨ Características

- **Análisis exploratorio:** distribución del área quemada por mes y frecuencia por día.
- **Regresión lineal múltiple y polinomial** (temperatura vs. viento, ISI vs. viento/FFMC).
- **Máquinas de vectores de soporte (SVM):** kernels *radial* y *sigmoide*.
- **Random Forest** (500 árboles) y **árbol de decisión** (rpart) con visualización `rpart.plot`.
- **Transformación `log(area + 1)`** para manejar la distribución sesgada del área quemada.

## 🛠️ Tecnologías utilizadas

- **Lenguaje:** R
- **Paquetes:** ggplot2, dplyr, rpart, rpart.plot, e1071, randomForest
- **Dataset:** `forestfires.csv` (517 registros, 1999–2000)

## 📋 Requisitos previos

- [R](https://www.r-project.org/) o [RStudio](https://posit.co/download/rstudio-desktop/).
- Los paquetes se **instalan automáticamente** si faltan (`install.packages` condicional).

## 🚀 Instalación

```bash
git clone https://github.com/Matthew-Garay/forestfires.git
cd forestfires
```

## 🧪 Uso

```r
source("forestfiresanalisis.R")
```

El script lee el CSV, instala las librerías que falten y genera gráficas y modelos en secuencia.

## 📂 Estructura del proyecto

```
forestfires/
├── forestfiresanalisis.R      # Script principal de análisis
├── forestfires.csv            # Dataset (517 registros)
├── Miniproyecto Analítica de datos con algoritmos de machine learning.pdf
└── README.md
```

## 📜 Licencia

Proyecto académico y educativo; puedes usarlo libremente con fines de aprendizaje.

## ✍️ Autor

**Matthew Garay** — [GitHub](https://github.com/Matthew-Garay)
