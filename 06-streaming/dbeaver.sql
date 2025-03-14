CREATE TABLE green_trips_session (
    session_start TIMESTAMP,
    session_end TIMESTAMP,
    trip_count BIGINT,
    total_distance DOUBLE PRECISION,
    total_tip DOUBLE PRECISION
);

CREATE TABLE raw_green_trips (
    lpep_pickup_datetime TIMESTAMP(3),
    lpep_dropoff_datetime TIMESTAMP(3),
    pulocationid INT,
    dolocationid INT,
    passenger_count INT,
    trip_distance DOUBLE PRECISION,
    tip_amount DOUBLE PRECISION
);


WITH ranked AS (
    SELECT
        pulocationid AS PULocationID,
        dolocationid AS DOLocationID,
        lpep_pickup_datetime,
        ROW_NUMBER() OVER (ORDER BY lpep_pickup_datetime) AS rn,
        ROW_NUMBER() OVER (PARTITION BY pulocationid, dolocationid ORDER BY lpep_pickup_datetime) AS rn_grp
    FROM public.raw_green_trips
),
islands AS (
    SELECT
        PULocationID,
        DOLocationID,
        rn - rn_grp AS diff,
        COUNT(*) AS streak_length
    FROM ranked
    GROUP BY PULocationID, DOLocationID, rn - rn_grp
)
SELECT PULocationID, DOLocationID, MAX(streak_length) AS longest_streak
FROM islands
GROUP BY PULocationID, DOLocationID
ORDER BY longest_streak DESC
LIMIT 1;
