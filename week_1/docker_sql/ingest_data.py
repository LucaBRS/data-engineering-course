import pandas as pd
from sqlalchemy import create_engine
import argparse
import os
def main(params):
    user = params.user
    password = params.password
    host = params.host
    db = params.db
    port = params.port
    table_name = params.table_name
    zone_table_name = params.zone_table_name
    url_taxi = params.url_taxi
    url_zone = params.url_zone
    
    print(f'url: {url_taxi} done')
    file_name = 'output.parquet'
    zone_file_name = 'zone_table.csv'
    
    os.system(f"wget {url_taxi} -O {file_name}")
    os.system(f"wget {url_zone} -O {zone_file_name}")
    
    # we need to generate a connection to postgres using SQLAlchemy
    engine = create_engine(f'postgresql://{user}:{password}@{host}:{port}/{db}')
    
    df_iter_par = pd.read_parquet(file_name)
    df_iter_par.to_csv('test.csv',index=False)
    df_iter = pd.read_csv('test.csv',iterator=True,chunksize=10000)
    # i want to do this (df.head(n=0)) because i first need to create an empty dataframe with all just the column name
    # later on we will insert data chunk by chunk
    df = next(df_iter).head(n=0)

    # we need a schema to put everything on postgres and pandas is able to create this schema
    # print(pd.io.sql.get_schema(df, name='yellow_taxi_data', con=engine))


    df.to_sql(table_name, con=engine, if_exists='replace')

    # print(df_iter.head(n=3))
    # df_iter.to_sql(table_name, con=engine, if_exists='append')
    while True:
        try:
            df = next(df_iter)
            df.to_sql(table_name, con=engine, if_exists='append')
            print('inserted a chunk')
        except StopIteration:
            print('done inserting')
            break
    
    df_zone = pd.read_csv(zone_file_name)
    df_zone.head(n=0).to_sql(zone_table_name, con=engine, if_exists='replace')
    df_zone.to_sql(zone_table_name, con=engine, if_exists='append')


    print('DONE with the ingest data')


if __name__ == '__main__':

    parser = argparse.ArgumentParser( description='ingest data to postgres')

    parser.add_argument('--user',help='username for pg')           # positional argument
    parser.add_argument('--password', help='psw for pg')      # option that takes a value
    parser.add_argument('--host', help='host for pg')
    parser.add_argument('--port', help='port for pg')
    parser.add_argument('--db', help='database name for pg')
    parser.add_argument('--table_name', help='table-name for pg')
    parser.add_argument('--zone_table_name', help='zone_table_name for pg')
    parser.add_argument('--url_taxi', help='url_taxi for the csv for pg')
    parser.add_argument('--url_zone', help='url_zone for the csv for pg')


    args = parser.parse_args()
    print(args)

    main(args)

