# Q1

What's the version of pip in the image?

Run:
```
docker build -t test:pandas .
docker run -it test:pandas Hello_World
```

Answer: pip version: 24.3.1

# Q2

Given the following docker-compose.yaml, what is the hostname and port that pgadmin should use to connect to the postgres database?

From within the same Docker Compose network, pgAdmin should connect to the Postgres container using the service name db and port 5432.

Answer: db:5432

# Q3

During the period of October 1st 2019 (inclusive) and November 1st 2019 (exclusive), how many trips, respectively, happened:

```
SELECT
	COUNT(*)
FROM
	PUBLIC.GREEN_TRIPDATA_2019_10
WHERE
	TRIP_DISTANCE <= 1.0
```

Answer: 104,838; 199,013; 109,645; 27,688; 35,202

# Q4

Answer: 2019-10-31

# Q5

```
SELECT
	T1."PULocationID",
	T2."Zone",
	SUM(T1.TOTAL_AMOUNT) SUM_TOTAL_AMOUNT
FROM
	PUBLIC.GREEN_TRIPDATA_2019_10 T1
	LEFT JOIN PUBLIC.TAXI_ZONE_LOOKUP T2 ON T1."PULocationID" = T2."LocationID"
WHERE
	DATE (T1.LPEP_PICKUP_DATETIME) = '2019-10-18'
GROUP BY
	T1."PULocationID",
	T2."Zone"
ORDER BY
	SUM_TOTAL_AMOUNT DESC
```

Answer: East Harlem North, East Harlem South, Morningside Heights

# Q6

```
SELECT
	T1."DOLocationID",
	T2."Zone"
FROM
	PUBLIC.GREEN_TRIPDATA_2019_10 T1
	LEFT JOIN PUBLIC.TAXI_ZONE_LOOKUP T2 ON T1."DOLocationID" = T2."LocationID"
WHERE
	T1.TIP_AMOUNT = (
		SELECT
			MAX(T1.TIP_AMOUNT)
		FROM
			PUBLIC.GREEN_TRIPDATA_2019_10 T1
			LEFT JOIN PUBLIC.TAXI_ZONE_LOOKUP T2 ON T1."PULocationID" = T2."LocationID"
		WHERE
			T2."Zone" = 'East Harlem North'
	)
```

Answer: JFK Airport

# Q7

Answer: terraform init, terraform apply -auto-approve, terraform destroy
