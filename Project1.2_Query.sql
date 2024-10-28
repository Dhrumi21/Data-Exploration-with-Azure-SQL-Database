-- 1. Setting Up Azure SQL Database

 -- Step 1.1: Create an Azure SQL Database in the Azure portal.

 -- Define a new database and server.
 -- Step 1.2: Name the database `CustomerAccountLoanDB`.

 -- 2. Data Organization

 --  Step 2.1: Create tables for the provided feeds:
 --Customer Feed:
 CREATE TABLE customers (
           customer_id INT PRIMARY KEY,
           first_name VARCHAR(50),
           last_name VARCHAR(50),
           address VARCHAR(100),
           city VARCHAR(50),
           state VARCHAR(50),
           zip VARCHAR(20)
       );

-- Account Feed:
 CREATE TABLE accounts (
           account_id INT PRIMARY KEY,
           customer_id INT,
           account_type VARCHAR(50),
           balance DECIMAL(10, 2),
           FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
       );

-- Transaction Feed:
   CREATE TABLE transactions (
           transaction_id INT PRIMARY KEY,
           account_id INT,
           transaction_date DATE,
           transaction_amount DECIMAL(10, 2),
           transaction_type VARCHAR(50),
           FOREIGN KEY (account_id) REFERENCES accounts(account_id)
       );
 -- Loan Feed:
  CREATE TABLE loans (
           loan_id INT PRIMARY KEY,
           customer_id INT,
           loan_amount DECIMAL(10, 2),
           interest_rate DECIMAL(5, 2),
           loan_term INT,
           FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
       );
 --- Loan Payment Feed:
 CREATE TABLE loan_payments (
           payment_id INT PRIMARY KEY,
           loan_id INT,
           payment_date DATE,
           payment_amount DECIMAL(10, 2),
           FOREIGN KEY (loan_id) REFERENCES loans(loan_id)
       );


Select *from customers;

-- 3. Data Insertion
   -- Step 3.1: Populate tables with sample data using `INSERT INTO` statements for each table.

INSERT INTO customers (customer_id, first_name, last_name, address, city, state, zip)
VALUES 
(88, 'Richard', 'Deon', '1212 Sherobee', 'Haileybury', 'ON', 'P0J0A1'),
(89, 'Eddie', 'Allen', '283 forth steet', 'Burks Falls', 'ON', 'P0A0A1'),
(90, 'Tonny', 'Harri', '8484 Cedar Lane', 'Tema', 'ON', 'P0H0A1'),
(91, 'Christofer', 'Myersal', '7171 CedarLane', 'Coldwater', 'ON', 'P0H0A1'),
(92, 'Minia', 'Ford', '71 Elm St', 'Oakville', 'ON', 'L3V0A1'),
(93, 'Allen', 'Hamilton', '72 Maple Ave', 'Gravenhurst', 'ON', 'P1P0A1'),
(94, 'Harrysen', 'Graham', '773 Oak Dr', 'Cookeville', 'ON', 'P0C0A1'),
(95, 'Josh', 'Sullivan', '74 Pine Rd', 'Bracebridge', 'ON', 'P1L0A1'),
(96, 'Eleven', 'Walls', '7071 Birch Blvd', 'Huntsville', 'ON', 'P1H0A1'),
(97, 'Daniela', 'Tylers', '762-116 Spruce Ln', 'Burks Falls', 'ON', 'P0A0A1'),
(98, 'Adibola', 'Cole', '777 Fir St', 'Sundridge', 'ON', 'P0A0A1'),
(99, 'Janne', 'West', '787 Redwood Dr', 'South River', 'ON', 'P0A0A1'),
(100, 'Emi', 'Jounior', '7000 Cypress Ave', 'North Bay', 'ON', 'P1B0A1');

 Select *from customers;  
  
-- Step 3.2: Ensure data consistency and relationships, ensuring each foreign key points to valid primary keys.


ALTER TABLE accounts
ADD CONSTRAINT FK_CustomerAccount
FOREIGN KEY (customer_id) REFERENCES customers(customer_id);

ALTER TABLE transactions
ADD CONSTRAINT FK_CustomerAccount1
FOREIGN KEY (account_id) REFERENCES accounts(account_id);


ALTER TABLE loans
ADD CONSTRAINT FK_CustomerAccount2
 FOREIGN KEY (customer_id) REFERENCES customers(customer_id);


ALTER TABLE loan_payments
ADD CONSTRAINT FK_CustomerAccount3
FOREIGN KEY (loan_id) REFERENCES loans(loan_id);


-- 4  Data Exploration

-- Step 4.1 Write query to retrieve all customer information:

SELECT * FROM customers;


-- Step 4.2  Query accounts for a specific customer:

SELECT * FROM accounts WHERE customer_id = 1;

-- Step 4.3 Find the customer name and account balance for each account

SELECT customers.first_name, customers.last_name, accounts.balance
FROM customers
JOIN accounts ON customers.customer_id = accounts.customer_id;


-- Step 4.4 Analyze customer loan balances
SELECT customers.first_name, customers.last_name, loans.loan_amount
FROM customers
JOIN loans ON customers.customer_id = loans.customer_id;



-- Step 4.5 List all customers who have made a transaction in the 2024-03

SELECT customers.first_name, customers.last_name
FROM customers
JOIN accounts ON customers.customer_id = accounts.customer_id
JOIN transactions ON accounts.account_id = transactions.account_id
WHERE transaction_date BETWEEN '2024-03-01' AND '2024-03-31';

--  5  Aggregation and Insights

--  Step 5.1 Calculate the total balance across all accounts for each customer:

SELECT customers.first_name, customers.last_name, SUM(accounts.balance) AS total_balance
FROM customers
JOIN accounts ON customers.customer_id = accounts.customer_id
GROUP BY customers.first_name, customers.last_name;

-- Step 5.2 Calculate the average loan amount for each loan term:
SELECT loan_term, AVG(loan_amount) AS avg_loan_amount
FROM loans
GROUP BY loan_term;


--  Step 5.3 Find the total loan amount and interest across all loans:
SELECT SUM(loan_amount) AS total_loan_amount, SUM(loan_amount * (interest_rate / 100)) AS total_interest
FROM loans;


-- Step 5.4 Find the most frequent transaction type:
SELECT transaction_type, COUNT(*) AS count
FROM transactions
GROUP BY transaction_type
ORDER BY count DESC;


-- Step 5.5  Analyze transactions by account and transaction type:
SELECT account_id, transaction_type, COUNT(*) AS transaction_count
FROM transactions
GROUP BY account_id, transaction_type;

-- 6 Advanced Analysis

-- Step 6.1 Create a view of active loans with payments greater than $1000:

CREATE VIEW active_loans AS
SELECT loans.loan_id, loans.loan_amount, SUM(loan_payments.payment_amount) AS total_payments
FROM loans
JOIN loan_payments ON loans.loan_id = loan_payments.loan_id
GROUP BY loans.loan_id, loans.loan_amount
HAVING SUM(loan_payments.payment_amount) > 1000;

-- Create an index on `transaction_date` in the `transactions` table for performance optimization

CREATE INDEX idx_transaction_date ON transactions(transaction_date);