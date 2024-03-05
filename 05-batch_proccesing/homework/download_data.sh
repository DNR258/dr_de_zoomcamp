TAXI_TYPE='yellow'
YEAR=2020


# https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2023-01.parquet

URL_PREFIX="https://d37ci6vzurychx.cloudfront.net/trip-data/"

for MONTH in {1..12}; do
    FMONTH=`printf "%02d" ${MONTH}`

    URL="${URL_PREFIX}/${TAXI_TYPE}/_tripdata_${YEAR}-${FMONTH}.parquet"
    echo $URL
done