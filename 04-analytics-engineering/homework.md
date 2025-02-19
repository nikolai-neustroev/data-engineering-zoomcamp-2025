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

Q: 