FROM python:3.9

RUN apt-get install wget
RUN pip install pandas sqlalchemy psycopg2 pyarrow fastparquet

# this will specify the location the image in the container where we copy the file
WORKDIR /app
# we copy the file from the current work directory to docker directory (/app)
COPY ingest_data.py ingest_data.py

#this will overrie the entrypoint in this case instead of running in bash will be in python and the pipeline.py will be
#executed
ENTRYPOINT ["python","ingest_data.py"]