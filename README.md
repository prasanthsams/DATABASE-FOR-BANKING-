# DATABASE-FOR-BANKING-
Banking Database Management System (DBMS) Project

 Table of Contents

1. Project Overview


2. Database Design


3. Key Features


4. How to Run


5. Example Queries


6. Learning Outcomes


7. Contributors




---

Project Overview

This project is a Banking Management Database built using PostgreSQL / PL/pgSQL.
It contains 16 tables for core banking operations such as customers, accounts, employees, transactions, branches, and more.

The project also implements:

Primary Keys, Candidate Keys, Foreign Keys

 Triggers (for automatic balance updates & employee audits)

 Locking Mechanisms (row-level & table-level locks)

 Stored Procedures & Functions

 Transaction Management (BEGIN, COMMIT, ROLLBACK)



---

📂 Database Design

🖼 ER Diagram

Customers → Accounts → Transactions

Employees → Branches → Audit Logs

Foreign keys enforce referential integrity



---

📑 Key Features

1. Customer Management

Store customer details (name, email, KYC, branch).



2. Account Management

Savings, Current, Loan accounts with balances.



3. Transaction Handling

Deposits, Withdrawals, Transfers.



4. Triggers

Example: Auto-update account balance on each transaction.


CREATE OR REPLACE FUNCTION update_account_balance()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.transaction_type = 'deposit' THEN
        UPDATE accounts
        SET balance = balance + NEW.amount
        WHERE account_no = NEW.account_no;
    ELSIF NEW.transaction_type = 'withdraw' THEN
        UPDATE accounts
        SET balance = balance - NEW.amount
        WHERE account_no = NEW.account_no;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


5. Employee Audit Logs

Every insert/update/delete on employees is recorded with TG_OP.



6. Locking System

Example of row-level lock:


BEGIN;
SELECT * FROM accounts WHERE account_no = 101 FOR UPDATE;
COMMIT;


7. Transaction Safety

Use of ROLLBACK in case of errors.





---

🔧 How to Run

1. Install PostgreSQL (≥ 14).


2. Clone this repo:

git clone https://github.com/yourusername/banking-dbms.git
cd banking-dbms


3. Create the database:

CREATE DATABASE banking_system;


4. Run the schema:

psql -U postgres -d banking_system -f schema.sql


5. Insert sample data:

psql -U postgres -d banking_system -f data.sql


6. Test queries, triggers, and locks.




---

📊 Example Queries

Get total customers per branch:


SELECT branch_id, COUNT(*) AS total_customers
FROM customers
GROUP BY branch_id;

View active locks:


SELECT relation::regclass AS table_name, mode, granted
FROM pg_locks
WHERE relation IS NOT NULL;
