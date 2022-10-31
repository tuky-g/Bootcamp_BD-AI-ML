package io.keepcoding.spark.exercise.batch

import java.sql.Timestamp
import java.time.OffsetDateTime
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.duration.Duration
import scala.concurrent.{Await, Future}

import org.apache.spark.sql.{DataFrame, SparkSession}

case class AntennaMessage(year: Int, month: Int, day: Int, hour: Int, timestamp: Timestamp, id: String, metric: String, value: Long)

trait BatchJob {

  val spark: SparkSession

  def readFromStorage(storagePath: String, filterDate: OffsetDateTime): DataFrame

  def readDevicesMetadata(jdbcURI: String, jdbcTable: String, user: String, password: String): DataFrame

  def enrichDevicesWithMetadata(antennaDF: DataFrame, metadataDF: DataFrame): DataFrame

  def computeBytesCountByAntenna(dataFrame: DataFrame): DataFrame

  def computeBytesCountByUser(dataFrame: DataFrame): DataFrame

  def computeBytesCountByApp(dataFrame: DataFrame): DataFrame

  def computeUsersOutOfQuota(devicesDF_hourly: DataFrame, metadataDF: DataFrame): DataFrame

  def writeToJdbc(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String, typemetric: String): Unit

  def writeToJdbc_quota(dataFrame: DataFrame, jdbcURI: String, jdbcTable: String, user: String, password: String): Unit

  def run(args: Array[String]): Unit = {
    val Array(filterDate, storagePath, jdbcUri, jdbcMetadataTable, aggJdbcTable, aggJdbcQuotatable, jdbcUser, jdbcPassword) = args
    println(s"Running with: ${args.toSeq}")

    val parquetDF = readFromStorage(storagePath, OffsetDateTime.parse(filterDate))
    val metadataDF = readDevicesMetadata(jdbcUri, jdbcMetadataTable, jdbcUser, jdbcPassword)
    val enrichDF=enrichDevicesWithMetadata(parquetDF,metadataDF).cache()
    val countByAntenna = computeBytesCountByAntenna(enrichDF)
    val countByUser = computeBytesCountByUser(enrichDF)
    val countByApp = computeBytesCountByApp(enrichDF)

    val users_outOfQuota = computeUsersOutOfQuota(countByUser, metadataDF)

    writeToJdbc(countByAntenna, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword, "antenna_bytes_total")
    writeToJdbc(countByUser, jdbcUri, aggJdbcTable, jdbcUser,jdbcPassword, "user_bytes_total")
    writeToJdbc(countByApp, jdbcUri, aggJdbcTable, jdbcUser, jdbcPassword, "app_bytes_total")

    writeToJdbc_quota(users_outOfQuota,jdbcUri,  aggJdbcQuotatable, jdbcUser, jdbcPassword)

    spark.close()
  }

}
