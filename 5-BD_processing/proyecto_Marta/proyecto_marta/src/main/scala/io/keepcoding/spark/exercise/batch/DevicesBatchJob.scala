package io.keepcoding.spark.exercise.batch
import io.keepcoding.spark.exercise.streaming.DevicesStreamingJOb.readDevicesMetadata
import org.apache.avro.generic.GenericData.StringType
import org.apache.spark.sql.SparkSession.setDefaultSession
import org.apache.spark.sql.functions._
import org.apache.spark.sql.{DataFrame, SaveMode, SparkSession}

import java.time.OffsetDateTime

object DevicesBatchJob extends BatchJob {
  override val spark: SparkSession = SparkSession
    .builder()
    .master("local[20]")
    .appName("Final exercise SQL Streaming")
    .getOrCreate()

  import spark.implicits._

  override def readFromStorage(storagePath: String, filterDate: OffsetDateTime): DataFrame = {

    spark
      .read
      .format("parquet")
      .load(s"$storagePath/data")
      .filter(
        $"year" === filterDate.getYear &&
        $"month" === filterDate.getMonthValue &&
        $"day" === filterDate.getDayOfMonth &&
        $"hour" === filterDate.getHour
      )
  }

  override def readDevicesMetadata(jdbcURI: String, jdbcTable: String, user: String, password: String): DataFrame = {
    spark
      .read
      .format("jdbc")
      .option("url", jdbcURI)
      .option("dbtable", jdbcTable)
      .option("user", user)
      .option("password", password)
      .load()
  }

  override def enrichDevicesWithMetadata(devicesDF: DataFrame, metadataDF: DataFrame): DataFrame = {
    devicesDF.as("a")
      .join(
        metadataDF.as("b"),
        $"a.id" === $"b.id"
      )
      .drop($"b.id")
  }

  override def computeBytesCountByAntenna(dataFrame: DataFrame): DataFrame = {
    dataFrame
      .select($"timestamp", $"bytes", $"antenna_id")
      .groupBy($"antenna_id", window($"timestamp", "1 hour").as("window"))
      .agg(
        sum($"bytes").as("antenna_bytes_total")
      )
      .select($"antenna_id".as("id"), $"window.start".as("timestamp"), $"antenna_bytes_total".as("value"))
  }



  override def computeBytesCountByUser(dataFrame: DataFrame): DataFrame = {

    dataFrame
      .select($"timestamp", $"bytes", $"id")
      .groupBy($"id", window($"timestamp", "1 hour").as("window"))
      .agg(
        sum($"bytes").as("user_bytes_total")
      )
      .select($"id", $"window.start".as("timestamp"), $"user_bytes_total".as("value"))
  }

  override def computeBytesCountByApp(dataFrame: DataFrame): DataFrame = {
    dataFrame
      .select($"timestamp", $"bytes", $"app")
      .groupBy($"app", window($"timestamp", "1 hour").as("window"))
      .agg(
        sum($"bytes").as("app_bytes_total")
      )
      .select($"app".as("id"), $"window.start".as("timestamp"), $"app_bytes_total".as("value"))
  }

  override def computeUsersOutOfQuota(devicesDF_hourly: DataFrame, metadataDF: DataFrame): DataFrame = {

    devicesDF_hourly.as("a")
      .join(
        metadataDF.as("b"),
        $"a.id" === $"b.id"
      )
      .drop($"b.id")
      .filter(
        $"value">$"quota"
      )
  }

  override def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String, typemetric: String): Unit = {
    dataFrame
      .withColumn("type", lit(typemetric))
      .select(
        $"timestamp", $"id", $"value", $"type"
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

  override def writeToJdbc_quota(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String): Unit = {

//    campos en tabla postgresql email TEXT, usage BIGINT, quota BIGINT, timestamp TIMESTAMP

    dataFrame
      .select(
        $"email",$"value".as("usage"),$"quota",$"timestamp"
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

  def main(args: Array[String]): Unit = {
    val IpServer = "34.66.202.66"

    /// data base info in postgresql
    val url = s"jdbc:postgresql://$IpServer:5432/postgres"
    val driver = "org.postgresql.Driver"
    val username = "postgres"
    val password = "keepcoding"
    val offsetDateTime = OffsetDateTime.parse("2022-10-31T13:00:00Z")

    val parquetDF = readFromStorage("/tmp/devices/",offsetDateTime)

    val metadataDF = readDevicesMetadata(url, "user_metadata", username, password)

    val enrichDF=enrichDevicesWithMetadata(parquetDF,metadataDF).cache()

    val countByAntenna = computeBytesCountByAntenna(enrichDF)
    val countByUser = computeBytesCountByUser(enrichDF)
    val countByApp = computeBytesCountByApp(enrichDF)


    val jdbcFuture1 = writeToJdbc(countByAntenna, url, "bytes_hourly", username, password, "antenna_bytes_total")
    val jdbcFuture2 = writeToJdbc(countByUser, url, "bytes_hourly", username, password, "user_bytes_total")
    val jdbcFuture3 = writeToJdbc(countByApp, url, "bytes_hourly", username, password, "app_bytes_total")

    val users_outOfQuota = computeUsersOutOfQuota(countByUser, metadataDF)

    val jdbcquota = writeToJdbc_quota(users_outOfQuota,url, "user_quota_limit", username, password)



    users_outOfQuota
      .show(truncate = false)
  }

}
