{{ config(materialized='view') }}

WITH tripdata AS (
    SELECT *
    FROM {{ source('staging', 'fhv_tripdata') }}
    WHERE dispatching_base_num IS NOT NULL
)
SELECT
    dispatching_base_num,
    pickup_datetime,
    dropoff_datetime,
    PUlocationID AS pickup_locationid,
    DOlocationID AS dropoff_locationid,
    SR_Flag,
    Affiliated_base_number
FROM tripdata
