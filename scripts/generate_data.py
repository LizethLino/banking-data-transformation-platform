import os
from pathlib import Path
import psycopg
from dotenv import load_dotenv

from faker import Faker

PROJECT_ROOT = Path(__file__).resolve().parent.parent
load_dotenv(PROJECT_ROOT / ".env")

fake = Faker()
Faker.seed(10)

regions = ['Northeast', 'Midwest', 'South', 'West']

# Define the states for each region based on the U.S. Census Bureau's regional divisions
region_states = {
    "Northeast": ['ME', 'NH', 'VT', 'MA', 'RI', 'CT', 'NY', 'NJ', 'PA'],
    "South": ['DE', 'DC', 'FL', 'GA', 'MD', 'NC', 'SC', 'VA', 'WV', 'AL', 'KY', 'MS', 'TN', 'AR', 'LA', 'OK', 'TX'],
    "Midwest": ['IL', 'IN', 'MI', 'OH', 'WI', 'IA', 'KS', 'MN', 'MO', 'NE', 'ND', 'SD'],
    "West": ['AK', 'CA', 'CO', 'HI', 'ID', 'MT', 'NV', 'NM', 'OR', 'UT', 'WA', 'WY', 'AZ']
}

# Define a mapping of states to their major cities for more realistic city generation
state_cities = {
    "NJ": ['Newark', 'Jersey City', 'Paterson', 'Elizabeth', 'Edison'],
    "NY": ['New York', 'Buffalo', 'Rochester', 'Yonkers', 'Syracuse'],
    "PA": ['Philadelphia', 'Pittsburgh', 'Allentown', 'Erie', 'Reading'],
    "CT": ['Bridgeport', 'New Haven', 'Stamford', 'Hartford', 'Waterbury'],
    "RI": ['Providence', 'Warwick', 'Cranston', 'Pawtucket', 'East Providence'],
    "MA": ['Boston', 'Worcester', 'Springfield', 'Lowell', 'Cambridge'],
    "VT": ['Burlington', 'South Burlington', 'Rutland', 'Barre', 'Montpelier'],
    "NH": ['Manchester', 'Nashua', 'Concord', 'Dover', 'Rochester'],
    "ME": ['Portland', 'Lewiston', 'Bangor', 'South Portland', 'Auburn'],

    "IL": ['Chicago', 'Aurora', 'Naperville', 'Joliet', 'Rockford'],
    "OH": ['Columbus', 'Cleveland', 'Cincinnati', 'Toledo', 'Akron'],
    "MI": ['Detroit', 'Grand Rapids', 'Warren', 'Sterling Heights', 'Ann Arbor'],
    "WI": ['Milwaukee', 'Madison', 'Green Bay', 'Kenosha', 'Racine'],
    "IN": ['Indianapolis', 'Fort Wayne', 'Evansville', 'South Bend', 'Carmel'],
    "IA": ['Des Moines', 'Cedar Rapids', 'Davenport', 'Sioux City', 'Iowa City'],
    "MN": ['Minneapolis', 'St. Paul', 'Rochester', 'Duluth', 'Bloomington'],
    "MO": ['Kansas City', 'St. Louis', 'Springfield', 'Columbia', 'Independence'],
    "KS": ['Wichita', 'Overland Park', 'Kansas City', 'Olathe', 'Topeka'],
    "ND": ['Fargo', 'Bismarck', 'Grand Forks', 'Minot', 'West Fargo'],
    "SD": ['Sioux Falls', 'Rapid City', 'Aberdeen', 'Brookings', 'Watertown'],
    "NE": ['Omaha', 'Lincoln', 'Bellevue', 'Grand Island', 'Kearney'],

    "GA": ['Atlanta', 'Augusta', 'Columbus', 'Macon', 'Savannah'],
    "FL": ['Jacksonville', 'Miami', 'Tampa', 'Orlando', 'St. Petersburg'],
    "TX": ['Houston', 'San Antonio', 'Dallas', 'Austin', 'Fort Worth'],
    "NC": ['Charlotte', 'Raleigh', 'Greensboro', 'Durham', 'Winston-Salem'],
    "DE": ['Wilmington', 'Dover', 'Newark', 'Middletown', 'Smyrna'],
    "DC": ['Washington', 'Georgetown', 'Anacostia', 'Capitol Hill', 'Dupont Circle'],
    "MD": ['Baltimore', 'Frederick', 'Rockville', 'Gaithersburg', 'Bowie'],
    "SC": ['Charleston', 'Columbia', 'North Charleston', 'Mount Pleasant', 'Rock Hill'],
    "VA": ['Virginia Beach', 'Norfolk', 'Chesapeake', 'Richmond', 'Newport News'],
    "WV": ['Charleston', 'Huntington', 'Morgantown', 'Parkersburg', 'Wheeling'],
    "AL": ['Birmingham', 'Montgomery', 'Mobile', 'Huntsville', 'Tuscaloosa'],
    "KY": ['Louisville', 'Lexington', 'Bowling Green', 'Owensboro', 'Covington'],
    "MS": ['Jackson', 'Gulfport', 'Southaven', 'Hattiesburg', 'Biloxi'],
    "TN": ['Nashville', 'Memphis', 'Knoxville', 'Chattanooga', 'Clarksville'],
    "AR": ['Little Rock', 'Fort Smith', 'Fayetteville', 'Springdale', 'Jonesboro'],
    "LA": ['New Orleans', 'Baton Rouge', 'Shreveport', 'Lafayette', 'Lake Charles'],
    "OK": ['Oklahoma City', 'Tulsa', 'Norman', 'Broken Arrow', 'Edmond'],

    "CA": ['Los Angeles', 'San Diego', 'San Jose', 'San Francisco', 'Fresno'],
    "WA": ['Seattle', 'Spokane', 'Tacoma', 'Vancouver', 'Bellevue'],
    "CO": ['Denver', 'Colorado Springs', 'Aurora', 'Fort Collins', 'Lakewood'],
    "AZ": ['Phoenix', 'Tucson', 'Mesa', 'Chandler', 'Glendale'],
    "AK": ['Anchorage', 'Fairbanks', 'Juneau', 'Sitka', 'Ketchikan'],
    "HI": ['Honolulu', 'Hilo', 'Kailua', 'Kapolei', 'Waipahu'],
    "ID": ['Boise', 'Nampa', 'Meridian', 'Idaho Falls', 'Pocatello'],
    "MT": ['Billings', 'Missoula', 'Great Falls', 'Bozeman', 'Butte'],
    "NV": ['Las Vegas', 'Henderson', 'Reno', 'North Las Vegas', 'Sparks'],
    "NM": ['Albuquerque', 'Las Cruces', 'Rio Rancho', 'Santa Fe', 'Roswell'],
    "OR": ['Portland', 'Salem', 'Eugene', 'Gresham', 'Hillsboro'],
    "UT": ['Salt Lake City', 'West Valley City', 'Provo', 'West Jordan', 'Orem'],
    "WY": ['Cheyenne', 'Casper', 'Laramie', 'Gillette', 'Rock Springs']
}

NUM_BRANCHES = 20

region_data = []

for region_name in regions:
    region_data.append({
        "region_name": region_name
    })

branch_data = []

for _ in range(NUM_BRANCHES):
    region_name = fake.random_element(elements=regions)
    state = fake.random_element(elements=region_states[region_name])
    city = fake.random_element(elements=state_cities[state])

    branch_data.append({
        "branch_name": f"{fake.last_name()} Branch",
        "region": region_name,
        "state": state,
        "city": city
    })

NUM_CUSTOMERS = 1000

customer_data = []
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
            # Insert regions and save the region_id for each region to use when inserting branches
            region_ids = {}

            for region in region_data:
                cur.execute(
                    """
                        INSERT INTO regions (region_name) 
                        VALUES (%s) 
                        RETURNING region_id
                    """,
                    (region["region_name"],)
                )

                region_id = cur.fetchone()[0]
                region["region_id"] = region_id
                region_ids[region["region_name"]] = region_id

            print(f"Number of regions inserted: {len(region_ids)}")

            # Insert branches
            for branch in branch_data:
                region_id = region_ids[branch["region"]]
                cur.execute(
                    """
                        INSERT INTO branches (
                            branch_name,
                            region_id,
                            state,
                            city
                        ) VALUES (%s, %s, %s, %s)
                        RETURNING branch_id
                    """,
                    (branch["branch_name"], region_id, branch["state"], branch["city"])
                )
                branch["branch_id"] = cur.fetchone()[0]

            print(f"Number of branches inserted: {len(branch_data)}")
            branch_ids = [branch["branch_id"] for branch in branch_data]

            conn.commit()  # Commit the transaction after inserting regions and branches

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
except Exception as e:
    print(f"An error occurred while loading data: {e}")