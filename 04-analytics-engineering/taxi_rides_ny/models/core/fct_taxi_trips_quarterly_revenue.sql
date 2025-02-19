WITH base AS (
    SELECT
        service_type,
        pickup_datetime,
        total_amount,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(QUARTER FROM pickup_datetime) AS quarter
    FROM {{ ref('fact_trips') }}
),

quarterly AS (
    SELECT
        service_type,
        year,
        quarter,
        SUM(total_amount) AS quarterly_revenue
    FROM 
        base
    GROUP BY 
        service_type, 
        year, 
        quarter
),

quarterly_yoy AS (
    SELECT
        service_type,
        year,
        quarter,
        quarterly_revenue,
        LAG(quarterly_revenue) OVER (
            PARTITION BY service_type, quarter 
            ORDER BY year
        ) AS previous_year_revenue,
        CASE 
            WHEN LAG(quarterly_revenue) OVER (
                    PARTITION BY service_type, quarter 
                    ORDER BY year
                 ) IS NULL THEN NULL
            ELSE SAFE_DIVIDE(
                    (quarterly_revenue - LAG(quarterly_revenue) OVER (PARTITION BY service_type, quarter ORDER BY year)), 
                    LAG(quarterly_revenue) OVER (PARTITION BY service_type, quarter ORDER BY year)
                  )
        END AS yoy_growth
    FROM quarterly
)

SELECT
    service_type,
    year,
    quarter,
    quarterly_revenue,
    previous_year_revenue,
    yoy_growth,
    CONCAT(year, '/Q', quarter) AS year_quarter
FROM quarterly_yoy
ORDER BY 
    service_type,
    year, 
    quarter
