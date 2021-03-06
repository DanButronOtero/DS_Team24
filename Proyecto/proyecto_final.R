# Proyecto final
# Paquetes a ayudar
library(ggplot2)
library(dplyr)
library(scales)

#https://datos.cdmx.gob.mx/dataset/servicios-para-la-poblacion-en-general/resource/59af003e-042e-4aeb-b4f0-8ca9a6600ec4

#Lectura de datos (NOTA: Tambi�n hay API, revisar!)
url_datos <- "https://datos.cdmx.gob.mx/api/3/action/datastore_search?resource_id=59af003e-042e-4aeb-b4f0-8ca9a6600ec4"
url_datos_sql <- 'https://datos.cdmx.gob.mx/api/3/action/datastore_search_sql?sql=SELECT * from "59af003e-042e-4aeb-b4f0-8ca9a6600ec4"'
download.file(url = url_datos_sql, destfile = "./nuevos_datos.csv", mode = "wb")
datos <- read.csv("./servicios-para-la-poblacion-en-general.csv")
summary(datos)
names(datos)

# An�lisis exploratorio
# Histograma de edad (analizar relaci�n con sexo, escolaridad)
# Investigar la relacion edad, genero y escolaridad
# Hora del d�a en la que es m�s probable que suceda un caso de violencia
# 
datos %>%
  ggplot() + 
  aes(edad) +
  geom_histogram(binwidth = 5, col="black", fill = "blue") + 
  ggtitle("Histograma de edades por g�nero") +
  ylab("Frecuencia") +
  xlab("Mediciones") + 
  facet_wrap("sexo")
  theme_light()

datos %>%
    ggplot() + 
    aes(edad) +
    geom_histogram(binwidth = 5, col="black", fill = "blue") + 
    ggtitle("Histograma de edades por g�nero y problema registrado") +
    ylab("Frecuencia") +
    xlab("Mediciones") + 
    facet_wrap("sexo") +
    facet_wrap("tematica_1") +
  theme_light()

# Hist�rico de datos: fecha
class(datos$fecha_alta)
class(datos$hora_alta)

conta_registro_dia <- count(datos, fecha = datos$fecha_alta)
conta_registro_hora <- count(datos, hora = datos$hora_alta)

head(conta_registro_dia)
head(conta_registro_hora)

# Por d�a
df_registro_dia <- data.frame(eje_x=as.Date(conta_registro_dia$fecha), n = conta_registro_dia$n)
head(df_registro_dia)

# Por hora
df_registro_hora <- data.frame(eje_x=conta_registro_hora$hora, n = conta_registro_hora$n)
head(df_registro_hora)

p <- ggplot(df_registro_hora, aes(x=fecha, y=n)) + 
  geom_line( color="blue") + 
  geom_point() +
  labs(x = "Fecha", 
       y = "Acumulado de casos",
       title = paste("Casos de violencia en M�xico:", 
                     format(Sys.time(), 
                            tz="America/Mexico_City", 
                            usetz=TRUE))) +
  theme(plot.title = element_text(size=12))  +
  theme(axis.text.x = element_text(face = "bold", color="#993333" , 
                                   size = 10, angle = 45, 
                                   hjust = 1),
        axis.text.y = element_text(face = "bold", color="#993333" , 
                                   size = 10, angle = 45, 
                                   hjust = 1))  # color, �ngulo y estilo de las abcisas y ordenadas 

p <- p  + scale_x_date(labels = date_format("%d-%m-%Y")) # paquete scales

p <- p +
  theme(plot.margin=margin(10,10,20,10), plot.caption=element_text(hjust=1.05, size=10)) +
  annotate("text", x = df_registro$fecha[round(dim(df_registro[1])*0.4)], y = max(df_registro$n), colour = "blue", size = 5, label = paste("�ltima actualizaci�n: ", df_registro$n[dim(df_registro)[1]]))
p

#21 de marzo de 2020 - Inicio de cuarentena

# Limpieza donde estado_hechos != Null
#Determinar mejores variables, implementar redes neuronales
