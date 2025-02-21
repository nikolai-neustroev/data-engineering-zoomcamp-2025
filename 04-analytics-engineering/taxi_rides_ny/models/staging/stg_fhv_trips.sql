{{ config(materialized='view') }}

WITH tripdata AS (
    SELECT *
    FROM {{ source('staging', 'fhv_tripdata') }}
    WHERE dispatching_base_num IS NOT NULL
)
SELECT
    tripid,
    pickup_datetime,
    dropoff_datetime,
    pickup_locationid,
    dropoff_locationid,
    dispatching_base_num
FROM tripdata
