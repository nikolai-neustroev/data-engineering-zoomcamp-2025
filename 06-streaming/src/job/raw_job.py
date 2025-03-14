#!/usr/bin/env python3
import logging
from pyflink.table import EnvironmentSettings, TableEnvironment

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def main():
    logger.info("Starting job to transfer data from Kafka to Postgres...")

    # Create a streaming TableEnvironment
    env_settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
    t_env = TableEnvironment.create(env_settings)

    # Create a Kafka source table (reading JSON messages)
    source_ddl = """
    CREATE TABLE green_trips (
         lpep_pickup_datetime TIMESTAMP(3),
         lpep_dropoff_datetime TIMESTAMP(3),
         PULocationID INT,
         DOLocationID INT,
         passenger_count INT,
         trip_distance DOUBLE,
         tip_amount DOUBLE,
         WATERMARK FOR lpep_dropoff_datetime AS lpep_dropoff_datetime - INTERVAL '5' SECOND
    ) WITH (
         'connector' = 'kafka',
         'topic' = 'green-trips',
         'properties.bootstrap.servers' = 'redpanda-1:29092',
         'properties.group.id' = 'green_trips_group',
         'scan.startup.mode' = 'earliest-offset',
         'format' = 'json'
    )
    """
    logger.info("Creating Kafka source table green_trips...")
    t_env.execute_sql(source_ddl)

    # Create a JDBC sink table in Postgres to store the raw data
    sink_ddl = """
    CREATE TABLE postgres_sink (
         lpep_pickup_datetime TIMESTAMP(3),
         lpep_dropoff_datetime TIMESTAMP(3),
         PULocationID INT,
         DOLocationID INT,
         passenger_count INT,
         trip_distance DOUBLE,
         tip_amount DOUBLE
    ) WITH (
         'connector' = 'jdbc',
         'url' = 'jdbc:postgresql://postgres:5432/postgres',
         'table-name' = 'raw_green_trips',
         'username' = 'postgres',
         'password' = 'postgres'
    )
    """
    logger.info("Creating JDBC sink table postgres_sink...")
    t_env.execute_sql(sink_ddl)

    # Insert all data from Kafka source into the Postgres sink
    insert_query = """
    INSERT INTO postgres_sink
    SELECT 
         lpep_pickup_datetime,
         lpep_dropoff_datetime,
         PULocationID,
         DOLocationID,
         passenger_count,
         trip_distance,
         tip_amount
    FROM green_trips
    """
    logger.info("Executing INSERT query to transfer data from Kafka to Postgres...")
    t_env.execute_sql(insert_query)

    logger.info("Job submitted; data will now be transferred from Kafka to Postgres.")

if __name__ == '__main__':
    main()
