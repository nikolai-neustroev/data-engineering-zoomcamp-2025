{{ config(materialized='table') }}

WITH base AS (
    SELECT
        tripid,
        pickup_datetime,
        dropoff_datetime,
        pickup_locationid,
        dropoff_locationid,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
    FROM {{ ref('dim_fhv_trips') }}
),

base_with_percentiles AS (
    SELECT
        year,
        month,
        pickup_locationid,
        dropoff_locationid,
        trip_duration,
        PERCENTILE_CONT(trip_duration, 0.90) OVER (PARTITION BY year, month, pickup_locationid, dropoff_locationid) AS percentile90
    FROM base
)

SELECT DISTINCT
    year,
    month,
    pickup_locationid,
    dropoff_locationid,
    percentile90
FROM base_with_percentiles
