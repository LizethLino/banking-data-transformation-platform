import os
from pathlib import Path
import psycopg
from dotenv import load_dotenv

from faker import Faker

PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")

fake = Faker()
Faker.seed(10)

NUM_BRANCHES = 20
NUM_CUSTOMERS = 1000

branch_data = []
customer_data = []

connection_string = (
    f"host={os.getenv('DB_HOST')} "
    f"port={os.getenv('DB_PORT')} "
    f"dbname={os.getenv('DB_NAME')} "
    f"user={os.getenv('DB_USER')} "
    f"password={os.getenv('DB_PASSWORD')}"
)

try:
    with psycopg.connect(connection_string) as conn:
        with conn.cursor() as cur:

            # Retrieve city data from the database which should be pre-populated by seed file in data folder
            cur.execute(
                """
                    SELECT city_id
                    FROM cities
                """
            )

            #cur.fetchall() returns a list of tuples so row[0] is the first selection and row[1] is the next etc
            cities = [city[0] for city in cur.fetchall()]

            if not cities:
                raise RuntimeError("No cities found in the database. Please run data/banking_platform_seed.py first before generate_data.py.")

            print(f"Retrieved {len(cities)} cities from the database.")

            # Generate branch data from retrieved city data
            for _ in range(NUM_BRANCHES):
                city_id = fake.random_element(elements=cities)

                branch_data.append({
                    "branch_name": f"{fake.last_name()} Branch",
                    "city_id": city_id
                })

            #consider adding email, phone number, descriptive address in customer data, but for v1 just keep it simple

            for _ in range(NUM_CUSTOMERS):
                customer_data.append({
                    "c_first_name": fake.first_name(),
                    "c_last_name": fake.last_name(),
                    "dob": fake.date_of_birth(
                        minimum_age=18, maximum_age=85
                    ),
                    "annual_income": fake.pydecimal( # eventually make annual income and credit score generation related so they make sense together
                        left_digits=6, right_digits=2, positive=True
                    ),
                    "credit_score": fake.random_int(
                        min=300, max=850
                    )
                })

            # Insert branches
            for branch in branch_data:
                cur.execute(
                    """
                        INSERT INTO branches (
                            branch_name,
                            city_id
                        ) VALUES (%s, %s)
                        RETURNING branch_id
                    """,
                    (branch["branch_name"], branch["city_id"])
                )
                branch["branch_id"] = cur.fetchone()[0]

            print(f"Number of branches inserted: {len(branch_data)}")
            branch_ids = [branch["branch_id"] for branch in branch_data]

            # Insert customers
            for customer in customer_data:
                branch_id = fake.random_element(elements=branch_ids)
                cur.execute(
                    """
                        INSERT INTO customers (
                            c_first_name, 
                            c_last_name, 
                            dob, 
                            annual_income, 
                            credit_score,
                            branch_id
                        ) VALUES (%s, %s, %s, %s, %s, %s)
                        RETURNING customer_id
                    """,
                    (
                        customer["c_first_name"], 
                        customer["c_last_name"], 
                        customer["dob"], 
                        customer["annual_income"], 
                        customer["credit_score"], 
                        branch_id
                    )
                )
                customer["customer_id"] = cur.fetchone()[0]

            print(f"Number of customers inserted: {len(customer_data)}")

            conn.commit()
except psycopg.Error as e:
    print(f"A database error occurred while loading data: {e}")
except Exception as e:
    print(f"An unexpected error occurred while generating data: {e}")
    raise