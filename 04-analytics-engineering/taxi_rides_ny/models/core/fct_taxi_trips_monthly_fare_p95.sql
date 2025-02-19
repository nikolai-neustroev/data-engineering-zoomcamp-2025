WITH base AS (
    SELECT
        service_type,
        pickup_datetime,
        fare_amount,
        EXTRACT(YEAR FROM pickup_datetime) AS `year`,
        EXTRACT(MONTH FROM pickup_datetime) AS `month`
    FROM 
        {{ ref('fact_trips') }}
    WHERE
        fare_amount > 0
        AND trip_distance > 0 
        AND payment_type_description in ('Cash', 'Credit Card')
)

SELECT
    service_type, 
    year, 
    month,
    PERCENTILE_CONT(fare_amount, 0.9) OVER(PARTITION BY service_type, year, month) AS percentile90,
    PERCENTILE_CONT(fare_amount, 0.95) OVER(PARTITION BY service_type, year, month) AS percentile95,
    PERCENTILE_CONT(fare_amount, 0.97) OVER(PARTITION BY service_type, year, month) AS percentile97,
FROM
    base
