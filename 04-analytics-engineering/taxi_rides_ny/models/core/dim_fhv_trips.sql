{{ config(materialized='table') }}

WITH fhv_trips AS (
    SELECT *
    FROM {{ ref('stg_fhv_trips') }}
),
dim_zones AS (
    SELECT *
    FROM {{ ref('dim_zones') }}
    WHERE borough != 'Unknown'
)
SELECT
    fhv_trips.dispatching_base_num,
    fhv_trips.pickup_datetime,
    fhv_trips.dropoff_datetime,
    fhv_trips.pickup_locationid,
    pickup_zone.zone AS pickup_zone,
    fhv_trips.dropoff_locationid,
    dropoff_zone.zone AS dropoff_zone,
    EXTRACT(YEAR FROM fhv_trips.pickup_datetime) AS year,
    EXTRACT(MONTH FROM fhv_trips.pickup_datetime) AS month
FROM
    fhv_trips
LEFT JOIN dim_zones AS pickup_zone
    ON fhv_trips.pickup_locationid = pickup_zone.locationid
LEFT JOIN dim_zones AS dropoff_zone
    ON fhv_trips.dropoff_locationid = dropoff_zone.locationid
