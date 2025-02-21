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
),

base_with_percentiles AS (
  SELECT
    service_type,
    year,
    month,
    fare_amount,
    PERCENTILE_CONT(fare_amount, 0.90) OVER (PARTITION BY service_type, year, month) AS percentile90,
    PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, year, month) AS percentile95,
    PERCENTILE_CONT(fare_amount, 0.97) OVER (PARTITION BY service_type, year, month) AS percentile97
  FROM
    base
)

SELECT DISTINCT
  service_type,
  year,
  month,
  percentile90,
  percentile95,
  percentile97
FROM
  base_with_percentiles
