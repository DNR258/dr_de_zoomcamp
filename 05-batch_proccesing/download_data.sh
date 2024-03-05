set -e

TAXI_TYPE=$1      #"yellow"
YEAR=$2           #"2020"
PREFIX="https://github.com/DataTalksClub/nyc-tlc-data/releases/download"

# https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2021-01.parquet

for MONTH in  {1..12}; do
    FMONTH=`printf "%02d" ${MONTH}` # son sumamente importantes los tipos de comillas que usamos para que el código se comporte como queremos.
    URL="${PREFIX}/${TAXI_TYPE}/${TAXI_TYPE}_tripdata_${YEAR}-${FMONTH}.csv.gz"
                                    # las comillas '' son interpretadas como literales aquí. 
                                    # lo mismo ocurre con "", pero en este caso reconoce las VARIABLES (${})
                                    # las que sirve son las mismas que le gusta a BQ, ``.
    LOCAL_PREFIX="data/raw/${TAXI_TYPE}/${YEAR}/${FMONTH}"
    LOCAL_FILE="${TAXI_TYPE}_tripdata_${YEAR}_${FMONTH}.csv.gz"
    LOCAL_PATH="${LOCAL_PREFIX}/${LOCAL_FILE}"

    echo "downloading ${URL} to ${LOCAL_PATH}"
    mkdir -p ${LOCAL_PREFIX}
    wget ${URL} -O ${LOCAL_PATH}

#    echo "compressing ${LOCAL_PATH}"
#    gzip ${LOCAL_PATH}
# Ultimas lineas comentadas xq en el video se trabaja con .parquet, y aqui directamente con .csv.gz
done                                    