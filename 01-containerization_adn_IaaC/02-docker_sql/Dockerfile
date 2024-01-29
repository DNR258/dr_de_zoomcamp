FROM python:3.9.1

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2

WORKDIR /app
COPY d_ingest_data.py d_ingest_data.py 

ENTRYPOINT [ "python", "d_ingest_data.py" ]

