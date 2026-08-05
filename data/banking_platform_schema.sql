--SELECT version();
--SELECT current_database();

DROP TABLE IF EXISTS balance_history;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS account_products;
DROP TABLE IF EXISTS account_types;
DROP TABLE IF EXISTS account_statuses;
DROP TABLE IF EXISTS customer_addresses;
DROP TABLE IF EXISTS address_types;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS states;
DROP TABLE IF EXISTS regions;
--DROP TABLE IF EXISTS employees;
--DROP TABLE IF EXISTS loans;
--DROP TABLE IF EXISTS loan_payments;
--DROP TABLE IF EXISTS loan_applications;

CREATE TABLE regions(
	region_id SERIAL PRIMARY KEY,
	region_name VARCHAR(50) NOT NULL UNIQUE, --northeast, southeast, midwest, etc. Can be used for advanced analytics later
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE states(
	state_code CHAR(2) PRIMARY KEY, -- ex. nj,ny,etc. Since its already unique theoretically we dont need another id
	state_name VARCHAR(50) NOT NULL UNIQUE,
	region_id INTEGER NOT NULL REFERENCES regions(region_id),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE cities(
	city_id SERIAL PRIMARY KEY,
	city_name VARCHAR(50) NOT NULL,
	state_code CHAR(2) NOT NULL REFERENCES states(state_code),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	--cities can have the same name but there shouldnt be multiple cities with the same name in a singular state
	UNIQUE (city_name, state_code)
);

CREATE TABLE addresses(
	address_id SERIAL PRIMARY KEY,
	street_address VARCHAR(150) NOT NULL,
	city_id INTEGER NOT NULL REFERENCES cities(city_id),
	postal_code VARCHAR(10) NOT NULL,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	UNIQUE (street_address, city_id, postal_code)
);

CREATE TABLE address_types(
	address_type_id SERIAL PRIMARY KEY,
	address_type_name VARCHAR(30) NOT NULL UNIQUE,
	address_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--in real setting, branch_code would be the actual unique identifier but unique branch_name works for the project
CREATE TABLE branches(
	branch_id SERIAL PRIMARY KEY,
	branch_name VARCHAR(100) NOT NULL UNIQUE, 
	address_id INTEGER NOT NULL UNIQUE REFERENCES addresses(address_id),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	branch_id INTEGER NOT NULL REFERENCES branches(branch_id),
	customer_first_name VARCHAR(100) NOT NULL,
	customer_last_name VARCHAR(100) NOT NULL,
	dob DATE NOT NULL,
	annual_income NUMERIC(12,2) 
		CHECK (annual_income >= 0),
	credit_score INTEGER 
		CHECK (credit_score BETWEEN 300 AND 850), --follows FICO score convention
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--could add start_date and end_date columns to represent customer addresses from certain time periods
CREATE TABLE customer_addresses(
	customer_address_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
	address_id INTEGER NOT NULL REFERENCES addresses(address_id),
	address_type_id INTEGER NOT NULL REFERENCES address_types(address_type_id),
	is_primary BOOLEAN NOT NULL DEFAULT FALSE,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (customer_id, address_id, address_type_id)
);

CREATE UNIQUE INDEX unique_primary_address
ON customer_addresses (customer_id)
WHERE is_primary = TRUE;

CREATE TABLE account_types(
	account_type_id SERIAL PRIMARY KEY,
	account_type_name VARCHAR(50) NOT NULL UNIQUE, --checking, savings, credit, etc (potentially add cd later)
	account_type_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE account_statuses(
	account_status_id SERIAL PRIMARY KEY,
	account_status_name VARCHAR(50) NOT NULL UNIQUE, --active, inactive, frozen, closed, etc (maybe add delinquent later)
	status_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE account_products(
	account_product_id SERIAL PRIMARY KEY,
	account_product_name VARCHAR(50) NOT NULL UNIQUE, --specific type of "product" offered by a bank ex. basic checking vs premium checking
	account_type_id INTEGER NOT NULL REFERENCES account_types(account_type_id), --standard checking,saving,credit,etc
	interest_rate NUMERIC(5,2)
		CHECK (interest_rate >= 0),
	monthly_fee NUMERIC(10,2) NOT NULL DEFAULT 0.00
		CHECK (monthly_fee >= 0),
	minimum_balance NUMERIC(15,2) NOT NULL DEFAULT 0.00
		CHECK (minimum_balance >= 0),
	maximum_credit_limit  NUMERIC(15,2)
		CHECK (maximum_credit_limit >= 0),
	is_active BOOLEAN NOT NULL DEFAULT TRUE,
	account_product_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts(
	account_id SERIAL PRIMARY KEY, --consider adding account_number which acts as a separate business identifier
	customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
	account_product_id INTEGER NOT NULL REFERENCES account_products(account_product_id),
	current_balance NUMERIC(15,2) NOT NULL DEFAULT 0.00,
	account_status_id INTEGER NOT NULL REFERENCES account_statuses(account_status_id),
	credit_limit NUMERIC(15,2)
		CHECK (credit_limit >= 0),
	opened_date DATE NOT NULL,
	closed_date DATE,
	overdraft_limit NUMERIC(15,2) --how far over your limit you are allowed to go
		CHECK (overdraft_limit >= 0),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	--table constraint
	CHECK (closed_date IS NULL OR closed_date >= opened_date)
);

CREATE TABLE balance_history(
	balance_history_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL REFERENCES accounts(account_id),
	balance NUMERIC(15,2) NOT NULL DEFAULT 0.00,
	balance_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (account_id, balance_timestamp)
);

--breakdown into lookup tables later
CREATE TABLE transactions(
	transaction_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL REFERENCES accounts(account_id),
	transaction_type VARCHAR(100) NOT NULL,
	amount NUMERIC(15,2) NOT NULL
		CHECK (amount <> 0),
	transaction_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	merchant_name VARCHAR(150), --Business involved in transaction (can be direct deposit so let it be NULL)
	merchant_category VARCHAR(50), --type of service (groceries, restaurants, etc)
	transaction_status VARCHAR(20) NOT NULL, --could be ENUM but leave it VARCHAR for flexibility
	channel VARCHAR(20) NOT NULL, --how the user initiated the transaction (atm, online, mobile, etc)
	location_city VARCHAR(100), --may be online so no significant transaction location
	location_state CHAR(2),
	transaction_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--stage 2: employees
--stage 3: loans, loan_payments, loan_applications