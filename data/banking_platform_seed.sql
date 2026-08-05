-- ============================================================
-- Static reference data for the banking platform
--
-- Populates:
--   1. Regions
--   2. States
--   3. Cities
--
-- This file should be run after schema.sql and before generate_data.py
-- ============================================================


-- REGIONS

INSERT INTO regions (region_name)
VALUES
    ('Northeast'),
    ('Midwest'),
    ('South'),
    ('West')
ON CONFLICT (region_name) DO NOTHING;



-- STATES

INSERT INTO states (state_code, state_name, region_id)
VALUES

    -- Northeast
    ('ME', 'Maine',         (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('NH', 'New Hampshire', (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('VT', 'Vermont',       (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('MA', 'Massachusetts', (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('RI', 'Rhode Island',  (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('CT', 'Connecticut',   (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('NY', 'New York',      (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('NJ', 'New Jersey',    (SELECT region_id FROM regions WHERE region_name = 'Northeast')),
    ('PA', 'Pennsylvania',  (SELECT region_id FROM regions WHERE region_name = 'Northeast')),


    -- Midwest
    ('IL', 'Illinois',     (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('IN', 'Indiana',      (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('MI', 'Michigan',     (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('OH', 'Ohio',         (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('WI', 'Wisconsin',    (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('IA', 'Iowa',         (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('KS', 'Kansas',       (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('MN', 'Minnesota',    (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('MO', 'Missouri',     (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('NE', 'Nebraska',     (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('ND', 'North Dakota', (SELECT region_id FROM regions WHERE region_name = 'Midwest')),
    ('SD', 'South Dakota', (SELECT region_id FROM regions WHERE region_name = 'Midwest')),


    -- South
    ('DE', 'Delaware',             (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('DC', 'District of Columbia', (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('FL', 'Florida',              (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('GA', 'Georgia',              (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('MD', 'Maryland',             (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('NC', 'North Carolina',       (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('SC', 'South Carolina',       (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('VA', 'Virginia',             (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('WV', 'West Virginia',        (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('AL', 'Alabama',              (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('KY', 'Kentucky',             (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('MS', 'Mississippi',          (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('TN', 'Tennessee',            (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('AR', 'Arkansas',             (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('LA', 'Louisiana',            (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('OK', 'Oklahoma',             (SELECT region_id FROM regions WHERE region_name = 'South')),
    ('TX', 'Texas',                (SELECT region_id FROM regions WHERE region_name = 'South')),


    -- West
    ('AK', 'Alaska',       (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('CA', 'California',   (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('CO', 'Colorado',     (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('HI', 'Hawaii',       (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('ID', 'Idaho',        (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('MT', 'Montana',      (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('NV', 'Nevada',       (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('NM', 'New Mexico',   (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('OR', 'Oregon',       (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('UT', 'Utah',         (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('WA', 'Washington',   (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('WY', 'Wyoming',      (SELECT region_id FROM regions WHERE region_name = 'West')),
    ('AZ', 'Arizona',      (SELECT region_id FROM regions WHERE region_name = 'West'))

ON CONFLICT (state_code) DO NOTHING;



-- CITIES

INSERT INTO cities (city_name, state_code)
VALUES


    -- Northeast
    -- New Jersey
    ('Newark', 'NJ'),
    ('Jersey City', 'NJ'),
    ('Paterson', 'NJ'),
    ('Elizabeth', 'NJ'),
    ('Edison', 'NJ'),


    -- New York
    ('New York', 'NY'),
    ('Buffalo', 'NY'),
    ('Rochester', 'NY'),
    ('Yonkers', 'NY'),
    ('Syracuse', 'NY'),


    -- Pennsylvania
    ('Philadelphia', 'PA'),
    ('Pittsburgh', 'PA'),
    ('Allentown', 'PA'),
    ('Erie', 'PA'),
    ('Reading', 'PA'),


    -- Connecticut
    ('Bridgeport', 'CT'),
    ('New Haven', 'CT'),
    ('Stamford', 'CT'),
    ('Hartford', 'CT'),
    ('Waterbury', 'CT'),


    -- Rhode Island
    ('Providence', 'RI'),
    ('Warwick', 'RI'),
    ('Cranston', 'RI'),
    ('Pawtucket', 'RI'),
    ('East Providence', 'RI'),


    -- Massachusetts
    ('Boston', 'MA'),
    ('Worcester', 'MA'),
    ('Springfield', 'MA'),
    ('Lowell', 'MA'),
    ('Cambridge', 'MA'),


    -- Vermont
    ('Burlington', 'VT'),
    ('South Burlington', 'VT'),
    ('Rutland', 'VT'),
    ('Barre', 'VT'),
    ('Montpelier', 'VT'),


    -- New Hampshire
    ('Manchester', 'NH'),
    ('Nashua', 'NH'),
    ('Concord', 'NH'),
    ('Dover', 'NH'),
    ('Rochester', 'NH'),


    -- Maine
    ('Portland', 'ME'),
    ('Lewiston', 'ME'),
    ('Bangor', 'ME'),
    ('South Portland', 'ME'),
    ('Auburn', 'ME'),




    -- Midwest
    -- Illinois
    ('Chicago', 'IL'),
    ('Aurora', 'IL'),
    ('Naperville', 'IL'),
    ('Joliet', 'IL'),
    ('Rockford', 'IL'),


    -- Ohio
    ('Columbus', 'OH'),
    ('Cleveland', 'OH'),
    ('Cincinnati', 'OH'),
    ('Toledo', 'OH'),
    ('Akron', 'OH'),


    -- Michigan
    ('Detroit', 'MI'),
    ('Grand Rapids', 'MI'),
    ('Warren', 'MI'),
    ('Sterling Heights', 'MI'),
    ('Ann Arbor', 'MI'),


    -- Wisconsin
    ('Milwaukee', 'WI'),
    ('Madison', 'WI'),
    ('Green Bay', 'WI'),
    ('Kenosha', 'WI'),
    ('Racine', 'WI'),


    -- Indiana
    ('Indianapolis', 'IN'),
    ('Fort Wayne', 'IN'),
    ('Evansville', 'IN'),
    ('South Bend', 'IN'),
    ('Carmel', 'IN'),


    -- Iowa
    ('Des Moines', 'IA'),
    ('Cedar Rapids', 'IA'),
    ('Davenport', 'IA'),
    ('Sioux City', 'IA'),
    ('Iowa City', 'IA'),


    -- Minnesota
    ('Minneapolis', 'MN'),
    ('St. Paul', 'MN'),
    ('Rochester', 'MN'),
    ('Duluth', 'MN'),
    ('Bloomington', 'MN'),


    -- Missouri
    ('Kansas City', 'MO'),
    ('St. Louis', 'MO'),
    ('Springfield', 'MO'),
    ('Columbia', 'MO'),
    ('Independence', 'MO'),


    -- Kansas
    ('Wichita', 'KS'),
    ('Overland Park', 'KS'),
    ('Kansas City', 'KS'),
    ('Olathe', 'KS'),
    ('Topeka', 'KS'),


    -- North Dakota
    ('Fargo', 'ND'),
    ('Bismarck', 'ND'),
    ('Grand Forks', 'ND'),
    ('Minot', 'ND'),
    ('West Fargo', 'ND'),


    -- South Dakota
    ('Sioux Falls', 'SD'),
    ('Rapid City', 'SD'),
    ('Aberdeen', 'SD'),
    ('Brookings', 'SD'),
    ('Watertown', 'SD'),


    -- Nebraska
    ('Omaha', 'NE'),
    ('Lincoln', 'NE'),
    ('Bellevue', 'NE'),
    ('Grand Island', 'NE'),
    ('Kearney', 'NE'),




    -- South
    -- Georgia
    ('Atlanta', 'GA'),
    ('Augusta', 'GA'),
    ('Columbus', 'GA'),
    ('Macon', 'GA'),
    ('Savannah', 'GA'),


    -- Florida
    ('Jacksonville', 'FL'),
    ('Miami', 'FL'),
    ('Tampa', 'FL'),
    ('Orlando', 'FL'),
    ('St. Petersburg', 'FL'),


    -- Texas
    ('Houston', 'TX'),
    ('San Antonio', 'TX'),
    ('Dallas', 'TX'),
    ('Austin', 'TX'),
    ('Fort Worth', 'TX'),


    -- North Carolina
    ('Charlotte', 'NC'),
    ('Raleigh', 'NC'),
    ('Greensboro', 'NC'),
    ('Durham', 'NC'),
    ('Winston-Salem', 'NC'),


    -- Delaware
    ('Wilmington', 'DE'),
    ('Dover', 'DE'),
    ('Newark', 'DE'),
    ('Middletown', 'DE'),
    ('Smyrna', 'DE'),


    -- District of Columbia
    ('Washington', 'DC'),
    ('Georgetown', 'DC'),
    ('Anacostia', 'DC'),
    ('Capitol Hill', 'DC'),
    ('Dupont Circle', 'DC'),


    -- Maryland
    ('Baltimore', 'MD'),
    ('Frederick', 'MD'),
    ('Rockville', 'MD'),
    ('Gaithersburg', 'MD'),
    ('Bowie', 'MD'),


    -- South Carolina
    ('Charleston', 'SC'),
    ('Columbia', 'SC'),
    ('North Charleston', 'SC'),
    ('Mount Pleasant', 'SC'),
    ('Rock Hill', 'SC'),


    -- Virginia
    ('Virginia Beach', 'VA'),
    ('Norfolk', 'VA'),
    ('Chesapeake', 'VA'),
    ('Richmond', 'VA'),
    ('Newport News', 'VA'),


    -- West Virginia
    ('Charleston', 'WV'),
    ('Huntington', 'WV'),
    ('Morgantown', 'WV'),
    ('Parkersburg', 'WV'),
    ('Wheeling', 'WV'),


    -- Alabama
    ('Birmingham', 'AL'),
    ('Montgomery', 'AL'),
    ('Mobile', 'AL'),
    ('Huntsville', 'AL'),
    ('Tuscaloosa', 'AL'),


    -- Kentucky
    ('Louisville', 'KY'),
    ('Lexington', 'KY'),
    ('Bowling Green', 'KY'),
    ('Owensboro', 'KY'),
    ('Covington', 'KY'),


    -- Mississippi
    ('Jackson', 'MS'),
    ('Gulfport', 'MS'),
    ('Southaven', 'MS'),
    ('Hattiesburg', 'MS'),
    ('Biloxi', 'MS'),


    -- Tennessee
    ('Nashville', 'TN'),
    ('Memphis', 'TN'),
    ('Knoxville', 'TN'),
    ('Chattanooga', 'TN'),
    ('Clarksville', 'TN'),


    -- Arkansas
    ('Little Rock', 'AR'),
    ('Fort Smith', 'AR'),
    ('Fayetteville', 'AR'),
    ('Springdale', 'AR'),
    ('Jonesboro', 'AR'),


    -- Louisiana
    ('New Orleans', 'LA'),
    ('Baton Rouge', 'LA'),
    ('Shreveport', 'LA'),
    ('Lafayette', 'LA'),
    ('Lake Charles', 'LA'),


    -- Oklahoma
    ('Oklahoma City', 'OK'),
    ('Tulsa', 'OK'),
    ('Norman', 'OK'),
    ('Broken Arrow', 'OK'),
    ('Edmond', 'OK'),




    -- West
    -- California
    ('Los Angeles', 'CA'),
    ('San Diego', 'CA'),
    ('San Jose', 'CA'),
    ('San Francisco', 'CA'),
    ('Fresno', 'CA'),


    -- Washington
    ('Seattle', 'WA'),
    ('Spokane', 'WA'),
    ('Tacoma', 'WA'),
    ('Vancouver', 'WA'),
    ('Bellevue', 'WA'),


    -- Colorado
    ('Denver', 'CO'),
    ('Colorado Springs', 'CO'),
    ('Aurora', 'CO'),
    ('Fort Collins', 'CO'),
    ('Lakewood', 'CO'),


    -- Arizona
    ('Phoenix', 'AZ'),
    ('Tucson', 'AZ'),
    ('Mesa', 'AZ'),
    ('Chandler', 'AZ'),
    ('Glendale', 'AZ'),


    -- Alaska
    ('Anchorage', 'AK'),
    ('Fairbanks', 'AK'),
    ('Juneau', 'AK'),
    ('Sitka', 'AK'),
    ('Ketchikan', 'AK'),


    -- Hawaii
    ('Honolulu', 'HI'),
    ('Hilo', 'HI'),
    ('Kailua', 'HI'),
    ('Kapolei', 'HI'),
    ('Waipahu', 'HI'),


    -- Idaho
    ('Boise', 'ID'),
    ('Nampa', 'ID'),
    ('Meridian', 'ID'),
    ('Idaho Falls', 'ID'),
    ('Pocatello', 'ID'),


    -- Montana
    ('Billings', 'MT'),
    ('Missoula', 'MT'),
    ('Great Falls', 'MT'),
    ('Bozeman', 'MT'),
    ('Butte', 'MT'),


    -- Nevada
    ('Las Vegas', 'NV'),
    ('Henderson', 'NV'),
    ('Reno', 'NV'),
    ('North Las Vegas', 'NV'),
    ('Sparks', 'NV'),


    -- New Mexico
    ('Albuquerque', 'NM'),
    ('Las Cruces', 'NM'),
    ('Rio Rancho', 'NM'),
    ('Santa Fe', 'NM'),
    ('Roswell', 'NM'),


    -- Oregon
    ('Portland', 'OR'),
    ('Salem', 'OR'),
    ('Eugene', 'OR'),
    ('Gresham', 'OR'),
    ('Hillsboro', 'OR'),


    -- Utah
    ('Salt Lake City', 'UT'),
    ('West Valley City', 'UT'),
    ('Provo', 'UT'),
    ('West Jordan', 'UT'),
    ('Orem', 'UT'),


    -- Wyoming
    ('Cheyenne', 'WY'),
    ('Casper', 'WY'),
    ('Laramie', 'WY'),
    ('Gillette', 'WY'),
    ('Rock Springs', 'WY')


ON CONFLICT (city_name, state_code) DO NOTHING;