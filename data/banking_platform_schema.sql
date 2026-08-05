--SELECT version();
--SELECT current_database();

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS states;
DROP TABLE IF EXISTS regions;
--DROP TABLE IF EXISTS employees;
--DROP TABLE IF EXISTS loans;
--DROP TABLE IF EXISTS loan_payments;
--DROP TABLE IF EXISTS loan_applications;

CREATE TABLE regions(
	region_id SERIAL PRIMARY KEY,
	region_name VARCHAR(50) NOT NULL UNIQUE, --northeast, south, midwest, etc. Can be used for advanced analytics later
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

CREATE TABLE branches(
	branch_id SERIAL PRIMARY KEY,
	branch_name VARCHAR(100) NOT NULL UNIQUE, --ideally we want a unique branch_name but later we can add branch_code instead
	city_id INTEGER NOT NULL REFERENCES cities(city_id),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE customers(
	customer_id SERIAL PRIMARY KEY,
	branch_id INTEGER NOT NULL REFERENCES branches(branch_id),
	c_first_name VARCHAR(100) NOT NULL,
	c_last_name VARCHAR(100) NOT NULL,
	dob DATE NOT NULL,
	annual_income NUMERIC(12,2) 
		CHECK (annual_income >= 0), --income may be null but if not realistically should be 0 or more
	credit_score INTEGER 
		CHECK (credit_score BETWEEN 300 AND 850), --follows FICO score convention
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts(
	account_id SERIAL PRIMARY KEY,
	customer_id INTEGER NOT NULL REFERENCES customers(customer_id),
	account_type VARCHAR(100) NOT NULL, --checking, savings, credit, etc
	balance NUMERIC(15,2) NOT NULL DEFAULT 0.00,
	status VARCHAR(50) NOT NULL, --active, closed, frozen, etc
	opened_date DATE NOT NULL,
	closed_date DATE,
	interest_rate NUMERIC(5,2)
		CHECK (interest_rate >= 0),
	overdraft_limit NUMERIC(15,2)
		CHECK (overdraft_limit >= 0),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	--table constraint
	CHECK (closed_date IS NULL OR closed_date >= opened_date)
);

CREATE TABLE transactions(
	transaction_id SERIAL PRIMARY KEY,
	account_id INTEGER NOT NULL REFERENCES accounts(account_id),
	transaction_type VARCHAR(100) NOT NULL,
	amount NUMERIC(15,2) NOT NULL
		CHECK (amount <> 0),
	transaction_timestamp TIMESTAMPTZ NOT NULL,
	merchant_name VARCHAR(150), --Business involved in transaction (can be direct deposit so let it be NULL)
	merchant_category VARCHAR(50), --type of service (groceries, restaurants, etc)
	transaction_status VARCHAR(20) NOT NULL, --could be ENUM but leave it VARCHAR for flexibility
	channel VARCHAR(20) NOT NULL, --how the user initiated the transaction (atm, online, mobile, etc)
	location_city VARCHAR(100), --may be online so no significant transaction location
	location_state CHAR(2),
	description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--stage 2: employees
--stage 3: loans, loan_payments, loan_applications