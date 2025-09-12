--
-- PostgreSQL database dump
--

-- Dumped from database version 17.5
-- Dumped by pg_dump version 17.5

-- Started on 2025-09-13 00:25:43

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = on;

DROP DATABASE IF EXISTS postgres;
--
-- TOC entry 4888 (class 1262 OID 5)
-- Name: postgres; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE postgres WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'English_India.1252';


ALTER DATABASE postgres OWNER TO postgres;

\connect postgres

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = on;

--
-- TOC entry 4889 (class 0 OID 0)
-- Dependencies: 4888
-- Name: DATABASE postgres; Type: COMMENT; Schema: -; Owner: postgres
--

COMMENT ON DATABASE postgres IS 'default administrative connection database';


--
-- TOC entry 4 (class 2615 OID 2200)
-- Name: public; Type: SCHEMA; Schema: -; Owner: pg_database_owner
--

CREATE SCHEMA public;


ALTER SCHEMA public OWNER TO pg_database_owner;

--
-- TOC entry 4890 (class 0 OID 0)
-- Dependencies: 4
-- Name: SCHEMA public; Type: COMMENT; Schema: -; Owner: pg_database_owner
--

COMMENT ON SCHEMA public IS 'standard public schema';


--
-- TOC entry 243 (class 1255 OID 32844)
-- Name: accounts_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.accounts_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

IF TG_OP='INSERT' THEN
insert into accounts(account_no,customer_id,account_type,opening_date,balnce,branch_id,version,action_type)
values(NEW.accounts_no,NEW.customer_id,NEW.account_type,NEW.opening_date,NEW.balance,NEW.branch_id,'insert');

elsIF TG_OP='update' THEN
insert into accounts(account_no,customer_id,account_type,opening_date,balnce,branch_id,version,action_type)
values(NEW.accounts_no,NEW.customer_id,NEW.account_type,NEW.opening_date,NEW.balance,NEW.branch_id,'update');

elsIF TG_OP='delete' THEN
insert into accounts(account_no,customer_id,account_type,opening_date,balnce,branch_id,version,action_type)
values(OLD.accounts_no,OLD.customer_id,OLD.account_type,OLD.opening_date,OLD.balance,OLD.branch_id,'delete');





END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.accounts_update() OWNER TO postgres;

--
-- TOC entry 228 (class 1255 OID 32792)
-- Name: balance_check(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.balance_check() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 

if new.transacation_type='deposit'
then 
update accounts 
set balnce = balance+new.amount
where account_no=new.account_no;

elseif new.transacation_type='UPI'
then 
update accounts 
set balance = balance-new.ammount
where acccount_no = new.account_no; 

end if;
return new;
END;
 $$;


ALTER FUNCTION public.balance_check() OWNER TO postgres;

--
-- TOC entry 245 (class 1255 OID 32836)
-- Name: creditcards_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.creditcards_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

if tg_op = 'insert' then 
insert into kyc(kyc_id,customer_id,aadhaar_no,pan_no,customer_name,action_type)
values(NEW.kyc_id,NEW.customer_id,NEW.aadhaar_no,NEW.pan_no,NEW.customer_name,'insert');


elsif tg_op = 'update' then 
insert into kyc(kyc_id,customer_id,aadhaar_no,pan_no,customer_name,action_type)
values(NEW.kyc_id,NEW.customer_id,NEW.aadhaar_no,NEW.pan_no,NEW.customer_name, 'update');



ELSif tg_op = 'delete' then 
insert into kyc(kyc_id,customer_id,aadhaar_no,pan_no,customer_name,action_type)
values(OLD.kyc_id,OLD.customer_id,OLD.aadhaar_no,OLD.pan_no,OLD.customer_name,'delete');
END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.creditcards_update() OWNER TO postgres;

--
-- TOC entry 240 (class 1255 OID 32819)
-- Name: employee_audit_trigger(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employee_audit_trigger() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO employee_audit(employee_id, employee_name, action_type)
        VALUES (NEW.employee_id, NEW.employee_name, 'INSERT');

    ELSIF TG_OP = 'UPDATE' THEN
        INSERT INTO employee_audit(employee_id, employee_name, action_type)
        VALUES (NEW.employee_id, NEW.employee_name, 'UPDATE');

    ELSIF TG_OP = 'DELETE' THEN
        INSERT INTO employee_audit(employee_id, employee_name, action_type)
        VALUES (OLD.employee_id, OLD.employee_name, 'DELETE');
    END IF;

    RETURN NEW;
END;
$$;


ALTER FUNCTION public.employee_audit_trigger() OWNER TO postgres;

--
-- TOC entry 241 (class 1255 OID 32831)
-- Name: employees_job_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.employees_job_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

if TG_OP='insert' then
insert into creditcards(card_id,customer_id,card_no,limit_amount,expiry_date,card_type,action_type)
values(NEW.card_id,NEW.customer_id,NEW.card_no,NEW.limit_amount,NEW.expiry_date,NEW.card_type);
elsif TG_OP='update' then
insert into creditcards(card_id,customer_id,card_no,limit_amount,expiry_date,card_type,action_type)
values(NEW.card_id,NEW.customer_id,NEW.card_no,NEW.limit_amount,NEW.expiry_date,NEW.card_type);
elsif TG_OP='delete' then
insert into creditcards(card_id,customer_id,card_no,limit_amount,expiry_date,card_type,action_type)
values(OLD.card_id,OLD.customer_id,OLD.card_no,OLD.limit_amount,OLD.expiry_date,OLD.card_type);

END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.employees_job_update() OWNER TO postgres;

--
-- TOC entry 242 (class 1255 OID 32841)
-- Name: insurance_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.insurance_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

IF TG_OP='INSERT' THEN
insert into accounts(account_no,customer_id,account_type,opening_date,balnce,branch_id,version,action_type)
values(NEW.accounts_no,NEW.customer_id,NEW.account_type,NEW.opening_date,NEW.balance,NEW.branch_id,'insert');

elsIF TG_OP='update' THEN
insert into accounts(account_no,customer_id,account_type,opening_date,balnce,branch_id,version,action_type)
values(NEW.accounts_no,NEW.customer_id,NEW.account_type,NEW.opening_date,NEW.balance,NEW.branch_id,'update');

elsIF TG_OP='delete' THEN
insert into accounts(account_no,customer_id,account_type,opening_date,balnce,branch_id,version,action_type)
values(OLD.accounts_no,OLD.customer_id,OLD.account_type,OLD.opening_date,OLD.balance,OLD.branch_id,'delete');





END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.insurance_update() OWNER TO postgres;

--
-- TOC entry 244 (class 1255 OID 32838)
-- Name: kyc_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.kyc_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin

IF TG_OP='insert' then
insert into insurance(insurance_id,insurance_type,insurance_amount,insurance_interst,start_date,expiry_date,action_type)
values (NEW.insurance_id,NEW.insurance_type,NEW.insurance_amount,NEW.insurance_interst,NEW.start_date,NEW.expiry_date,'insert');


ELSIF TG_OP='update' then
insert into insurance(insurance_id,insurance_type,insurance_amount,insurance_interst,start_date,expiry_date,action_type)
values (NEW.insurance_id,NEW.insurance_type,NEW.insurance_amount,NEW.insurance_interst,NEW.start_date,NEW.expiry_date,'update');

ELSIF TG_OP='DELETE' then
insert into insurance(insurance_id,insurance_type,insurance_amount,insurance_interst,start_date,expiry_date,action_type)
values (OLD.insurance_id,OLD.insurance_type,OLD.insurance_amount,OLD.insurance_interst,OLD.start_date,OLD.expiry_date,'delete');




END IF;
RETURN NEW;
END;
$$;


ALTER FUNCTION public.kyc_update() OWNER TO postgres;

--
-- TOC entry 227 (class 1255 OID 24800)
-- Name: update_branch_customer_count(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.update_branch_customer_count() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin 
if tg_op ='insert' then 
update branch
set total_customer= total_customer + 1
where branch_id = new.branch_id;
end if ;
if tg_op = 'delete' then 
update branch 
set total_customer = 
total_customer-1
where branch_id = old.branch_id;
end if;
return null;
end;
$$;


ALTER FUNCTION public.update_branch_customer_count() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 221 (class 1259 OID 24629)
-- Name: accounts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.accounts (
    account_no bigint,
    customer_id bigint,
    account_type character varying(20),
    opening_date character varying(20),
    balance character varying,
    branch_id bigint,
    version bigint DEFAULT 1
);


ALTER TABLE public.accounts OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 24775)
-- Name: branch; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.branch (
    branch_id character varying(10) NOT NULL,
    branch_name character varying(50),
    city character varying(50),
    pincode bigint,
    total_customer character varying(50),
    total_employee character varying(30)
);


ALTER TABLE public.branch OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 24714)
-- Name: creditcards; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.creditcards (
    card_id bigint NOT NULL,
    customer_id character varying,
    card_no bigint,
    limit_amount character varying(100),
    expiry_date character varying(200),
    card_type character varying(50)
);


ALTER TABLE public.creditcards OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 24579)
-- Name: customer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.customer (
    customername character(30),
    account_no bigint,
    customer_id character varying(30) NOT NULL,
    address character varying(200),
    mobile_no bigint,
    email_id character varying(200),
    ifsc_code character varying(20),
    city character varying(30) DEFAULT 'active'::character varying
);


ALTER TABLE public.customer OWNER TO postgres;

--
-- TOC entry 218 (class 1259 OID 24585)
-- Name: employees; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.employees (
    employee_name character(40),
    employee_id character varying(30) NOT NULL,
    address character varying(200),
    mobile_no bigint,
    email_id character varying(200),
    aadhaar_no bigint,
    salary character varying(40),
    job_position character varying(40),
    experience character varying(40)
);


ALTER TABLE public.employees OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 24789)
-- Name: insurance; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.insurance (
    insurance_id bigint NOT NULL,
    insurance_type character varying(30),
    insurance_amount character varying(50),
    insurance_interest character varying(50),
    start_date character varying(30),
    expiry_date character varying(30)
);


ALTER TABLE public.insurance OWNER TO postgres;

--
-- TOC entry 224 (class 1259 OID 24745)
-- Name: kyc; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kyc (
    kyc_id bigint NOT NULL,
    customer_id character varying(20),
    aadhaar_no character varying(30),
    pan_no character varying(20),
    customer_name character varying(80)
);


ALTER TABLE public.kyc OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 24626)
-- Name: loans; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.loans (
    loan_id bigint NOT NULL,
    customer_id bigint,
    account_no bigint,
    loan_type character varying(20),
    loan_amount character varying(30),
    interest_rate character varying(30),
    issue_date character varying(30),
    due_date character varying(30)
);


ALTER TABLE public.loans OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 24663)
-- Name: online_banking; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.online_banking (
    account_no bigint,
    online_id bigint NOT NULL,
    user_name character varying(100),
    amount character varying(200),
    receiver_name character(200),
    balance character varying(100)
);


ALTER TABLE public.online_banking OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 24623)
-- Name: transacation; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.transacation (
    transacation_id character varying(20),
    customer_id character varying(30),
    account_no bigint,
    transacation_type character varying(30),
    amount character varying(30),
    balance_after character varying,
    transacation_date character varying(20)
);


ALTER TABLE public.transacation OWNER TO postgres;

--
-- TOC entry 4705 (class 2606 OID 24781)
-- Name: branch branch_branch_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_branch_name_key UNIQUE (branch_name);


--
-- TOC entry 4707 (class 2606 OID 24783)
-- Name: branch branch_pincode_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pincode_key UNIQUE (pincode);


--
-- TOC entry 4709 (class 2606 OID 24779)
-- Name: branch branch_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.branch
    ADD CONSTRAINT branch_pkey PRIMARY KEY (branch_id);


--
-- TOC entry 4695 (class 2606 OID 24722)
-- Name: creditcards creditcards_card_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creditcards
    ADD CONSTRAINT creditcards_card_no_key UNIQUE (card_no);


--
-- TOC entry 4697 (class 2606 OID 24720)
-- Name: creditcards creditcards_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creditcards
    ADD CONSTRAINT creditcards_pkey PRIMARY KEY (card_id);


--
-- TOC entry 4711 (class 2606 OID 24795)
-- Name: insurance insurance_insurance_interest_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_insurance_interest_key UNIQUE (insurance_interest);


--
-- TOC entry 4713 (class 2606 OID 24793)
-- Name: insurance insurance_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.insurance
    ADD CONSTRAINT insurance_pkey PRIMARY KEY (insurance_id);


--
-- TOC entry 4699 (class 2606 OID 24760)
-- Name: kyc kyc_aadhaar_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc
    ADD CONSTRAINT kyc_aadhaar_no_key UNIQUE (aadhaar_no);


--
-- TOC entry 4701 (class 2606 OID 24768)
-- Name: kyc kyc_pan_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc
    ADD CONSTRAINT kyc_pan_no_key UNIQUE (pan_no);


--
-- TOC entry 4703 (class 2606 OID 24749)
-- Name: kyc kyc_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc
    ADD CONSTRAINT kyc_pkey PRIMARY KEY (kyc_id);


--
-- TOC entry 4685 (class 2606 OID 24685)
-- Name: loans loans_loan_type_loan_amount_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_loan_type_loan_amount_key UNIQUE (loan_type, loan_amount);


--
-- TOC entry 4687 (class 2606 OID 24683)
-- Name: loans loans_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.loans
    ADD CONSTRAINT loans_pkey PRIMARY KEY (loan_id);


--
-- TOC entry 4689 (class 2606 OID 24669)
-- Name: online_banking online_banking_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.online_banking
    ADD CONSTRAINT online_banking_pkey PRIMARY KEY (online_id);


--
-- TOC entry 4691 (class 2606 OID 24673)
-- Name: online_banking online_banking_receiver_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.online_banking
    ADD CONSTRAINT online_banking_receiver_name_key UNIQUE (receiver_name);


--
-- TOC entry 4693 (class 2606 OID 24671)
-- Name: online_banking online_banking_user_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.online_banking
    ADD CONSTRAINT online_banking_user_name_key UNIQUE (user_name);


--
-- TOC entry 4671 (class 2606 OID 24633)
-- Name: customer pk_customer_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT pk_customer_id PRIMARY KEY (customer_id);


--
-- TOC entry 4679 (class 2606 OID 24646)
-- Name: employees pk_employee_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT pk_employee_id PRIMARY KEY (employee_id);


--
-- TOC entry 4673 (class 2606 OID 24642)
-- Name: customer unique_email_id; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT unique_email_id UNIQUE (email_id);


--
-- TOC entry 4675 (class 2606 OID 24644)
-- Name: customer unique_mobile_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT unique_mobile_no UNIQUE (mobile_no);


--
-- TOC entry 4681 (class 2606 OID 24650)
-- Name: employees uq_aadhaar_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT uq_aadhaar_no UNIQUE (aadhaar_no);


--
-- TOC entry 4677 (class 2606 OID 24635)
-- Name: customer uq_account_no; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.customer
    ADD CONSTRAINT uq_account_no UNIQUE (account_no);


--
-- TOC entry 4683 (class 2606 OID 24648)
-- Name: employees uq_employee_name; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.employees
    ADD CONSTRAINT uq_employee_name UNIQUE (employee_name);


--
-- TOC entry 4722 (class 2620 OID 32845)
-- Name: accounts ACCOUNTS_UPDATE(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "ACCOUNTS_UPDATE()" AFTER INSERT OR DELETE OR UPDATE OF account_no, customer_id, account_type, opening_date, balance, branch_id, version ON public.accounts DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.accounts_update();


--
-- TOC entry 4723 (class 2620 OID 32793)
-- Name: accounts BALANCE_CHECK; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "BALANCE_CHECK" AFTER INSERT OR DELETE OR UPDATE ON public.accounts DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.balance_check();


--
-- TOC entry 4720 (class 2620 OID 32834)
-- Name: employees EMPLOYEES_AUDIT_TRIGGER; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "EMPLOYEES_AUDIT_TRIGGER" AFTER INSERT OR DELETE OR UPDATE ON public.employees DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE FUNCTION public.employee_audit_trigger();


--
-- TOC entry 4721 (class 2620 OID 32832)
-- Name: employees EMPLOYEES_UPDATE(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "EMPLOYEES_UPDATE()" AFTER INSERT OR DELETE OR UPDATE ON public.employees DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE FUNCTION public.employees_job_update();


--
-- TOC entry 4727 (class 2620 OID 32842)
-- Name: insurance INSURANCE_UPDATE(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "INSURANCE_UPDATE()" AFTER INSERT OR DELETE OR UPDATE OF insurance_id, insurance_amount, insurance_interest, insurance_type, start_date, expiry_date ON public.insurance DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.insurance_update();


--
-- TOC entry 4726 (class 2620 OID 32839)
-- Name: kyc KYC_UPDATE(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "KYC_UPDATE()" AFTER INSERT OR DELETE OR UPDATE OF kyc_id, customer_id, pan_no, customer_name, aadhaar_no ON public.kyc DEFERRABLE INITIALLY DEFERRED FOR EACH ROW EXECUTE FUNCTION public.kyc_update();


--
-- TOC entry 4892 (class 0 OID 0)
-- Dependencies: 4726
-- Name: TRIGGER "KYC_UPDATE()" ON kyc; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TRIGGER "KYC_UPDATE()" ON public.kyc IS 'KYC UPDATE ';


--
-- TOC entry 4724 (class 2620 OID 32781)
-- Name: accounts balance_check(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE CONSTRAINT TRIGGER "balance_check()" AFTER INSERT OR DELETE OR UPDATE OF balance ON public.accounts DEFERRABLE INITIALLY IMMEDIATE FOR EACH ROW EXECUTE FUNCTION public.update_branch_customer_count();


--
-- TOC entry 4725 (class 2620 OID 32837)
-- Name: creditcards credit_cards_update(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "credit_cards_update()" AFTER INSERT OR DELETE OR UPDATE ON public.creditcards FOR EACH ROW EXECUTE FUNCTION public.creditcards_update();


--
-- TOC entry 4718 (class 2620 OID 32795)
-- Name: customer customer_count(); Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER "customer_count()" AFTER INSERT OR DELETE OR UPDATE OF customername ON public.customer FOR EACH ROW EXECUTE FUNCTION public.update_branch_customer_count();


--
-- TOC entry 4719 (class 2620 OID 24801)
-- Name: customer trg_branch_customer_count; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_branch_customer_count AFTER INSERT OR DELETE ON public.customer FOR EACH ROW EXECUTE FUNCTION public.update_branch_customer_count();


--
-- TOC entry 4716 (class 2606 OID 24723)
-- Name: creditcards creditcards_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.creditcards
    ADD CONSTRAINT creditcards_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id) ON DELETE CASCADE;


--
-- TOC entry 4714 (class 2606 OID 24656)
-- Name: accounts fk_account_customer; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_account_customer FOREIGN KEY (account_no) REFERENCES public.customer(account_no) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- TOC entry 4715 (class 2606 OID 24636)
-- Name: accounts fk_account_no; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.accounts
    ADD CONSTRAINT fk_account_no FOREIGN KEY (account_no) REFERENCES public.customer(account_no);


--
-- TOC entry 4717 (class 2606 OID 24754)
-- Name: kyc kyc_customer_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kyc
    ADD CONSTRAINT kyc_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES public.customer(customer_id);


--
-- TOC entry 4891 (class 0 OID 0)
-- Dependencies: 218
-- Name: TABLE employees; Type: ACL; Schema: public; Owner: postgres
--

GRANT SELECT,INSERT ON TABLE public.employees TO vishva;


-- Completed on 2025-09-13 00:25:46

--
-- PostgreSQL database dump complete
--

