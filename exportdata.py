import pandas as pd
from sqlalchemy import create_engine

username = 'postgres'
password = 'AdminPGdb'
host = 'localhost'
port = '5432'
database = 'club_member_info'

engine = create_engine(f'postgresql+psycopg2://{username}:{password}@{host}:{port}/{database}')

with engine.connect() as con:
    try:
        df = pd.read_sql('SELECT * FROM cleaned_club_member_info', con=con)
        df.to_csv('cleaned_club_member_info.csv', index=False)
        print("Data exported to cleaned_club_member_info.csv successfully.")
    except Exception as e:
        print(f"An error occurred: {e}")