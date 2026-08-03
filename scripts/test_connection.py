import os
import psycopg
from dotenv import load_dotenv

load_dotenv()

connection_string = (
    f"host={os.getenv('DB_HOST')} "
    f"port={os.getenv('DB_PORT')} "
    f"dbname={os.getenv('DB_NAME')} "
    f"user={os.getenv('DB_USER')} "
    f"password={os.getenv('DB_PASSWORD')} "
)

try:
    with psycopg.connect(connection_string) as conn:
        print("Successfully connected to the PostgreSQL database.")
except Exception as e:
    print(f"An error occurred while trying to connect to the database: {e}")