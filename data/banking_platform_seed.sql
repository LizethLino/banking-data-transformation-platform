--============================================================================================================================
-- Static reference data for the banking platform
--
-- Populates:
--   1. Regions
--   2. States
--   3. Cities
--   4. Address Types
--   5. Account Types
--   6. Account Statuses
--   7. Account Products
--   8. Transaction Types
--   9. Transaction Channels
--   10. Transaction Statuses
--   11. Merchant Categories
--   12. Merchants
--   13. Employee Roles
--
-- This file should be run after banking_platform_schema.sql and before generate_data.py
--============================================================================================================================


--============================================================================================================================
-- REGIONS
--============================================================================================================================

INSERT INTO regions (region_name)
VALUES
    ('Northeast'),
    ('Midwest'),
    ('South'),
    ('West')
ON CONFLICT (region_name) DO NOTHING;


--============================================================================================================================
-- STATES
--============================================================================================================================

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


--============================================================================================================================
-- CITIES
--============================================================================================================================

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


--============================================================================================================================
-- ADDRESS TYPES
--============================================================================================================================

INSERT INTO address_types (address_type_name, address_description)
VALUES
    ('Home', 'Residential address for personal use.'),
    ('Business', 'Customer employment or business address.'),
    ('Mailing', 'Address used for receiving mail.')

ON CONFLICT (address_type_name) DO NOTHING;


--============================================================================================================================
-- ACCOUNT TYPES
--============================================================================================================================

INSERT INTO account_types (account_type_name, account_type_description)
VALUES
    ('Checking', 'A type of bank account that allows for frequent transactions and easy access to funds.'),
    ('Savings', 'A type of bank account that earns interest on the balance and is designed for saving money.'),
    ('Credit', 'A type of bank account that allows for borrowing money up to a certain limit.')

ON CONFLICT (account_type_name) DO NOTHING;


--============================================================================================================================
-- ACCOUNT STATUSES
--============================================================================================================================

INSERT INTO account_statuses (account_status_name, account_status_description)
VALUES
    ('Active', 'The account is currently active and in good standing.'),
    ('Inactive', 'The account is not currently active.'),
    ('Frozen', 'The account has been temporarily frozen and cannot be used.'),
    ('Closed', 'The account has been closed.')

ON CONFLICT (account_status_name) DO NOTHING;


--============================================================================================================================
-- ACCOUNT PRODUCTS
--============================================================================================================================

INSERT INTO account_products (
    account_product_name,
    account_type_id,
    interest_rate,
    monthly_fee,
    minimum_balance,
    maximum_credit_limit,
    is_active,
    account_product_description
)
SELECT
    'Basic Checking',
    account_type_id,
    0.00,
    0.00,
    0.00,
    NULL::NUMERIC,
    TRUE,
    'Basic checking account with no monthly maintenance fee'
FROM account_types
WHERE account_type_name = 'Checking'

UNION ALL

SELECT
    'Premium Checking',
    account_type_id,
    0.10,
    15.00,
    1500.00,
    NULL::NUMERIC,
    TRUE,
    'Premium checking account with additional benefits and a monthly fee'
FROM account_types
WHERE account_type_name = 'Checking'

UNION ALL

SELECT
    'Basic Savings',
    account_type_id,
    1.50,
    0.00,
    100.00,
    NULL::NUMERIC,
    TRUE,
    'Standard savings account'
FROM account_types
WHERE account_type_name = 'Savings'

UNION ALL

SELECT
    'High Yield Savings',
    account_type_id,
    4.00,
    0.00,
    500.00::NUMERIC,
    NULL,
    TRUE,
    'Savings account offering a higher interest rate'
FROM account_types
WHERE account_type_name = 'Savings'

UNION ALL

SELECT
    'Basic Credit Card',
    account_type_id,
    24.99,
    0.00,
    0.00,
    5000.00,
    TRUE,
    'Standard revolving credit product'
FROM account_types
WHERE account_type_name = 'Credit'

UNION ALL

SELECT
    'Premium Credit Card',
    account_type_id,
    19.99,
    95.00,
    0.00,
    25000.00,
    TRUE,
    'Premium credit product with a higher maximum credit limit'
FROM account_types
WHERE account_type_name = 'Credit';


--============================================================================================================================
-- TRANSACTION TYPES
--============================================================================================================================

INSERT INTO transaction_types (
	transaction_type_name,
	transaction_type_description
)
VALUES
	('Deposit', 'Funds deposited into an account.'),
	('Withdrawal', 'Funds withdrawn from an account.'),
	('Transfer', 'Funds transferred between accounts.'),
	('Purchase', 'Purchase made using an account or payment instrument.'),
	('ATM_Withdrawal', 'Cash withdrawn through an ATM.'),
	('Direct_Deposit', 'Electronic deposit originating from an employer or other organization.'),
	('Bill_Payment', 'Payment made toward a bill or service.'),
	('Fee', 'Fee charged by the financial institution or service provider.'),
	('Interest_Credit', 'Interest credited to an account.'),
	('Refund', 'Funds returned to an account following a previous purchase or payment.'),
	('Loan_Payment', 'Payment made toward a loan balance.');


--============================================================================================================================
-- TRANSACTION CHANNELS
--============================================================================================================================

INSERT INTO transaction_channels (
	transaction_channel_name,
	transaction_channel_description
)
VALUES
	('ATM', 'Transaction initiated through an automated teller machine.'),
	('Debit_Card', 'Transaction initiated using a debit card.'),
	('Online', 'Transaction initiated through online banking.'),
	('Mobile', 'Transaction initiated through mobile banking.'),
	('Employer', 'Transaction originating from an employer or payroll system.'),
	('Branch', 'Transaction initiated at a physical bank branch.');


--============================================================================================================================
-- TRANSACTION STATUSES
--============================================================================================================================

INSERT INTO transaction_statuses (
	transaction_status_name,
	transaction_status_description
)
VALUES
	('Pending', 'Transaction has been initiated but has not yet been completed.'),
	('Completed', 'Transaction has successfully completed.'),
	('Failed', 'Transaction could not be completed.'),
	('Cancelled', 'Transaction was cancelled before completion.'),
	('Reversed', 'Previously completed transaction was subsequently reversed.');


--============================================================================================================================
-- MERCHANT CATEGORIES
--============================================================================================================================

INSERT INTO merchant_categories (
	merchant_category_name,
	merchant_category_description
)
VALUES
	('Groceries', 'Grocery stores and food retailers.'),
	('Restaurants', 'Restaurants, cafes, and other dining establishments.'),
	('Gas_Stations', 'Gas stations and fuel providers.'),
	('Retail', 'General retail purchases.'),
	('Entertainment', 'Entertainment, recreation, and leisure services.'),
	('Healthcare', 'Medical, dental, pharmacy, and other healthcare services.'),
	('Travel', 'Airlines, hotels, rental cars, and other travel services.'),
	('Utilities', 'Electricity, gas, water, and other utility services.'),
	('Subscription_Services', 'Recurring subscription-based services.'),
	('Government', 'Government agencies and government-related payments.');


--============================================================================================================================
-- MERCHANTS
--============================================================================================================================

INSERT INTO merchants (
	merchant_name,
	merchant_description
)
VALUES
	('Walmart', 'Large general merchandise and grocery retailer.'),
	('Amazon', 'Online marketplace and retail company.'),
	('Target', 'General merchandise and retail retailer.'),
	('Whole Foods', 'Grocery retailer specializing in food and household products.'),
	('Costco', 'Membership-based warehouse retailer.'),
	('Shell', 'Fuel and convenience retailer.'),
	('Exxonmobil', 'Fuel and convenience retailer.'),
	('McDonalds', 'Fast-food restaurant chain.'),
	('Starbucks', 'Coffeehouse and beverage retailer.'),
	('Netflix', 'Subscription-based entertainment streaming service.'),
	('Spotify', 'Subscription-based music streaming service.'),
	('Delta Airlines', 'Commercial airline.'),
	('Marriott', 'Hotel and hospitality company.'),
	('CVS', 'Pharmacy and healthcare retailer.'),
	('Walgreens', 'Pharmacy and healthcare retailer.'),
	('Verizon', 'Telecommunications and wireless service provider.'),
	('Con Edison', 'Utility provider.'),
	('New Jersey MVC', 'New Jersey government motor vehicle agency.'),
	('Uber', 'Transportation and delivery platform.'),
	('Home Depot', 'Home improvement retailer.');


--============================================================================================================================
-- EMPLOYEE ROLES
--============================================================================================================================

INSERT INTO employee_roles (
    employee_role_name,
    role_description
) VALUES
    ('Branch Manager', 'Manages branch operations, employees, customer service, and branch performance.'),
    ('Assistant Branch Manager', 'Supports the branch manager with daily operations and staff supervision.'),
    ('Bank Teller', 'Handles routine customer transactions including deposits, withdrawals, and account services.'),
    ('Customer Service Representative', 'Assists customers with account questions, requests, and general banking services.'),
    ('Personal Banker', 'Works directly with customers to open accounts and provide personalized banking products and services.'),
    ('Loan Officer', 'Assists customers with loan applications, credit evaluation, and lending decisions.'),
    ('Relationship Manager', 'Manages ongoing relationships with customers and helps identify appropriate financial products and services.'),
    ('Operations Specialist', 'Supports branch and banking operations including documentation, processing, and administrative tasks.'),
    ('Compliance Specialist', 'Helps ensure banking activities comply with applicable laws, regulations, and internal policies.'),
    ('Financial Analyst', 'Analyzes financial and operational data to support business and management decisions.');