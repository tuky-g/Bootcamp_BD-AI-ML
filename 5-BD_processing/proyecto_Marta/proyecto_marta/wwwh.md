### [back](./project.md)

# What? Where? Why? & How? 

En nuestra arquitectura lambda vamos a hacer distintos procesamientos, con la finalidad de ofrece:

1. Un servicio de analíticas de clientes.
2. Un datalake de información histórica agregada.

## Speed Layer

### Un servicio de analíticas de clientes.

* Recolecta las métricas de los antenas y son almacenadas en Apache Kafka en tiempo real.
* Spark Structured Streaming, hace métricas agregadas cada 5 minutos y guarda en PostgreSQL.
    * Total de bytes recibidos por antena.
    * Total de bytes transmitidos por id de usuario. 
    * Total de bytes transmitidos por aplicación
* Spark Structured Streaming, también enviara los datos en formato PARQUET a un almacenamiento de google cloud storage, particionado por AÑO, MES, DIA, HORA.

## Batch Layer

Tendremos un job de SparkSQL que sea capaz de calcular para un AÑO, MES, DIA, HORA, pasados por argumentos, las métricas siguientes en base al servicio:
Todas las métricas serán almacenadas en PostgreSQL.

### Un servicio de analíticas de clientes.
* Total de bytes recibidos por antena.
* Total de bytes transmitidos por mail de usuario.
* Total de bytes transmitidos por aplicación.
* Email de usuarios que han sobrepasado la cuota por hora.

## Serving Layer

La serving layer, sera un conjuntos de dashboard en superset que ataquen a la base de datos PostgreSQL y obtengan las métricas generadas por la speed layer y por la batch layer.

### [back](./project.md)