package io.keepcoding.spark.exercise.streaming
import org.apache.spark.sql.types.{IntegerType, StringType, StructField, StructType, TimestampType}
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}
import org.apache.spark.sql.functions._

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, Future}

object DevicesStreamingJOb extends StreamingJob {
  override val spark: SparkSession = SparkSession
    .builder()
    .master("local[20]")
    .appName("Final exercise SQL Streaming")
    .getOrCreate()

  import spark.implicits._


  override def readFromKafka(kafkaServer: String, topic: String): DataFrame = {
    spark
      .readStream
      .format("kafka")
      .option("kafka.bootstrap.servers", kafkaServer)
      .option("subscribe",topic)
      .load()
  }

  override def parserJsonData(dataFrame: DataFrame): DataFrame = {
    val jsonSchema = StructType(Seq(
      StructField("bytes", IntegerType,nullable = false),
      StructField("timestamp", IntegerType,nullable = false),
      StructField("app", StringType,nullable = false),
      StructField("id", StringType,nullable = false),
      StructField("antenna_id", StringType,nullable = false),
    ))

    dataFrame
      .select(from_json($"value".cast(StringType), jsonSchema).as("json"))
      .select($"json.*")

  }

  override def readDevicesMetadata(jdbcURI: String, jdbcTable: String, user: String, password: String): DataFrame = {
    spark
      .read
      .format("jdbc")
      .option("url", jdbcURI)
      .option("dbtable", jdbcTable)
      .option("user", user)
      .option("password",password)
      .load()

  }

  override def enrichDevicesWithMetadata(devicesDF: DataFrame, metadataDF: DataFrame): DataFrame = {
    devicesDF.as("a")
      .join(
        metadataDF.as("b"),
        $"a.id"===$"b.id"
      )
      .drop($"b.id")
  }

  override def computeBytesCountByAntenna(dataFrame: DataFrame): DataFrame = {

    dataFrame
      .select($"timestamp".cast(TimestampType),$"bytes",$"antenna_id")
      .withWatermark("timestamp","1 minute") //1 minute
      .groupBy($"antenna_id", window($"timestamp","5 minutes").as("window")) //5 minutos
      .agg(
        sum($"bytes").as("antenna_bytes_total")
      )
      .select($"antenna_id".as("id"),$"window.start".as("timestamp"), $"antenna_bytes_total".as("value"))
  }

  override def computeBytesCountByUser(dataFrame: DataFrame): DataFrame = {

    dataFrame
      .select($"timestamp".cast(TimestampType), $"bytes", $"id")
      .withWatermark("timestamp", "1 minute") //1 minute
      .groupBy($"id", window($"timestamp", "5 minutes").as("window")) //5 minutos
      .agg(
        sum($"bytes").as("user_bytes_total")
      )
      .select($"id", $"window.start".as("timestamp"), $"user_bytes_total".as("value"))
  }

  override def computeBytesCountByApp(dataFrame: DataFrame): DataFrame = {

    dataFrame
      .select($"timestamp".cast(TimestampType), $"bytes", $"app")
      .withWatermark("timestamp", "1 minute") //1 minute
      .groupBy($"app", window($"timestamp", "5 minutes").as("window")) //5 minutos
      .agg(
        sum($"bytes").as("app_bytes_total")
      )
      .select($"app".as("id"), $"window.start".as("timestamp"), $"app_bytes_total".as("value"))
  }


  override def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String, typemetric: String) : Future[Unit] = Future {

    dataFrame
      .writeStream
      .foreachBatch{
        (batch: DataFrame,_: Long) => {
          batch
            .withColumn("type",lit(typemetric))
            .select(
              $"timestamp", $"id", $"value",$"type"
            )
            .write
            .mode(SaveMode.Append)
            .format("jdbc")
            .option("url", jdbcURI)
            .option("dbtable", jdbcTable)
            .option("user", user)
            .option("password", password)
            .save()
        }
   }
      .start()
      .awaitTermination()
  }



  override def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Future[Unit] = Future {

    dataFrame
      .select(
        $"id",$"timestamp".cast(TimestampType),$"app",$"antenna_id",$"bytes",
        year($"timestamp".cast(TimestampType)).as("year"),
        month($"timestamp".cast(TimestampType)).as("month"),
        dayofmonth($"timestamp".cast(TimestampType)).as("day"),
        hour($"timestamp".cast(TimestampType)).as("hour")
      )
      .writeStream
      .format("parquet")
      .option("path", s"$storageRootPath/data")
      .option("checkpointLocation",s"$storageRootPath/checkpoint")
      .partitionBy("year","month","day","hour")
      .start()
      .awaitTermination()
  }



  def main(args: Array[String]): Unit ={
    //run(args)
    val IpServer = "34.66.202.66"

    /// data base info in postgresql
    val url = s"jdbc:postgresql://$IpServer:5432/postgres"
    val driver = "org.postgresql.Driver"
    val username = "postgres"
    val password = "keepcoding"

    val kafkaDF = readFromKafka("35.228.198.113:9092","devices")
    val parseDF = parserJsonData(kafkaDF)

    val storagefuture = writeToStorage(parseDF, "/tmp/devices/")

    val metadataDF = readDevicesMetadata(url, "user_metadata", username, password)

    val enrichDF = enrichDevicesWithMetadata(parseDF,metadataDF)

    val countByAntenna = computeBytesCountByAntenna(enrichDF)
    val countByUser = computeBytesCountByUser(enrichDF)
    val countByApp = computeBytesCountByApp(enrichDF)

    val jdbcFuture1 = writeToJdbc(countByAntenna, url,"bytes",username,password,"antenna_bytes_total")
    val jdbcFuture2 = writeToJdbc(countByUser, url,"bytes",username,password,"user_bytes_total")
    val jdbcFuture3 = writeToJdbc(countByApp, url,"bytes",username,password,"app_bytes_total")



    Await.result(Future.sequence(Seq(storagefuture,jdbcFuture1,jdbcFuture2,jdbcFuture3)), Duration.Inf)


//    parseDF
//      .writeStream
//      .format("console")
//      .start()
//      .awaitTermination()

  }

}
