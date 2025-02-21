# Homework Week 4

## Q1

Q: What does this .sql model compile to?

A: select * from myproject.my_nyc_tripdata.ext_green_taxi

## Q2

Q: What would you change to accomplish that in a such way that command line arguments takes precedence over ENV_VARs, which takes precedence over DEFAULT value?

A: Update the WHERE clause to pickup_datetime >= CURRENT_DATE - INTERVAL '{{ var("days_back", env_var("DAYS_BACK", "30")) }}' DAY

## Q3

Q: 

A:

## Q4

Q: That all being said, regarding macro above, select all statements that are true to the models using it

A:

- Setting a value for  DBT_BIGQUERY_TARGET_DATASET env var is mandatory, or it'll fail to compile
- When using core, it materializes in the dataset defined in DBT_BIGQUERY_TARGET_DATASET
- When using stg, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET
- When using staging, it materializes in the dataset defined in DBT_BIGQUERY_STAGING_DATASET, or defaults to DBT_BIGQUERY_TARGET_DATASET

## Q5

Q: Considering the YoY Growth in 2020, which were the yearly quarters with the best (or less worse) and worst results for green, and yellow

A: green: {best: 2020/Q1, worst: 2020/Q2}, yellow: {best: 2020/Q1, worst: 2020/Q2}

```
SELECT
  *
FROM
  `de-zoomcamp-2025.dbt_dataset.fct_taxi_trips_quarterly_revenue`
WHERE
  year = 2020
```

## Q6

Q: Now, what are the values of p97, p95, p90 for Green Taxi and Yellow Taxi, in April 2020?

A: green: {p97: 55.0, p95: 45.0, p90: 26.5}, yellow: {p97: 31.5, p95: 25.5, p90: 19.0}

```
SELECT
  *
FROM
  `de-zoomcamp-2025.dbt_dataset.fct_taxi_trips_monthly_fare_p95`
WHERE
  year = 2020
  AND month = 4
```

