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
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(90)] AS percentile90,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(95)] AS percentile95,
    APPROX_QUANTILES(fare_amount, 100)[OFFSET(97)] AS percentile97
FROM
    base
GROUP BY
    service_type, 
    year, 
    month
