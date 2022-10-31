# SQL Tables

```sql
postgres=> \dt
              List of relations
 Schema |       Name       | Type  |  Owner
--------+------------------+-------+----------
 public | bytes            | table | postgres
 public | bytes_hourly     | table | postgres
 public | user_metadata    | table | postgres
 public | user_quota_limit | table | postgres
 ```

 ## Schemas

 `bytes` tabla 

 ```sql
  table_name | column_name |          data_type
------------+-------------+-----------------------------
 bytes      | timestamp   | timestamp without time zone
 bytes      | id          | text
 bytes      | value       | bigint
 bytes      | type        | text
 ```

`bytes_hourly` tabla

 ```sql
   table_name  | column_name |          data_type
--------------+-------------+-----------------------------
 bytes_hourly | timestamp   | timestamp without time zone
 bytes_hourly | id          | text
 bytes_hourly | value       | bigint
 bytes_hourly | type        | text
 ```

`user_metadata` tabla

```sql
  table_name   | column_name | data_type
---------------+-------------+-----------
 user_metadata | id          | text
 user_metadata | name        | text
 user_metadata | email       | text
 user_metadata | quota       | bigint
 ```

 `user_quota_limit` tabla

 ```sql
     table_name    | column_name |          data_type
------------------+-------------+-----------------------------
 user_quota_limit | email       | text
 user_quota_limit | usage       | bigint
 user_quota_limit | quota       | bigint
 user_quota_limit | timestamp   | timestamp without time zone
 ```

## Data Example

`bytes` tabla

```sql
      timestamp      |                  id                  | value  |        type
---------------------+--------------------------------------+--------+---------------------
 2020-09-20 12:12:00 | 00000000-0000-0000-0000-000000000000 |  87368 | antenna_total_bytes
 2020-09-20 13:08:00 | 22222222-2222-2222-2222-222222222222 |  26690 | antenna_total_bytes
 2020-09-20 12:40:00 | 11111111-1111-1111-1111-111111111111 |  74399 | antenna_total_bytes
 2020-09-20 12:56:00 | FACEBOOK                             | 101704 | app_total_bytes
 2020-09-20 12:12:00 | 00000000-0000-0000-0000-000000000015 |   6379 | user_total_bytes
 2020-09-20 12:50:00 | 00000000-0000-0000-0000-000000000006 |  10710 | user_total_bytes
 2020-09-20 12:40:00 | 00000000-0000-0000-0000-000000000004 |  10430 | user_total_bytes
 2020-09-20 12:16:00 | 00000000-0000-0000-0000-000000000019 |  15065 | user_total_bytes
 2020-09-20 12:46:00 | 00000000-0000-0000-0000-000000000002 |  12154 | user_total_bytes
 ...
 ```

 `bytes_hourly` tabla

```sql
      timestamp      |                  id                  |  value  |        type
---------------------+--------------------------------------+---------+---------------------
 2020-09-20 14:00:00 | 00000000-0000-0000-0000-000000000000 |  744091 | antenna_total_bytes
 2020-09-20 14:00:00 | 11111111-1111-1111-1111-111111111111 | 1268740 | antenna_total_bytes
 2020-09-20 14:00:00 | 22222222-2222-2222-2222-222222222222 |  277125 | antenna_total_bytes
 2020-09-20 14:00:00 | 44444444-4444-4444-4444-444444444444 |  269470 | antenna_total_bytes
 2020-09-20 14:00:00 | 33333333-3333-3333-3333-333333333333 |  841659 | antenna_total_bytes
 2020-09-20 14:00:00 | FACETIME                             |  907496 | app_total_bytes
 2020-09-20 14:00:00 | SKYPE                                |  799711 | app_total_bytes
 2020-09-20 14:00:00 | FACEBOOK                             |  873666 | app_total_bytes
 2020-09-20 14:00:00 | TELEGRAM                             |  820212 | app_total_bytes
 2020-09-20 14:00:00 | andres@gmail.com                     |  216534 | mail_total_bytes
 2020-09-20 14:00:00 | juan@gmail.com                       |  177114 | mail_total_bytes
 2020-09-20 14:00:00 | pepe@gmail.com                       |  153946 | mail_total_bytes
 ...
 ```

`user_metadata` tabla

```sql
                  id                  |   name    |        email        |  quota
--------------------------------------+-----------+---------------------+---------
 00000000-0000-0000-0000-000000000001 | andres    | andres@gmail.com    |  200000
 00000000-0000-0000-0000-000000000002 | paco      | paco@gmail.com      |  300000
 00000000-0000-0000-0000-000000000003 | juan      | juan@gmail.com      |  100000
 00000000-0000-0000-0000-000000000004 | fede      | fede@gmail.com      |    5000
 ...
```

`user_quota_limit` tabla

```sql
      email       | usage  | quota  |      timestamp
------------------+--------+--------+---------------------
 andres@gmail.com | 177114 |   1000 | 2020-09-20 14:00:00
 juan@gmail.com   | 191110 | 100000 | 2020-09-20 14:00:00
 fede@gmail.com   | 155772 |   5000 | 2020-09-20 14:00:00
 ...
 ```



# Batch Storage

```
└── year=2020
    └── month=9
        └── day=20
            ├── hour=12
            │   └── part-00000-764838e5-3854-41d0-893c-50a9756f0417.c000.snappy.parquet
            ├── hour=13
            │   └── part-00000-764a5890-3693-4e82-96b0-6e39dbb73b8c.c000.snappy.parquet
            └── hour=14
                ├── part-00000-2a10f96b-66b5-4443-9c25-452e193ff98f.c000.snappy.parquet
                ├── part-00000-32b30291-22f8-4bf5-9bd8-755990dba6ec.c000.snappy.parquet
                ├── part-00000-46ac3006-639b-49e8-a6c4-22b1b7440ed0.c000.snappy.parquet
                ├── part-00000-4fe30bc6-d3fb-4e47-a641-1df7bfd71034.c000.snappy.parquet
                ├── part-00000-55f12217-cd8d-4d1f-9d04-a71272bfb480.c000.snappy.parquet
                ├── part-00000-5891e315-b67c-44c5-8ee1-f83c92fa8f7a.c000.snappy.parquet
                ├── part-00000-61894e01-21c9-4050-a832-441a1d9237b3.c000.snappy.parquet
                ├── part-00000-6494fb22-0f91-4531-83d0-3a29ddff484c.c000.snappy.parquet
                ├── part-00000-897a3081-be38-4766-b86e-ac95d03b603a.c000.snappy.parquet
                ├── part-00000-b5367a72-5d30-4a30-8810-8d6b1d8c696d.c000.snappy.parquet
                ├── part-00000-cd101019-d6f8-46bf-b0b5-7c43182316ea.c000.snappy.parquet
                └── part-00000-edd6247b-35f4-4a8a-be23-8892d471da87.c000.snappy.parquet
```

Los ficheros parquet, tienen el contenido RAW de los mensajes de kafka, exceptuando la marca temporal que se desglosa en las carpetas de particionado.
