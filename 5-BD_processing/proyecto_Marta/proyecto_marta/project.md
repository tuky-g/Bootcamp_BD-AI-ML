# Big Data Processing Project

En este proyecto vamos a construir una [arquitectura lambda](https://en.wikipedia.org/wiki/Lambda_architecture) para el procesamiento de datos recolectados desde antenas de telefonía movil. Una arquitectura lambda se separa en tres capas:

* **Speed Layer**: Capa de procesamiento en streaming. Computa resultados en tiempo real y baja latencia.
* **Batch Layer**: Capa de procesamiento por lotes. Computa resultados usando grande cantidades de datos, alta latencia.
* **Serving Layer**: Capa encargada de servir los datos, es nutrida por las dos capas anteriores.

En nuestro proyecto usaremos las distintas tecnologías para cubrir los requisitos demandados por las distintas capas:

* **Speed Layer**: [Spark Structured Streaming](https://spark.apache.org/docs/latest/structured-streaming-programming-guide.html), [Apache Kafka](https://kafka.apache.org/), [Google Compute Engine](https://cloud.google.com/compute)
* **Batch Layer**: [Spark SQL](https://spark.apache.org/docs/latest/sql-programming-guide.html), [Google Cloud Storage](https://cloud.google.com/storage)
* **Serving Layer**: [Google SQL(PostgreSQL)](https://cloud.google.com/sql/docs/postgres), [Apache Superset](https://superset.incubator.apache.org/)

## Source of data

En este proyecto vamos a trabajar con 3 fuentes de datos:

1. Uso de datos de los dispositivos móviles.
2. Base de datos con información de los usuarios.

[Información extensa de las fuentes de datos](./datasources.md)

## Data flow

Es importante conocer el flujo de los datos y su comportamiento, en nuestro proyecto tenemos las 2 fuentes de datos mencionadas anteriormente:

La fuente 1 enviada desde las antenas son una fuente de datos en realtime que llegaran al sistema de mensajes de Apache Kafka. En nuestro proyecto vamos a usar un simulador que enviara información sobre 5 antenas y 20 dispositivos móviles a Kafka.

* Información de los dispositivos móviles -> KAFKA_TOPIC: `devices`

Por otro lado, tenemos la fuente (2) que son las base de datos, que suelen ser modificadas por operarios a través de un servidor web (ingenieros que administran las antenas, comerciales que registran nuevos clientes, etc). En nuestro proyecto usaremos un provisionador que rellenara las tablas con información estática que tiene relación con la fuente 1.

## What? Where? Why? & How? 

Podemos ver el funcionamiento de nuestra arquitectura en la siguiente [página](./wwwh.md)

## Environment

### Speed Layer

En primer lugar vamos a empezar a crear y configurar nuestro sistema de speed layer, para ellos vamos a crear una instancia en google compute engine, y vamos a configurarla para poder hacer funcionar un broker de Apache Kafka, donde se recibirán los mensajes en tiempo real de las fuentes 1 y 2. [Google Compute Instance Setup Guide](./vm_setup.md)

Una vez tenemos nuestra instancia, con las reglas firewall aplicadas correctamente y kafka funcionando, podemos probar a producir datos. En este proyecto usaremos un simulador de datos, este simulador será un docker `andresgomezfrr/data-simulator:1.1`. Podemos ejecutarlo en otra conexión dentro la instancia de google, abrimos una nueva ventana o usamos una de las que tenemos disponibles y ejecutamos el siguiente comando, sustituyendo la dirección IP pública de la instancia de google:
```bash
docker run -it -e KAFKA_SERVERS=${INSTANCE_PUBLIC_IP}:9092 andresgomezfrr/data-simulator:1.1
```

Podemos comprobar a consumir desde otra terminal y comprobar que recibimos datos correctamente:
```bash
/root/kafka_2.12-2.8.0/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic devices
```
Ejemplo:

```shell
root@instance-1:~/kafka_2.12-2.8.0# bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic devices
{"bytes":9082,"timestamp":1600545287,"app":"SKYPE","id":"00000000-0000-0000-0000-000000000001","antenna_id":"00000000-0000-0000-0000-000000000000"}
{"bytes":9647,"timestamp":1600545287,"app":"TELEGRAM","id":"00000000-0000-0000-0000-000000000002","antenna_id":"00000000-0000-0000-0000-000000000000"}
{"bytes":1515,"timestamp":1600545287,"app":"FACEBOOK","id":"00000000-0000-0000-0000-000000000003","antenna_id":"00000000-0000-0000-0000-000000000000"}
{"bytes":1411,"timestamp":1600545287,"app":"FACETIME","id":"00000000-0000-0000-0000-000000000004","antenna_id":"00000000-0000-0000-0000-000000000000"}
{"bytes":4842,"timestamp":1600545287,"app":"FACEBOOK","id":"00000000-0000-0000-0000-000000000005","antenna_id":"00000000-0000-0000-0000-000000000000"}
{"bytes":1432,"timestamp":1600545287,"app":"FACETIME","id":"00000000-0000-0000-0000-000000000006","antenna_id":"00000000-0000-0000-0000-000000000000"}
{"bytes":810,"timestamp":1600545287,"app":"TELEGRAM","id":"00000000-0000-0000-0000-000000000007","antenna_id":"00000000-0000-0000-0000-000000000000"}
...
```

Ahora que ya tenemos los datos en Kafka, es el momento de crear nuestro job de Spark Structured Streaming para conseguir lás métricas y almacenar el histórico de datos tal y como se explica en la sección de [What? Where? Why? & How?](./wwwh.md)

Ejecutaremos el job de spark dentro de DataProc/Local e indicar por argumento:
* La dirección del broker de kafka, es decir la dirección IP pública de nuestra instancía.
* La cadena de conexión JDBC para conectarse con GoogleSQL.
* La URI de Google Cloud Storage donde se almacenara el histórico de datos en parquet.

**NOTAS:** 
* Hay que crear la tabla en postgresql antes de ejecutar el job de structuredStreaming.
* Debemos de configurar en sbt la version de spark a 3.x.x y añadirle el scope `provided`, ya que estas dependencias estaran en DataProc.

Podemos modelar todas las métricas agregadas de bytes en una tabla como la siguiente:
```sql
CREATE TABLE bytes(timestamp TIMESTAMP, id TEXT, value BIGINT, type TEXT);
```

* **timestamp**: marca de tiempo format TimestampType en spark
* **id**: cualquier identificador dependiendo de la métrica podría ser: `id`, `antenna_id`, `app`
* **value**: valor total de bytes, aunque podría ser cualquier valor numerico: LongType o IntType
* **type**: nombre de la métrica por ejemplo: `app_bytes_total`, `antenna_bytes_total`

Este formato de tabla, nos permite guardar todas las métricas resultantes del job de structuredStreaming dentro de una misma tabla, es deber del job adaptar los datos para que cumplan con este esquema de salida.

### Batch Layer

En esta capa vamos trabajar con los datos que el job de structuredStreaming va creando en el storage. El job de batch (sparkSQL) deberá cargar estos datos filtrando por hora y calcular las métricas que hemos visto anteriormente:
* Total de bytes recibidos por antena.
* Total de bytes transmitidos por mail de usuario.
* Total de bytes transmitidos por aplicación.
* Email de usuarios que han sobrepasado la cuota por hora.

Para calcular estas métricas usara los datos volcados por el job de structured streaming y necesitara acceder a la tabla de metadatos de usuario para descubrir los emails y las quotas de los usuarios. Los resultado pueden volcarse en unas tablas mediante conexión jdbc, que pueden tener unos schema como los siguientes:

```sql
CREATE TABLE bytes_hourly(timestamp TIMESTAMP, id TEXT, value BIGINT, type TEXT);
CREATE TABLE user_quota_limit(email TEXT, usage BIGINT, quota BIGINT, timestamp TIMESTAMP);
```

### Serving Layer

Una vez tenemos todos los datos en nuestra capa de servicios (PostgreSQL), podemos conectarnos a la base de datos, como se ve en una de las sesiones y consultar los datos, para verificar que todo funciona correctamente.

**OPCIONAL**: Podemos usar una interfaz web, Apache superset para acceder a la base de datos y mostrar algunos gráficos con la información.

**APACHE SUPERSET**

* Instalamos docker compose:
    ```bash
    sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    ```
    ```bash
    sudo chmod +x /usr/local/bin/docker-compose
    ```

* Descargamos y ejecutamos superset:
    ```bash
    git clone https://github.com/apache/incubator-superset.git
    ```
    ```bash
    cd incubator-superset && docker-compose up
    ```
* Una vez termina el despliegue tenemos que añadir el puerto 8088 para que sea accesible desde el exterior como configuramos el puerto de kafka 9092.
    ```bash
    gcloud compute --project=${PROJECT_ID} firewall-rules create superset --direction=INGRESS --priority=1000 --network=default --action=ALLOW --rules=tcp:8088 --source-ranges=0.0.0.0/0 --target-tags=superset
    ```
    y añadimos la etiqueda a nuestra instancia.
* Después de acceder a superset por un navegador http://${IP_PUBLICA_INSTANCIA}:8088 user: `admin`, password: `admin`, podemos crear la conexión a la base de datos.
![](../images/superset_create.png)
![](../images/superset_graph.png)


## Entrega

* [Mínimo requerido] Repositorio git o archivo comprimido con el código fuente del job en streaming y batch de spark.
* Capturas de pantalla de resultados: tablas de psql, datos en el blob storage.
* Pequeña memoría a nivel conceptual el funcionamiento del proyecto.
* [Opcional] Capturas de superset.
