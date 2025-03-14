from pyflink.table import EnvironmentSettings, TableEnvironment

# Set up the streaming Table environment
env_settings = EnvironmentSettings.new_instance().in_streaming_mode().build()
t_env = TableEnvironment.create(env_settings)

# Define Kafka source table using JSON format
t_env.execute_sql("""
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
""")

# Define a JDBC sink table
t_env.execute_sql("""
CREATE TABLE postgres_sink (
    session_start TIMESTAMP(3),
    session_end TIMESTAMP(3),
    trip_count BIGINT,
    total_distance DOUBLE,
    total_tip DOUBLE
) WITH (
    'connector' = 'jdbc',
    'url' = 'jdbc:postgresql://postgres:5432/postgres',
    'table-name' = 'green_trips_session',
    'username' = 'postgres',
    'password' = 'postgres'
)
""")

# Use a session window with a 5 minute gap on lpep_dropoff_datetime.
agg_query = """
INSERT INTO postgres_sink
SELECT 
    SESSION_START(lpep_dropoff_datetime, INTERVAL '5' MINUTE) AS session_start,
    SESSION_END(lpep_dropoff_datetime, INTERVAL '5' MINUTE) AS session_end,
    COUNT(*) AS trip_count,
    SUM(trip_distance) AS total_distance,
    SUM(tip_amount) AS total_tip
FROM green_trips
GROUP BY SESSION(lpep_dropoff_datetime, INTERVAL '5' MINUTE)
"""

# Execute the aggregation query
t_env.execute_sql(agg_query)
