DROP TABLE IF EXISTS balance_history;
DROP TABLE IF EXISTS transaction_entries;
DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS merchants;
DROP TABLE IF EXISTS merchant_categories;
DROP TABLE IF EXISTS transaction_channels;
DROP TABLE IF EXISTS transaction_statuses;
DROP TABLE IF EXISTS transaction_types;

DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS account_products;
DROP TABLE IF EXISTS account_types;
DROP TABLE IF EXISTS account_statuses;

DROP TABLE IF EXISTS customer_addresses;
DROP TABLE IF EXISTS address_types;
DROP TABLE IF EXISTS customers;

DROP TABLE IF EXISTS employees;
DROP TABLE IF EXISTS employee_roles;

DROP TABLE IF EXISTS branches;
DROP TABLE IF EXISTS addresses;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS states;
DROP TABLE IF EXISTS regions;
--DROP TABLE IF EXISTS loans;
--DROP TABLE IF EXISTS loan_payments;
--DROP TABLE IF EXISTS loan_applications;

DROP TYPE IF EXISTS transaction_entry_type;

--============================================================================================================================
-- LOCATIONS
--============================================================================================================================

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

--in real setting, branch_code would be the actual unique identifier but unique branch_name works for the project
CREATE TABLE branches(
	branch_id SERIAL PRIMARY KEY,
	branch_name VARCHAR(100) NOT NULL UNIQUE, 
	address_id INTEGER NOT NULL UNIQUE REFERENCES addresses(address_id),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);


--============================================================================================================================
-- EMPLOYEES
--============================================================================================================================


CREATE TABLE employee_roles(
	employee_role_id SERIAL PRIMARY KEY,
	employee_role_name VARCHAR(50) NOT NULL UNIQUE,
	role_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE employees(
	employee_id SERIAL PRIMARY KEY,
	branch_id INTEGER NOT NULL REFERENCES branches(branch_id),
	employee_role_id INTEGER NOT NULL REFERENCES employee_roles(employee_role_id),
	employee_first_name VARCHAR(100) NOT NULL,
	employee_last_name VARCHAR(100) NOT NULL,
	hire_date DATE NOT NULL,
	termination_date DATE,
	salary NUMERIC(12,2) NOT NULL DEFAULT 0.00
		CHECK (salary >= 0),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,

	CHECK (termination_date IS NULL OR termination_date >= hire_date)
);


--============================================================================================================================
-- CUSTOMERS
--============================================================================================================================


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

CREATE TABLE address_types(
	address_type_id SERIAL PRIMARY KEY,
	address_type_name VARCHAR(30) NOT NULL UNIQUE,
	address_description TEXT,
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


--============================================================================================================================
-- ACCOUNTS
--============================================================================================================================


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
	account_status_description TEXT,
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


--============================================================================================================================
-- TRANSACTIONS
--============================================================================================================================

--What transaction event took place, NOT which account money came/was taken from
--ex. DEPOSIT, WITHDRAWAL, TRANSFER, PURCHASE, ATM_WITHDRAWAL, DIRECT_DEPOSIT, 
--    BILL_PAYMENT, FEE, INTEREST_CREDIT, REFUND, LOAN_PAYMENT
CREATE TABLE transaction_types(
	transaction_type_id SERIAL PRIMARY KEY,
	transaction_type_name VARCHAR(50) NOT NULL UNIQUE,
	transaction_type_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--The channel where the transaction originated from which is separate from the type of transaction
--ex. Type: ATM_WITHDRAWAL, Channel: ATM
--ex. Type: BILL_PAYMENT, Channel: ONLINE
--ex. ATM, DEBIT_CARD, ONLINE, MOBILE, EMPLOYER, BRANCH, etc
CREATE TABLE transaction_channels(
	transaction_channel_id SERIAL PRIMARY KEY,
	transaction_channel_name VARCHAR(50) NOT NULL UNIQUE,
	transaction_channel_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--PENDING, COMPLETED, FAILED, CANCELLED, REVERSED
CREATE TABLE transaction_statuses(
	transaction_status_id SERIAL PRIMARY KEY,
	transaction_status_name VARCHAR(50) NOT NULL UNIQUE, 
	transaction_status_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--exists separately from merchant_categories unlike most of the other tables
--since theres a situation where a singular merchant like Amazon which can refer to multiple categories
--it wouldnt be ideal to make them relationally dependant on one or the other
--ex. WALMART, AMAZON, etc.
CREATE TABLE merchants(
	merchant_id SERIAL PRIMARY KEY,
	merchant_name VARCHAR(150) NOT NULL UNIQUE,
	merchant_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--ex. GROCERIES, RESTAURANTS, GAS STATIONS, RETAIL, ENTERTAINMENT, 
--    HEALTHCARE, TRAVEL, UTILITIES, SUBSCRIPTIONS_SERVICES, GOVERNMENT
CREATE TABLE merchant_categories(
	merchant_category_id SERIAL PRIMARY KEY,
	merchant_category_name VARCHAR(150) NOT NULL UNIQUE,
	merchant_category_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	updated_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE transactions(
	transaction_id SERIAL PRIMARY KEY,
	transaction_type_id INTEGER NOT NULL REFERENCES transaction_types(transaction_type_id),
	transaction_status_id INTEGER NOT NULL REFERENCES transaction_statuses(transaction_status_id),
	transaction_timestamp TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
	merchant_id INTEGER REFERENCES merchants(merchant_id),
	merchant_category_id INTEGER REFERENCES merchant_categories(merchant_category_id),
	transaction_channel_id INTEGER NOT NULL REFERENCES transaction_channels(transaction_channel_id),
	city_id INTEGER REFERENCES cities(city_id), --may be online so no significant transaction location
	transaction_description TEXT,
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--Entry type in a transaction refers to whether money is leaving (debit) or entering (credit) the account
--We can establish an ENUM type here since we know the entry type wont expand like other status or types
CREATE TYPE transaction_entry_type AS ENUM('DEBIT', 'CREDIT');

CREATE TABLE transaction_entries(
	transaction_entry_id SERIAL PRIMARY KEY,
	transaction_id INTEGER NOT NULL REFERENCES transactions(transaction_id),
	account_id INTEGER NOT NULL REFERENCES accounts(account_id),
	entry_type transaction_entry_type NOT NULL,
	amount NUMERIC(15,2) NOT NULL 
		CHECK (amount > 0),
	created_at TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

--stage 3: loans, loan_payments, loan_applications