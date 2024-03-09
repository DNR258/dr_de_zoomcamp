-- QUESTION 0: what are the dropoff taxi zones at the latest dropoff times?

CREATE MATERIALIZED VIEW latest_dropoff_time AS
    WITH t AS (
        SELECT MAX(tpep_dropoff_datetime) AS latest_dropoff_time
        FROM trip_data
    )
    SELECT tz.zone, t.latest_dropoff_time
    FROM t, 
         trip_data AS td
    INNER JOIN taxi_zone AS tz
    ON td.DOLocationID = tz.location_id
    WHERE tpep_dropoff_datetime = t.latest_dropoff_time;

-- QUESTION 1: Create a MV to compute the AVG, MIN and MAX trip time btw each taxi zone.

CREATE MATERIALIZED VIEW agg_values AS
    WITH agg AS (
        SELECT PULocationID, 
               DOLocationID, 
               (tpep_dropoff_datetime - tpep_pickup_datetime) AS trip_time
        FROM 
            trip_data
    )
    SELECT tzu.zone AS pu_zone, 
           tzd.zone AS do_zone, 
           AVG(trip_time) AS avg_triptime, 
           MAX(trip_time) AS max_triptime, 
           MIN(trip_time) AS min_triptime
    FROM 
        agg 
    INNER JOIN 
        taxi_zone tzu
    ON 
        agg.PULocationID = tzu.location_id
    INNER JOIN 
        taxi_zone tzd
    ON 
        agg.DOLocationID = tzd.location_id
    GROUP BY 
        tzu.zone, 
        tzd.zone;

SELECT 
    pu_zone, 
    do_zone
FROM 
    agg_values
WHERE 
    avg_triptime = (SELECT 
                        MAX(avg_triptime) 
                    FROM 
                        agg_values
                    );

'''
    pu_zone     | do_zone
----------------+----------
 Yorkville East | Steinway
(1 row)
'''

-- QUESTION 2: Recreate the MV(s) in question 1, to also find the number of trips 
--             for the pair of taxi zones with the highest average trip time.

CREATE MATERIALIZED VIEW agg_values_2 AS
    WITH agg AS (
        SELECT PULocationID, 
               DOLocationID, 
               (tpep_dropoff_datetime - tpep_pickup_datetime) AS trip_time
        FROM 
            trip_data
    )
    SELECT tzu.zone AS pu_zone, 
           tzd.zone AS do_zone, 
           AVG(trip_time) AS avg_triptime, 
           MAX(trip_time) AS max_triptime, 
           MIN(trip_time) AS min_triptime, 
           COUNT(1) AS trip_num
    FROM 
        agg 
    INNER JOIN 
        taxi_zone tzu
    ON 
        agg.PULocationID = tzu.location_id
    INNER JOIN 
        taxi_zone tzd
    ON 
        agg.DOLocationID = tzd.location_id
    GROUP BY 
        tzu.zone, 
        tzd.zone;

SELECT 
    trip_num
FROM 
    agg_values_2
WHERE 
    avg_triptime = (SELECT 
                        MAX(avg_triptime) 
                    FROM 
                        agg_values_2
                    );

'''
 trip_num
----------
        1
(1 row)
'''

-- QUESTION 3: From the latest pickup time to 17 hours before, 
--             what are the top 3 busiest zones in terms of number of pickups?

CREATE MATERIALIZED VIEW max_tpep AS
    SELECT 
        MAX(tpep_pickup_datetime) AS max 
    FROM 
        trip_data;

SELECT 
    tz.zone, 
    count(tpep_pickup_datetime) AS num_trip
FROM
    trip_data AS td
INNER JOIN 
    taxi_zone AS tz
ON 
    td.PULocationID = tz.location_id
WHERE 
    tpep_pickup_datetime > (SELECT max FROM max_tpep) - INTERVAL '17 hour'
GROUP BY 
    1
ORDER BY   
    2 DESC
LIMIT 3;


'''
        zone         | num_trip
---------------------+----------
 LaGuardia Airport   |       19
 JFK Airport         |       17
 Lincoln Square East |       17
(3 rows)
'''



