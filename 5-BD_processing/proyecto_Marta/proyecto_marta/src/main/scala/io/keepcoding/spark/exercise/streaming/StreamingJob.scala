package io.keepcoding.spark.exercise.streaming

import io.keepcoding.spark.exercise.streaming.DevicesStreamingJOb.{computeBytesCountByAntenna, computeBytesCountByApp, computeBytesCountByUser}

import java.sql.Timestamp
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, Future}
import org.apache.spark.sql.{DataFrame, SparkSession}

case class AntennaMessage(timestamp: Timestamp, id: String, metric: String, value: Long)

trait StreamingJob {

  val spark: SparkSession

  def readFromKafka(kafkaServer: String, topic: String): DataFrame

  def parserJsonData(dataFrame: DataFrame): DataFrame

  def readDevicesMetadata(jdbcURI: String, jdbcTable: String, user: String, password: String): DataFrame

  def enrichDevicesWithMetadata(antennaDF: DataFrame, metadataDF: DataFrame): DataFrame

  def computeBytesCountByAntenna(dataFrame: DataFrame): DataFrame

  def computeBytesCountByUser(dataFrame: DataFrame): DataFrame

  def computeBytesCountByApp(dataFrame: DataFrame): DataFrame

  def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String, typemetric: String): Future[Unit]

  def writeToStorage(dataFrame: DataFrame, storageRootPath: String): Future[Unit]

  def run(args: Array[String]): Unit = {
    val Array(kafkaServer, topic, jdbcUri, jdbcMetadataTable, aggJdbcTable, jdbcUser, jdbcPassword, storagePath) = args
    println(s"Running with: ${args.toSeq}")

    val kafkaDF = readFromKafka(kafkaServer, topic)
    val parseDF = parserJsonData(kafkaDF)
    val metadataDF = readDevicesMetadata(jdbcUri, jdbcMetadataTable, jdbcUser, jdbcPassword)
    val enrichDF = enrichDevicesWithMetadata(parseDF, metadataDF)
    val storageFuture = writeToStorage(parseDF, storagePath)
    val countByAntenna = computeBytesCountByAntenna(enrichDF)
    val countByUser = computeBytesCountByUser(enrichDF)
    val countByApp = computeBytesCountByApp(enrichDF)

    val aggFuture1 = writeToJdbc(countByAntenna, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword,"antenna_bytes_total")
    val aggFuture2 = writeToJdbc(countByUser, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword,"user_bytes_total")
    val aggFuture3 = writeToJdbc(countByApp, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword,"app_bytes_total")



    Await.result(Future.sequence(Seq(aggFuture1,aggFuture2,aggFuture3, storageFuture)), Duration.Inf)

    spark.close()
  }

}
