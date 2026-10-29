-- Local landing-zone seed for the Northwind analytics warehouse.
--
-- Source data: Microsoft Access 2010 Northwind sample, converted to MySQL by
-- Dale Scott as the MyWind project and adapted here for Postgres.
-- Table customers is renamed to customer so it matches the dbt source
-- northwind.customer (BigQuery dataset dl_northwind).
-- Attachments are stored as text because this dump has no binary payloads.
--
-- Copyright (c) 2014, Dale Scott
-- All rights reserved.
--
-- Redistribution and use in source and binary forms, with or without
-- modification, are permitted provided that the following conditions are met:
--
-- * Redistributions of source code must retain the above copyright notice, this
--   list of conditions and the following disclaimer.
--
-- * Redistributions in binary form must reproduce the above copyright notice,
--   this list of conditions and the following disclaimer in the documentation
--   and/or other materials provided with the distribution.
--
-- THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
-- AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
-- IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
-- ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
-- LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
-- CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
-- SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
-- INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
-- CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
-- ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
-- POSSIBILITY OF SUCH DAMAGE.

begin;

create schema if not exists dl_northwind;
set search_path to dl_northwind;

create table customer (
    id integer not null,
    company varchar(50),
    last_name varchar(50),
    first_name varchar(50),
    email_address varchar(50),
    job_title varchar(50),
    business_phone varchar(25),
    home_phone varchar(25),
    mobile_phone varchar(25),
    fax_number varchar(25),
    address text,
    city varchar(50),
    state_province varchar(50),
    zip_postal_code varchar(15),
    country_region varchar(50),
    web_page text,
    notes text,
    attachments text,
    primary key (id)
);
create table employees (
    id integer not null,
    company varchar(50),
    last_name varchar(50),
    first_name varchar(50),
    email_address varchar(50),
    job_title varchar(50),
    business_phone varchar(25),
    home_phone varchar(25),
    mobile_phone varchar(25),
    fax_number varchar(25),
    address text,
    city varchar(50),
    state_province varchar(50),
    zip_postal_code varchar(15),
    country_region varchar(50),
    web_page text,
    notes text,
    attachments text,
    primary key (id)
);
create table privileges (
    id integer not null,
    privilege_name varchar(50),
    primary key (id)
);
create table employee_privileges (
    employee_id integer not null,
    privilege_id integer not null,
    primary key (employee_id, privilege_id)
);
create table inventory_transaction_types (
    id smallint not null,
    type_name varchar(50) not null,
    primary key (id)
);
create table shippers (
    id integer not null,
    company varchar(50),
    last_name varchar(50),
    first_name varchar(50),
    email_address varchar(50),
    job_title varchar(50),
    business_phone varchar(25),
    home_phone varchar(25),
    mobile_phone varchar(25),
    fax_number varchar(25),
    address text,
    city varchar(50),
    state_province varchar(50),
    zip_postal_code varchar(15),
    country_region varchar(50),
    web_page text,
    notes text,
    attachments text,
    primary key (id)
);
create table orders_tax_status (
    id smallint not null,
    tax_status_name varchar(50) not null,
    primary key (id)
);
create table orders_status (
    id smallint not null,
    status_name varchar(50) not null,
    primary key (id)
);
create table orders (
    id integer not null,
    employee_id integer,
    customer_id integer,
    order_date timestamp,
    shipped_date timestamp,
    shipper_id integer,
    ship_name varchar(50),
    ship_address text,
    ship_city varchar(50),
    ship_state_province varchar(50),
    ship_zip_postal_code varchar(50),
    ship_country_region varchar(50),
    shipping_fee numeric(19,4),
    taxes numeric(19,4),
    payment_type varchar(50),
    paid_date timestamp,
    notes text,
    tax_rate double precision,
    tax_status_id smallint,
    status_id smallint,
    primary key (id)
);
create table products (
    supplier_ids text,
    id integer not null,
    product_code varchar(25),
    product_name varchar(50),
    description text,
    standard_cost numeric(19,4),
    list_price numeric(19,4) not null,
    reorder_level integer,
    target_level integer,
    quantity_per_unit varchar(50),
    discontinued smallint not null,
    minimum_reorder_quantity integer,
    category varchar(50),
    attachments text,
    primary key (id)
);
create table purchase_order_status (
    id integer not null,
    status varchar(50),
    primary key (id)
);
create table suppliers (
    id integer not null,
    company varchar(50),
    last_name varchar(50),
    first_name varchar(50),
    email_address varchar(50),
    job_title varchar(50),
    business_phone varchar(25),
    home_phone varchar(25),
    mobile_phone varchar(25),
    fax_number varchar(25),
    address text,
    city varchar(50),
    state_province varchar(50),
    zip_postal_code varchar(15),
    country_region varchar(50),
    web_page text,
    notes text,
    attachments text,
    primary key (id)
);
create table purchase_orders (
    id integer not null,
    supplier_id integer,
    created_by integer,
    submitted_date timestamp,
    creation_date timestamp,
    status_id integer,
    expected_date timestamp,
    shipping_fee numeric(19,4) not null,
    taxes numeric(19,4) not null,
    payment_date timestamp,
    payment_amount numeric(19,4),
    payment_method varchar(50),
    notes text,
    approved_by integer,
    approved_date timestamp,
    submitted_by integer,
    primary key (id)
);
create table inventory_transactions (
    id integer not null,
    transaction_type smallint not null,
    transaction_created_date timestamp,
    transaction_modified_date timestamp,
    product_id integer not null,
    quantity integer not null,
    purchase_order_id integer,
    customer_order_id integer,
    comments varchar(255),
    primary key (id)
);
create table invoices (
    id integer not null,
    order_id integer,
    invoice_date timestamp,
    due_date timestamp,
    tax numeric(19,4),
    shipping numeric(19,4),
    amount_due numeric(19,4),
    primary key (id)
);
create table order_details_status (
    id integer not null,
    status_name varchar(50) not null,
    primary key (id)
);
create table order_details (
    id integer not null,
    order_id integer not null,
    product_id integer,
    quantity numeric(18,4) not null,
    unit_price numeric(19,4),
    discount double precision not null,
    status_id integer,
    date_allocated timestamp,
    purchase_order_id integer,
    inventory_id integer,
    primary key (id)
);
create table purchase_order_details (
    id integer not null,
    purchase_order_id integer not null,
    product_id integer,
    quantity numeric(18,4) not null,
    unit_cost numeric(19,4) not null,
    date_received timestamp,
    posted_to_inventory smallint not null,
    inventory_id integer,
    primary key (id)
);
create table sales_reports (
    group_by varchar(50) not null,
    display varchar(50),
    title varchar(50),
    filter_row_source text,
    "default" smallint not null,
    primary key (group_by)
);
create table strings (
    string_id integer not null,
    string_data varchar(255),
    primary key (string_id)
);

insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (1, 'Company A', 'Bedecs', 'Anna', NULL, 'Owner', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 1st Street', 'Seattle', 'WA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (2, 'Company B', 'Gratacos Solsona', 'Antonio', NULL, 'Owner', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 2nd Street', 'Boston', 'MA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (3, 'Company C', 'Axen', 'Thomas', NULL, 'Purchasing Representative', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 3rd Street', 'Los Angelas', 'CA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (4, 'Company D', 'Lee', 'Christina', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 4th Street', 'New York', 'NY', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (5, 'Company E', 'O’Donnell', 'Martin', NULL, 'Owner', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 5th Street', 'Minneapolis', 'MN', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (6, 'Company F', 'Pérez-Olaeta', 'Francisco', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (7, 'Company G', 'Xie', 'Ming-Yang', NULL, 'Owner', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 7th Street', 'Boise', 'ID', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (8, 'Company H', 'Andersen', 'Elizabeth', NULL, 'Purchasing Representative', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 8th Street', 'Portland', 'OR', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (9, 'Company I', 'Mortensen', 'Sven', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 9th Street', 'Salt Lake City', 'UT', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (10, 'Company J', 'Wacker', 'Roland', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 10th Street', 'Chicago', 'IL', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (11, 'Company K', 'Krschne', 'Peter', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 11th Street', 'Miami', 'FL', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (12, 'Company L', 'Edwards', 'John', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '123 12th Street', 'Las Vegas', 'NV', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (13, 'Company M', 'Ludick', 'Andre', NULL, 'Purchasing Representative', '(123)555-0100', NULL, NULL, '(123)555-0101', '456 13th Street', 'Memphis', 'TN', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (14, 'Company N', 'Grilo', 'Carlos', NULL, 'Purchasing Representative', '(123)555-0100', NULL, NULL, '(123)555-0101', '456 14th Street', 'Denver', 'CO', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (15, 'Company O', 'Kupkova', 'Helena', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '456 15th Street', 'Honolulu', 'HI', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (16, 'Company P', 'Goldschmidt', 'Daniel', NULL, 'Purchasing Representative', '(123)555-0100', NULL, NULL, '(123)555-0101', '456 16th Street', 'San Francisco', 'CA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (17, 'Company Q', 'Bagel', 'Jean Philippe', NULL, 'Owner', '(123)555-0100', NULL, NULL, '(123)555-0101', '456 17th Street', 'Seattle', 'WA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (18, 'Company R', 'Autier Miconi', 'Catherine', NULL, 'Purchasing Representative', '(123)555-0100', NULL, NULL, '(123)555-0101', '456 18th Street', 'Boston', 'MA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (19, 'Company S', 'Eggerer', 'Alexander', NULL, 'Accounting Assistant', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 19th Street', 'Los Angelas', 'CA', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (20, 'Company T', 'Li', 'George', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 20th Street', 'New York', 'NY', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (21, 'Company U', 'Tham', 'Bernard', NULL, 'Accounting Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 21th Street', 'Minneapolis', 'MN', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (22, 'Company V', 'Ramos', 'Luciana', NULL, 'Purchasing Assistant', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 22th Street', 'Milwaukee', 'WI', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (23, 'Company W', 'Entin', 'Michael', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 23th Street', 'Portland', 'OR', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (24, 'Company X', 'Hasselberg', 'Jonas', NULL, 'Owner', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 24th Street', 'Salt Lake City', 'UT', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (25, 'Company Y', 'Rodman', 'John', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 25th Street', 'Chicago', 'IL', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (26, 'Company Z', 'Liu', 'Run', NULL, 'Accounting Assistant', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 26th Street', 'Miami', 'FL', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (27, 'Company AA', 'Toh', 'Karen', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 27th Street', 'Las Vegas', 'NV', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (28, 'Company BB', 'Raghav', 'Amritansh', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 28th Street', 'Memphis', 'TN', '99999', 'USA', NULL, NULL, '');
insert into customer (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (29, 'Company CC', 'Lee', 'Soo Jung', NULL, 'Purchasing Manager', '(123)555-0100', NULL, NULL, '(123)555-0101', '789 29th Street', 'Denver', 'CO', '99999', 'USA', NULL, NULL, '');
insert into employee_privileges (employee_id, privilege_id) values (2, 2);
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (1, 'Northwind Traders', 'Freehafer', 'Nancy', 'nancy@northwindtraders.com', 'Sales Representative', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 1st Avenue', 'Seattle', 'WA', '99999', 'USA', '#http://northwindtraders.com#', NULL, '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (2, 'Northwind Traders', 'Cencini', 'Andrew', 'andrew@northwindtraders.com', 'Vice President, Sales', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 2nd Avenue', 'Bellevue', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', 'Joined the company as a sales representative, was promoted to sales manager and was then named vice president of sales.', '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (3, 'Northwind Traders', 'Kotas', 'Jan', 'jan@northwindtraders.com', 'Sales Representative', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 3rd Avenue', 'Redmond', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', 'Was hired as a sales associate and was promoted to sales representative.', '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (4, 'Northwind Traders', 'Sergienko', 'Mariya', 'mariya@northwindtraders.com', 'Sales Representative', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 4th Avenue', 'Kirkland', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', NULL, '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (5, 'Northwind Traders', 'Thorpe', 'Steven', 'steven@northwindtraders.com', 'Sales Manager', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 5th Avenue', 'Seattle', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', 'Joined the company as a sales representative and was promoted to sales manager.  Fluent in French.', '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (6, 'Northwind Traders', 'Neipper', 'Michael', 'michael@northwindtraders.com', 'Sales Representative', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 6th Avenue', 'Redmond', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', 'Fluent in Japanese and can read and write French, Portuguese, and Spanish.', '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (7, 'Northwind Traders', 'Zare', 'Robert', 'robert@northwindtraders.com', 'Sales Representative', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 7th Avenue', 'Seattle', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', NULL, '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (8, 'Northwind Traders', 'Giussani', 'Laura', 'laura@northwindtraders.com', 'Sales Coordinator', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 8th Avenue', 'Redmond', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', 'Reads and writes French.', '');
insert into employees (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (9, 'Northwind Traders', 'Hellung-Larsen', 'Anne', 'anne@northwindtraders.com', 'Sales Representative', '(123)555-0100', '(123)555-0102', NULL, '(123)555-0103', '123 9th Avenue', 'Seattle', 'WA', '99999', 'USA', 'http://northwindtraders.com#http://northwindtraders.com/#', 'Fluent in French and German.', '');
insert into inventory_transaction_types (id, type_name) values (1, 'Purchased');
insert into inventory_transaction_types (id, type_name) values (2, 'Sold');
insert into inventory_transaction_types (id, type_name) values (3, 'On Hold');
insert into inventory_transaction_types (id, type_name) values (4, 'Waste');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (35, 1, '2006-03-22 16:02:28', '2006-03-22 16:02:28', 80, 75, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (36, 1, '2006-03-22 16:02:48', '2006-03-22 16:02:48', 72, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (37, 1, '2006-03-22 16:03:04', '2006-03-22 16:03:04', 52, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (38, 1, '2006-03-22 16:03:09', '2006-03-22 16:03:09', 56, 120, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (39, 1, '2006-03-22 16:03:14', '2006-03-22 16:03:14', 57, 80, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (40, 1, '2006-03-22 16:03:40', '2006-03-22 16:03:40', 6, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (41, 1, '2006-03-22 16:03:47', '2006-03-22 16:03:47', 7, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (42, 1, '2006-03-22 16:03:54', '2006-03-22 16:03:54', 8, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (43, 1, '2006-03-22 16:04:02', '2006-03-22 16:04:02', 14, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (44, 1, '2006-03-22 16:04:07', '2006-03-22 16:04:07', 17, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (45, 1, '2006-03-22 16:04:12', '2006-03-22 16:04:12', 19, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (46, 1, '2006-03-22 16:04:17', '2006-03-22 16:04:17', 20, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (47, 1, '2006-03-22 16:04:20', '2006-03-22 16:04:20', 21, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (48, 1, '2006-03-22 16:04:24', '2006-03-22 16:04:24', 40, 120, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (49, 1, '2006-03-22 16:04:28', '2006-03-22 16:04:28', 41, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (50, 1, '2006-03-22 16:04:31', '2006-03-22 16:04:31', 48, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (51, 1, '2006-03-22 16:04:38', '2006-03-22 16:04:38', 51, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (52, 1, '2006-03-22 16:04:41', '2006-03-22 16:04:41', 74, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (53, 1, '2006-03-22 16:04:45', '2006-03-22 16:04:45', 77, 60, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (54, 1, '2006-03-22 16:05:07', '2006-03-22 16:05:07', 3, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (55, 1, '2006-03-22 16:05:11', '2006-03-22 16:05:11', 4, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (56, 1, '2006-03-22 16:05:14', '2006-03-22 16:05:14', 5, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (57, 1, '2006-03-22 16:05:26', '2006-03-22 16:05:26', 65, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (58, 1, '2006-03-22 16:05:32', '2006-03-22 16:05:32', 66, 80, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (59, 1, '2006-03-22 16:05:47', '2006-03-22 16:05:47', 1, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (60, 1, '2006-03-22 16:05:51', '2006-03-22 16:05:51', 34, 60, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (61, 1, '2006-03-22 16:06:00', '2006-03-22 16:06:00', 43, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (62, 1, '2006-03-22 16:06:03', '2006-03-22 16:06:03', 81, 125, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (63, 2, '2006-03-22 16:07:56', '2006-03-24 11:03:00', 80, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (64, 2, '2006-03-22 16:08:19', '2006-03-22 16:08:59', 7, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (65, 2, '2006-03-22 16:08:29', '2006-03-22 16:08:59', 51, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (66, 2, '2006-03-22 16:08:37', '2006-03-22 16:08:59', 80, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (67, 2, '2006-03-22 16:09:46', '2006-03-22 16:10:27', 1, 15, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (68, 2, '2006-03-22 16:10:06', '2006-03-22 16:10:27', 43, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (69, 2, '2006-03-22 16:11:39', '2006-03-24 11:00:55', 19, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (70, 2, '2006-03-22 16:11:56', '2006-03-24 10:59:41', 48, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (71, 2, '2006-03-22 16:12:29', '2006-03-24 10:57:38', 8, 17, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (72, 1, '2006-03-24 10:41:30', '2006-03-24 10:41:30', 81, 200, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (73, 2, '2006-03-24 10:41:33', '2006-03-24 10:41:42', 81, 200, NULL, NULL, 'Fill Back Ordered product, Order #40');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (74, 1, '2006-03-24 10:53:13', '2006-03-24 10:53:13', 48, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (75, 2, '2006-03-24 10:53:16', '2006-03-24 10:55:46', 48, 100, NULL, NULL, 'Fill Back Ordered product, Order #39');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (76, 1, '2006-03-24 10:53:36', '2006-03-24 10:53:36', 43, 300, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (77, 2, '2006-03-24 10:53:39', '2006-03-24 10:56:57', 43, 300, NULL, NULL, 'Fill Back Ordered product, Order #38');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (78, 1, '2006-03-24 10:54:04', '2006-03-24 10:54:04', 41, 200, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (79, 2, '2006-03-24 10:54:07', '2006-03-24 10:58:40', 41, 200, NULL, NULL, 'Fill Back Ordered product, Order #36');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (80, 1, '2006-03-24 10:54:33', '2006-03-24 10:54:33', 19, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (81, 2, '2006-03-24 10:54:35', '2006-03-24 11:02:02', 19, 30, NULL, NULL, 'Fill Back Ordered product, Order #33');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (82, 1, '2006-03-24 10:54:58', '2006-03-24 10:54:58', 34, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (83, 2, '2006-03-24 10:55:02', '2006-03-24 11:03:00', 34, 100, NULL, NULL, 'Fill Back Ordered product, Order #30');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (84, 2, '2006-03-24 14:48:15', '2006-04-04 11:41:14', 6, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (85, 2, '2006-03-24 14:48:23', '2006-04-04 11:41:14', 4, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (86, 3, '2006-03-24 14:49:16', '2006-03-24 14:49:16', 80, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (87, 3, '2006-03-24 14:49:20', '2006-03-24 14:49:20', 81, 50, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (88, 3, '2006-03-24 14:50:09', '2006-03-24 14:50:09', 1, 25, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (89, 3, '2006-03-24 14:50:14', '2006-03-24 14:50:14', 43, 25, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (90, 3, '2006-03-24 14:50:18', '2006-03-24 14:50:18', 81, 25, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (91, 2, '2006-03-24 14:51:03', '2006-04-04 11:09:24', 40, 50, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (92, 2, '2006-03-24 14:55:03', '2006-04-04 11:06:56', 21, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (93, 2, '2006-03-24 14:55:39', '2006-04-04 11:06:13', 5, 25, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (94, 2, '2006-03-24 14:55:52', '2006-04-04 11:06:13', 41, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (95, 2, '2006-03-24 14:56:09', '2006-04-04 11:06:13', 40, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (96, 3, '2006-03-30 16:46:34', '2006-03-30 16:46:34', 34, 12, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (97, 3, '2006-03-30 17:23:27', '2006-03-30 17:23:27', 34, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (98, 3, '2006-03-30 17:24:33', '2006-03-30 17:24:33', 34, 1, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (99, 2, '2006-04-03 13:50:08', '2006-04-03 13:50:15', 48, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (100, 1, '2006-04-04 11:00:54', '2006-04-04 11:00:54', 57, 100, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (101, 2, '2006-04-04 11:00:56', '2006-04-04 11:08:49', 57, 100, NULL, NULL, 'Fill Back Ordered product, Order #46');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (102, 1, '2006-04-04 11:01:14', '2006-04-04 11:01:14', 34, 50, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (103, 1, '2006-04-04 11:01:35', '2006-04-04 11:01:35', 43, 250, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (104, 3, '2006-04-04 11:01:37', '2006-04-04 11:01:37', 43, 300, NULL, NULL, 'Fill Back Ordered product, Order #41');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (105, 1, '2006-04-04 11:01:55', '2006-04-04 11:01:55', 8, 25, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (106, 2, '2006-04-04 11:01:58', '2006-04-04 11:07:37', 8, 25, NULL, NULL, 'Fill Back Ordered product, Order #48');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (107, 1, '2006-04-04 11:02:17', '2006-04-04 11:02:17', 34, 300, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (108, 2, '2006-04-04 11:02:19', '2006-04-04 11:08:14', 34, 300, NULL, NULL, 'Fill Back Ordered product, Order #47');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (109, 1, '2006-04-04 11:02:37', '2006-04-04 11:02:37', 19, 25, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (110, 2, '2006-04-04 11:02:39', '2006-04-04 11:41:14', 19, 10, NULL, NULL, 'Fill Back Ordered product, Order #42');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (111, 1, '2006-04-04 11:02:56', '2006-04-04 11:02:56', 19, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (112, 2, '2006-04-04 11:02:58', '2006-04-04 11:07:37', 19, 25, NULL, NULL, 'Fill Back Ordered product, Order #48');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (113, 1, '2006-04-04 11:03:12', '2006-04-04 11:03:12', 72, 50, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (114, 2, '2006-04-04 11:03:14', '2006-04-04 11:08:49', 72, 50, NULL, NULL, 'Fill Back Ordered product, Order #46');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (115, 1, '2006-04-04 11:03:38', '2006-04-04 11:03:38', 41, 50, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (116, 2, '2006-04-04 11:03:39', '2006-04-04 11:09:24', 41, 50, NULL, NULL, 'Fill Back Ordered product, Order #45');
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (117, 2, '2006-04-04 11:04:55', '2006-04-04 11:05:04', 34, 87, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (118, 2, '2006-04-04 11:35:50', '2006-04-04 11:35:54', 51, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (119, 2, '2006-04-04 11:35:51', '2006-04-04 11:35:54', 7, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (120, 2, '2006-04-04 11:36:15', '2006-04-04 11:36:21', 17, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (121, 2, '2006-04-04 11:36:39', '2006-04-04 11:36:47', 6, 90, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (122, 2, '2006-04-04 11:37:06', '2006-04-04 11:37:09', 4, 30, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (123, 2, '2006-04-04 11:37:45', '2006-04-04 11:37:49', 48, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (124, 2, '2006-04-04 11:38:07', '2006-04-04 11:38:11', 48, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (125, 2, '2006-04-04 11:38:27', '2006-04-04 11:38:32', 41, 10, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (126, 2, '2006-04-04 11:38:48', '2006-04-04 11:38:53', 43, 5, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (127, 2, '2006-04-04 11:39:12', '2006-04-04 11:39:29', 40, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (128, 2, '2006-04-04 11:39:50', '2006-04-04 11:39:53', 8, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (129, 2, '2006-04-04 11:40:13', '2006-04-04 11:40:16', 80, 15, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (130, 2, '2006-04-04 11:40:32', '2006-04-04 11:40:38', 74, 20, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (131, 2, '2006-04-04 11:41:39', '2006-04-04 11:41:45', 72, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (132, 2, '2006-04-04 11:42:17', '2006-04-04 11:42:26', 3, 50, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (133, 2, '2006-04-04 11:42:24', '2006-04-04 11:42:26', 8, 3, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (134, 2, '2006-04-04 11:42:48', '2006-04-04 11:43:08', 20, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (135, 2, '2006-04-04 11:43:05', '2006-04-04 11:43:08', 52, 40, NULL, NULL, NULL);
insert into inventory_transactions (id, transaction_type, transaction_created_date, transaction_modified_date, product_id, quantity, purchase_order_id, customer_order_id, comments) values (136, 3, '2006-04-25 17:04:05', '2006-04-25 17:04:57', 56, 110, NULL, NULL, NULL);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (5, 31, '2006-03-22 16:08:59', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (6, 32, '2006-03-22 16:10:27', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (7, 40, '2006-03-24 10:41:41', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (8, 39, '2006-03-24 10:55:46', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (9, 38, '2006-03-24 10:56:57', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (10, 37, '2006-03-24 10:57:38', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (11, 36, '2006-03-24 10:58:40', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (12, 35, '2006-03-24 10:59:41', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (13, 34, '2006-03-24 11:00:55', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (14, 33, '2006-03-24 11:02:02', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (15, 30, '2006-03-24 11:03:00', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (16, 56, '2006-04-03 13:50:15', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (17, 55, '2006-04-04 11:05:04', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (18, 51, '2006-04-04 11:06:13', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (19, 50, '2006-04-04 11:06:56', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (20, 48, '2006-04-04 11:07:37', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (21, 47, '2006-04-04 11:08:14', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (22, 46, '2006-04-04 11:08:49', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (23, 45, '2006-04-04 11:09:24', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (24, 79, '2006-04-04 11:35:54', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (25, 78, '2006-04-04 11:36:21', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (26, 77, '2006-04-04 11:36:47', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (27, 76, '2006-04-04 11:37:09', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (28, 75, '2006-04-04 11:37:49', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (29, 74, '2006-04-04 11:38:11', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (30, 73, '2006-04-04 11:38:32', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (31, 72, '2006-04-04 11:38:53', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (32, 71, '2006-04-04 11:39:29', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (33, 70, '2006-04-04 11:39:53', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (34, 69, '2006-04-04 11:40:16', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (35, 67, '2006-04-04 11:40:38', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (36, 42, '2006-04-04 11:41:14', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (37, 60, '2006-04-04 11:41:45', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (38, 63, '2006-04-04 11:42:26', NULL, 0, 0, 0);
insert into invoices (id, order_id, invoice_date, due_date, tax, shipping, amount_due) values (39, 58, '2006-04-04 11:43:08', NULL, 0, 0, 0);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (27, 30, 34, 100, 14, 0, 2, NULL, 96, 83);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (28, 30, 80, 30, 3.5, 0, 2, NULL, NULL, 63);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (29, 31, 7, 10, 30, 0, 2, NULL, NULL, 64);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (30, 31, 51, 10, 53, 0, 2, NULL, NULL, 65);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (31, 31, 80, 10, 3.5, 0, 2, NULL, NULL, 66);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (32, 32, 1, 15, 18, 0, 2, NULL, NULL, 67);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (33, 32, 43, 20, 46, 0, 2, NULL, NULL, 68);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (34, 33, 19, 30, 9.2, 0, 2, NULL, 97, 81);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (35, 34, 19, 20, 9.2, 0, 2, NULL, NULL, 69);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (36, 35, 48, 10, 12.75, 0, 2, NULL, NULL, 70);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (37, 36, 41, 200, 9.65, 0, 2, NULL, 98, 79);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (38, 37, 8, 17, 40, 0, 2, NULL, NULL, 71);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (39, 38, 43, 300, 46, 0, 2, NULL, 99, 77);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (40, 39, 48, 100, 12.75, 0, 2, NULL, 100, 75);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (41, 40, 81, 200, 2.99, 0, 2, NULL, 101, 73);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (42, 41, 43, 300, 46, 0, 1, NULL, 102, 104);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (43, 42, 6, 10, 25, 0, 2, NULL, NULL, 84);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (44, 42, 4, 10, 22, 0, 2, NULL, NULL, 85);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (45, 42, 19, 10, 9.2, 0, 2, NULL, 103, 110);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (46, 43, 80, 20, 3.5, 0, 1, NULL, NULL, 86);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (47, 43, 81, 50, 2.99, 0, 1, NULL, NULL, 87);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (48, 44, 1, 25, 18, 0, 1, NULL, NULL, 88);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (49, 44, 43, 25, 46, 0, 1, NULL, NULL, 89);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (50, 44, 81, 25, 2.99, 0, 1, NULL, NULL, 90);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (51, 45, 41, 50, 9.65, 0, 2, NULL, 104, 116);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (52, 45, 40, 50, 18.4, 0, 2, NULL, NULL, 91);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (53, 46, 57, 100, 19.5, 0, 2, NULL, 105, 101);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (54, 46, 72, 50, 34.8, 0, 2, NULL, 106, 114);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (55, 47, 34, 300, 14, 0, 2, NULL, 107, 108);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (56, 48, 8, 25, 40, 0, 2, NULL, 108, 106);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (57, 48, 19, 25, 9.2, 0, 2, NULL, 109, 112);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (59, 50, 21, 20, 10, 0, 2, NULL, NULL, 92);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (60, 51, 5, 25, 21.35, 0, 2, NULL, NULL, 93);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (61, 51, 41, 30, 9.65, 0, 2, NULL, NULL, 94);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (62, 51, 40, 30, 18.4, 0, 2, NULL, NULL, 95);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (66, 56, 48, 10, 12.75, 0, 2, NULL, 111, 99);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (67, 55, 34, 87, 14, 0, 2, NULL, NULL, 117);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (68, 79, 7, 30, 30, 0, 2, NULL, NULL, 119);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (69, 79, 51, 30, 53, 0, 2, NULL, NULL, 118);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (70, 78, 17, 40, 39, 0, 2, NULL, NULL, 120);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (71, 77, 6, 90, 25, 0, 2, NULL, NULL, 121);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (72, 76, 4, 30, 22, 0, 2, NULL, NULL, 122);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (73, 75, 48, 40, 12.75, 0, 2, NULL, NULL, 123);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (74, 74, 48, 40, 12.75, 0, 2, NULL, NULL, 124);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (75, 73, 41, 10, 9.65, 0, 2, NULL, NULL, 125);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (76, 72, 43, 5, 46, 0, 2, NULL, NULL, 126);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (77, 71, 40, 40, 18.4, 0, 2, NULL, NULL, 127);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (78, 70, 8, 20, 40, 0, 2, NULL, NULL, 128);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (79, 69, 80, 15, 3.5, 0, 2, NULL, NULL, 129);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (80, 67, 74, 20, 10, 0, 2, NULL, NULL, 130);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (81, 60, 72, 40, 34.8, 0, 2, NULL, NULL, 131);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (82, 63, 3, 50, 10, 0, 2, NULL, NULL, 132);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (83, 63, 8, 3, 40, 0, 2, NULL, NULL, 133);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (84, 58, 20, 40, 81, 0, 2, NULL, NULL, 134);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (85, 58, 52, 40, 7, 0, 2, NULL, NULL, 135);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (86, 80, 56, 10, 38, 0, 1, NULL, NULL, 136);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (90, 81, 81, 0, 2.99, 0, 5, NULL, NULL, NULL);
insert into order_details (id, order_id, product_id, quantity, unit_price, discount, status_id, date_allocated, purchase_order_id, inventory_id) values (91, 81, 56, 0, 38, 0, 0, NULL, NULL, NULL);
insert into order_details_status (id, status_name) values (0, 'None');
insert into order_details_status (id, status_name) values (1, 'Allocated');
insert into order_details_status (id, status_name) values (2, 'Invoiced');
insert into order_details_status (id, status_name) values (3, 'Shipped');
insert into order_details_status (id, status_name) values (4, 'On Order');
insert into order_details_status (id, status_name) values (5, 'No Stock');
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (30, 9, 27, '2006-01-15 00:00:00', '2006-01-22 00:00:00', 2, 'Karen Toh', '789 27th Street', 'Las Vegas', 'NV', '99999', 'USA', 200, 0, 'Check', '2006-01-15 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (31, 3, 4, '2006-01-20 00:00:00', '2006-01-22 00:00:00', 1, 'Christina Lee', '123 4th Street', 'New York', 'NY', '99999', 'USA', 5, 0, 'Credit Card', '2006-01-20 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (32, 4, 12, '2006-01-22 00:00:00', '2006-01-22 00:00:00', 2, 'John Edwards', '123 12th Street', 'Las Vegas', 'NV', '99999', 'USA', 5, 0, 'Credit Card', '2006-01-22 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (33, 6, 8, '2006-01-30 00:00:00', '2006-01-31 00:00:00', 3, 'Elizabeth Andersen', '123 8th Street', 'Portland', 'OR', '99999', 'USA', 50, 0, 'Credit Card', '2006-01-30 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (34, 9, 4, '2006-02-06 00:00:00', '2006-02-07 00:00:00', 3, 'Christina Lee', '123 4th Street', 'New York', 'NY', '99999', 'USA', 4, 0, 'Check', '2006-02-06 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (35, 3, 29, '2006-02-10 00:00:00', '2006-02-12 00:00:00', 2, 'Soo Jung Lee', '789 29th Street', 'Denver', 'CO', '99999', 'USA', 7, 0, 'Check', '2006-02-10 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (36, 4, 3, '2006-02-23 00:00:00', '2006-02-25 00:00:00', 2, 'Thomas Axen', '123 3rd Street', 'Los Angelas', 'CA', '99999', 'USA', 7, 0, 'Cash', '2006-02-23 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (37, 8, 6, '2006-03-06 00:00:00', '2006-03-09 00:00:00', 2, 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', 12, 0, 'Credit Card', '2006-03-06 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (38, 9, 28, '2006-03-10 00:00:00', '2006-03-11 00:00:00', 3, 'Amritansh Raghav', '789 28th Street', 'Memphis', 'TN', '99999', 'USA', 10, 0, 'Check', '2006-03-10 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (39, 3, 8, '2006-03-22 00:00:00', '2006-03-24 00:00:00', 3, 'Elizabeth Andersen', '123 8th Street', 'Portland', 'OR', '99999', 'USA', 5, 0, 'Check', '2006-03-22 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (40, 4, 10, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, 'Roland Wacker', '123 10th Street', 'Chicago', 'IL', '99999', 'USA', 9, 0, 'Credit Card', '2006-03-24 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (41, 1, 7, '2006-03-24 00:00:00', NULL, NULL, 'Ming-Yang Xie', '123 7th Street', 'Boise', 'ID', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (42, 1, 10, '2006-03-24 00:00:00', '2006-04-07 00:00:00', 1, 'Roland Wacker', '123 10th Street', 'Chicago', 'IL', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 2);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (43, 1, 11, '2006-03-24 00:00:00', NULL, 3, 'Peter Krschne', '123 11th Street', 'Miami', 'FL', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (44, 1, 1, '2006-03-24 00:00:00', NULL, NULL, 'Anna Bedecs', '123 1st Street', 'Seattle', 'WA', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (45, 1, 28, '2006-04-07 00:00:00', '2006-04-07 00:00:00', 3, 'Amritansh Raghav', '789 28th Street', 'Memphis', 'TN', '99999', 'USA', 40, 0, 'Credit Card', '2006-04-07 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (46, 7, 9, '2006-04-05 00:00:00', '2006-04-05 00:00:00', 1, 'Sven Mortensen', '123 9th Street', 'Salt Lake City', 'UT', '99999', 'USA', 100, 0, 'Check', '2006-04-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (47, 6, 6, '2006-04-08 00:00:00', '2006-04-08 00:00:00', 2, 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', 300, 0, 'Credit Card', '2006-04-08 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (48, 4, 8, '2006-04-05 00:00:00', '2006-04-05 00:00:00', 2, 'Elizabeth Andersen', '123 8th Street', 'Portland', 'OR', '99999', 'USA', 50, 0, 'Check', '2006-04-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (50, 9, 25, '2006-04-05 00:00:00', '2006-04-05 00:00:00', 1, 'John Rodman', '789 25th Street', 'Chicago', 'IL', '99999', 'USA', 5, 0, 'Cash', '2006-04-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (51, 9, 26, '2006-04-05 00:00:00', '2006-04-05 00:00:00', 3, 'Run Liu', '789 26th Street', 'Miami', 'FL', '99999', 'USA', 60, 0, 'Credit Card', '2006-04-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (55, 1, 29, '2006-04-05 00:00:00', '2006-04-05 00:00:00', 2, 'Soo Jung Lee', '789 29th Street', 'Denver', 'CO', '99999', 'USA', 200, 0, 'Check', '2006-04-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (56, 2, 6, '2006-04-03 00:00:00', '2006-04-03 00:00:00', 3, 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', 0, 0, 'Check', '2006-04-03 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (57, 9, 27, '2006-04-22 00:00:00', '2006-04-22 00:00:00', 2, 'Karen Toh', '789 27th Street', 'Las Vegas', 'NV', '99999', 'USA', 200, 0, 'Check', '2006-04-22 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (58, 3, 4, '2006-04-22 00:00:00', '2006-04-22 00:00:00', 1, 'Christina Lee', '123 4th Street', 'New York', 'NY', '99999', 'USA', 5, 0, 'Credit Card', '2006-04-22 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (59, 4, 12, '2006-04-22 00:00:00', '2006-04-22 00:00:00', 2, 'John Edwards', '123 12th Street', 'Las Vegas', 'NV', '99999', 'USA', 5, 0, 'Credit Card', '2006-04-22 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (60, 6, 8, '2006-04-30 00:00:00', '2006-04-30 00:00:00', 3, 'Elizabeth Andersen', '123 8th Street', 'Portland', 'OR', '99999', 'USA', 50, 0, 'Credit Card', '2006-04-30 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (61, 9, 4, '2006-04-07 00:00:00', '2006-04-07 00:00:00', 3, 'Christina Lee', '123 4th Street', 'New York', 'NY', '99999', 'USA', 4, 0, 'Check', '2006-04-07 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (62, 3, 29, '2006-04-12 00:00:00', '2006-04-12 00:00:00', 2, 'Soo Jung Lee', '789 29th Street', 'Denver', 'CO', '99999', 'USA', 7, 0, 'Check', '2006-04-12 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (63, 4, 3, '2006-04-25 00:00:00', '2006-04-25 00:00:00', 2, 'Thomas Axen', '123 3rd Street', 'Los Angelas', 'CA', '99999', 'USA', 7, 0, 'Cash', '2006-04-25 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (64, 8, 6, '2006-05-09 00:00:00', '2006-05-09 00:00:00', 2, 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', 12, 0, 'Credit Card', '2006-05-09 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (65, 9, 28, '2006-05-11 00:00:00', '2006-05-11 00:00:00', 3, 'Amritansh Raghav', '789 28th Street', 'Memphis', 'TN', '99999', 'USA', 10, 0, 'Check', '2006-05-11 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (66, 3, 8, '2006-05-24 00:00:00', '2006-05-24 00:00:00', 3, 'Elizabeth Andersen', '123 8th Street', 'Portland', 'OR', '99999', 'USA', 5, 0, 'Check', '2006-05-24 00:00:00', NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (67, 4, 10, '2006-05-24 00:00:00', '2006-05-24 00:00:00', 2, 'Roland Wacker', '123 10th Street', 'Chicago', 'IL', '99999', 'USA', 9, 0, 'Credit Card', '2006-05-24 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (68, 1, 7, '2006-05-24 00:00:00', NULL, NULL, 'Ming-Yang Xie', '123 7th Street', 'Boise', 'ID', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (69, 1, 10, '2006-05-24 00:00:00', NULL, 1, 'Roland Wacker', '123 10th Street', 'Chicago', 'IL', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (70, 1, 11, '2006-05-24 00:00:00', NULL, 3, 'Peter Krschne', '123 11th Street', 'Miami', 'FL', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (71, 1, 1, '2006-05-24 00:00:00', NULL, 3, 'Anna Bedecs', '123 1st Street', 'Seattle', 'WA', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (72, 1, 28, '2006-06-07 00:00:00', '2006-06-07 00:00:00', 3, 'Amritansh Raghav', '789 28th Street', 'Memphis', 'TN', '99999', 'USA', 40, 0, 'Credit Card', '2006-06-07 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (73, 7, 9, '2006-06-05 00:00:00', '2006-06-05 00:00:00', 1, 'Sven Mortensen', '123 9th Street', 'Salt Lake City', 'UT', '99999', 'USA', 100, 0, 'Check', '2006-06-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (74, 6, 6, '2006-06-08 00:00:00', '2006-06-08 00:00:00', 2, 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', 300, 0, 'Credit Card', '2006-06-08 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (75, 4, 8, '2006-06-05 00:00:00', '2006-06-05 00:00:00', 2, 'Elizabeth Andersen', '123 8th Street', 'Portland', 'OR', '99999', 'USA', 50, 0, 'Check', '2006-06-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (76, 9, 25, '2006-06-05 00:00:00', '2006-06-05 00:00:00', 1, 'John Rodman', '789 25th Street', 'Chicago', 'IL', '99999', 'USA', 5, 0, 'Cash', '2006-06-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (77, 9, 26, '2006-06-05 00:00:00', '2006-06-05 00:00:00', 3, 'Run Liu', '789 26th Street', 'Miami', 'FL', '99999', 'USA', 60, 0, 'Credit Card', '2006-06-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (78, 1, 29, '2006-06-05 00:00:00', '2006-06-05 00:00:00', 2, 'Soo Jung Lee', '789 29th Street', 'Denver', 'CO', '99999', 'USA', 200, 0, 'Check', '2006-06-05 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (79, 2, 6, '2006-06-23 00:00:00', '2006-06-23 00:00:00', 3, 'Francisco Pérez-Olaeta', '123 6th Street', 'Milwaukee', 'WI', '99999', 'USA', 0, 0, 'Check', '2006-06-23 00:00:00', NULL, 0, NULL, 3);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (80, 2, 4, '2006-04-25 17:03:55', NULL, NULL, 'Christina Lee', '123 4th Street', 'New York', 'NY', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders (id, employee_id, customer_id, order_date, shipped_date, shipper_id, ship_name, ship_address, ship_city, ship_state_province, ship_zip_postal_code, ship_country_region, shipping_fee, taxes, payment_type, paid_date, notes, tax_rate, tax_status_id, status_id) values (81, 2, 3, '2006-04-25 17:26:53', NULL, NULL, 'Thomas Axen', '123 3rd Street', 'Los Angelas', 'CA', '99999', 'USA', 0, 0, NULL, NULL, NULL, 0, NULL, 0);
insert into orders_status (id, status_name) values (0, 'New');
insert into orders_status (id, status_name) values (1, 'Invoiced');
insert into orders_status (id, status_name) values (2, 'Shipped');
insert into orders_status (id, status_name) values (3, 'Closed');
insert into orders_tax_status (id, tax_status_name) values (0, 'Tax Exempt');
insert into orders_tax_status (id, tax_status_name) values (1, 'Taxable');
insert into privileges (id, privilege_name) values (2, 'Purchase Approvals');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('4', 1, 'NWTB-1', 'Northwind Traders Chai', NULL, 13.5, 18, 10, 40, '10 boxes x 20 bags', 0, 10, 'Beverages', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('10', 3, 'NWTCO-3', 'Northwind Traders Syrup', NULL, 7.5, 10, 25, 100, '12 - 550 ml bottles', 0, 25, 'Condiments', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('10', 4, 'NWTCO-4', 'Northwind Traders Cajun Seasoning', NULL, 16.5, 22, 10, 40, '48 - 6 oz jars', 0, 10, 'Condiments', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('10', 5, 'NWTO-5', 'Northwind Traders Olive Oil', NULL, 16.0125, 21.35, 10, 40, '36 boxes', 0, 10, 'Oil', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2;6', 6, 'NWTJP-6', 'Northwind Traders Boysenberry Spread', NULL, 18.75, 25, 25, 100, '12 - 8 oz jars', 0, 25, 'Jams, Preserves', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2', 7, 'NWTDFN-7', 'Northwind Traders Dried Pears', NULL, 22.5, 30, 10, 40, '12 - 1 lb pkgs.', 0, 10, 'Dried Fruit & Nuts', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('8', 8, 'NWTS-8', 'Northwind Traders Curry Sauce', NULL, 30, 40, 10, 40, '12 - 12 oz jars', 0, 10, 'Sauces', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2;6', 14, 'NWTDFN-14', 'Northwind Traders Walnuts', NULL, 17.4375, 23.25, 10, 40, '40 - 100 g pkgs.', 0, 10, 'Dried Fruit & Nuts', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 17, 'NWTCFV-17', 'Northwind Traders Fruit Cocktail', NULL, 29.25, 39, 10, 40, '15.25 OZ', 0, 10, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 19, 'NWTBGM-19', 'Northwind Traders Chocolate Biscuits Mix', NULL, 6.9, 9.2, 5, 20, '10 boxes x 12 pieces', 0, 5, 'Baked Goods & Mixes', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2;6', 20, 'NWTJP-6', 'Northwind Traders Marmalade', NULL, 60.75, 81, 10, 40, '30 gift boxes', 0, 10, 'Jams, Preserves', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 21, 'NWTBGM-21', 'Northwind Traders Scones', NULL, 7.5, 10, 5, 20, '24 pkgs. x 4 pieces', 0, 5, 'Baked Goods & Mixes', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('4', 34, 'NWTB-34', 'Northwind Traders Beer', NULL, 10.5, 14, 15, 60, '24 - 12 oz bottles', 0, 15, 'Beverages', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('7', 40, 'NWTCM-40', 'Northwind Traders Crab Meat', NULL, 13.8, 18.4, 30, 120, '24 - 4 oz tins', 0, 30, 'Canned Meat', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 41, 'NWTSO-41', 'Northwind Traders Clam Chowder', NULL, 7.2375, 9.65, 10, 40, '12 - 12 oz cans', 0, 10, 'Soups', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('3;4', 43, 'NWTB-43', 'Northwind Traders Coffee', NULL, 34.5, 46, 25, 100, '16 - 500 g tins', 0, 25, 'Beverages', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('10', 48, 'NWTCA-48', 'Northwind Traders Chocolate', NULL, 9.5625, 12.75, 25, 100, '10 pkgs', 0, 25, 'Candy', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2', 51, 'NWTDFN-51', 'Northwind Traders Dried Apples', NULL, 39.75, 53, 10, 40, '50 - 300 g pkgs.', 0, 10, 'Dried Fruit & Nuts', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 52, 'NWTG-52', 'Northwind Traders Long Grain Rice', NULL, 5.25, 7, 25, 100, '16 - 2 kg boxes', 0, 25, 'Grains', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 56, 'NWTP-56', 'Northwind Traders Gnocchi', NULL, 28.5, 38, 30, 120, '24 - 250 g pkgs.', 0, 30, 'Pasta', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 57, 'NWTP-57', 'Northwind Traders Ravioli', NULL, 14.625, 19.5, 20, 80, '24 - 250 g pkgs.', 0, 20, 'Pasta', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('8', 65, 'NWTS-65', 'Northwind Traders Hot Pepper Sauce', NULL, 15.7875, 21.05, 10, 40, '32 - 8 oz bottles', 0, 10, 'Sauces', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('8', 66, 'NWTS-66', 'Northwind Traders Tomato Sauce', NULL, 12.75, 17, 20, 80, '24 - 8 oz jars', 0, 20, 'Sauces', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('5', 72, 'NWTD-72', 'Northwind Traders Mozzarella', NULL, 26.1, 34.8, 10, 40, '24 - 200 g pkgs.', 0, 10, 'Dairy products', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2;6', 74, 'NWTDFN-74', 'Northwind Traders Almonds', NULL, 7.5, 10, 5, 20, '5 kg pkg.', 0, 5, 'Dried Fruit & Nuts', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('10', 77, 'NWTCO-77', 'Northwind Traders Mustard', NULL, 9.75, 13, 15, 60, '12 boxes', 0, 15, 'Condiments', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('2', 80, 'NWTDFN-80', 'Northwind Traders Dried Plums', NULL, 3, 3.5, 50, 75, '1 lb bag', 0, 25, 'Dried Fruit & Nuts', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('3', 81, 'NWTB-81', 'Northwind Traders Green Tea', NULL, 2, 2.99, 100, 125, '20 bags per box', 0, 25, 'Beverages', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 82, 'NWTC-82', 'Northwind Traders Granola', NULL, 2, 4, 20, 100, NULL, 0, NULL, 'Cereal', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('9', 83, 'NWTCS-83', 'Northwind Traders Potato Chips', NULL, .5, 1.8, 30, 200, NULL, 0, NULL, 'Chips, Snacks', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 85, 'NWTBGM-85', 'Northwind Traders Brownie Mix', NULL, 9, 12.49, 10, 20, '3 boxes', 0, 5, 'Baked Goods & Mixes', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 86, 'NWTBGM-86', 'Northwind Traders Cake Mix', NULL, 10.5, 15.99, 10, 20, '4 boxes', 0, 5, 'Baked Goods & Mixes', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('7', 87, 'NWTB-87', 'Northwind Traders Tea', NULL, 2, 4, 20, 50, '100 count per box', 0, NULL, 'Beverages', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 88, 'NWTCFV-88', 'Northwind Traders Pears', NULL, 1, 1.3, 10, 40, '15.25 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 89, 'NWTCFV-89', 'Northwind Traders Peaches', NULL, 1, 1.5, 10, 40, '15.25 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 90, 'NWTCFV-90', 'Northwind Traders Pineapple', NULL, 1, 1.8, 10, 40, '15.25 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 91, 'NWTCFV-91', 'Northwind Traders Cherry Pie Filling', NULL, 1, 2, 10, 40, '15.25 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 92, 'NWTCFV-92', 'Northwind Traders Green Beans', NULL, 1, 1.2, 10, 40, '14.5 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 93, 'NWTCFV-93', 'Northwind Traders Corn', NULL, 1, 1.2, 10, 40, '14.5 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 94, 'NWTCFV-94', 'Northwind Traders Peas', NULL, 1, 1.5, 10, 40, '14.5 OZ', 0, NULL, 'Canned Fruit & Vegetables', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('7', 95, 'NWTCM-95', 'Northwind Traders Tuna Fish', NULL, .5, 2, 30, 50, '5 oz', 0, NULL, 'Canned Meat', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('7', 96, 'NWTCM-96', 'Northwind Traders Smoked Salmon', NULL, 2, 4, 30, 50, '5 oz', 0, NULL, 'Canned Meat', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('1', 97, 'NWTC-82', 'Northwind Traders Hot Cereal', NULL, 3, 5, 50, 200, NULL, 0, NULL, 'Cereal', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 98, 'NWTSO-98', 'Northwind Traders Vegetable Soup', NULL, 1, 1.89, 100, 200, NULL, 0, NULL, 'Soups', '');
insert into products (supplier_ids, id, product_code, product_name, description, standard_cost, list_price, reorder_level, target_level, quantity_per_unit, discontinued, minimum_reorder_quantity, category, attachments) values ('6', 99, 'NWTSO-99', 'Northwind Traders Chicken Soup', NULL, 1, 1.95, 100, 200, NULL, 0, NULL, 'Soups', '');
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (238, 90, 1, 40, 14, '2006-01-22 00:00:00', 1, 59);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (239, 91, 3, 100, 8, '2006-01-22 00:00:00', 1, 54);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (240, 91, 4, 40, 16, '2006-01-22 00:00:00', 1, 55);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (241, 91, 5, 40, 16, '2006-01-22 00:00:00', 1, 56);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (242, 92, 6, 100, 19, '2006-01-22 00:00:00', 1, 40);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (243, 92, 7, 40, 22, '2006-01-22 00:00:00', 1, 41);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (244, 92, 8, 40, 30, '2006-01-22 00:00:00', 1, 42);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (245, 92, 14, 40, 17, '2006-01-22 00:00:00', 1, 43);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (246, 92, 17, 40, 29, '2006-01-22 00:00:00', 1, 44);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (247, 92, 19, 20, 7, '2006-01-22 00:00:00', 1, 45);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (248, 92, 20, 40, 61, '2006-01-22 00:00:00', 1, 46);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (249, 92, 21, 20, 8, '2006-01-22 00:00:00', 1, 47);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (250, 90, 34, 60, 10, '2006-01-22 00:00:00', 1, 60);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (251, 92, 40, 120, 14, '2006-01-22 00:00:00', 1, 48);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (252, 92, 41, 40, 7, '2006-01-22 00:00:00', 1, 49);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (253, 90, 43, 100, 34, '2006-01-22 00:00:00', 1, 61);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (254, 92, 48, 100, 10, '2006-01-22 00:00:00', 1, 50);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (255, 92, 51, 40, 40, '2006-01-22 00:00:00', 1, 51);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (256, 93, 52, 100, 5, '2006-01-22 00:00:00', 1, 37);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (257, 93, 56, 120, 28, '2006-01-22 00:00:00', 1, 38);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (258, 93, 57, 80, 15, '2006-01-22 00:00:00', 1, 39);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (259, 91, 65, 40, 16, '2006-01-22 00:00:00', 1, 57);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (260, 91, 66, 80, 13, '2006-01-22 00:00:00', 1, 58);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (261, 94, 72, 40, 26, '2006-01-22 00:00:00', 1, 36);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (262, 92, 74, 20, 8, '2006-01-22 00:00:00', 1, 52);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (263, 92, 77, 60, 10, '2006-01-22 00:00:00', 1, 53);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (264, 95, 80, 75, 3, '2006-01-22 00:00:00', 1, 35);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (265, 90, 81, 125, 2, '2006-01-22 00:00:00', 1, 62);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (266, 96, 34, 100, 10, '2006-01-22 00:00:00', 1, 82);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (267, 97, 19, 30, 7, '2006-01-22 00:00:00', 1, 80);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (268, 98, 41, 200, 7, '2006-01-22 00:00:00', 1, 78);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (269, 99, 43, 300, 34, '2006-01-22 00:00:00', 1, 76);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (270, 100, 48, 100, 10, '2006-01-22 00:00:00', 1, 74);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (271, 101, 81, 200, 2, '2006-01-22 00:00:00', 1, 72);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (272, 102, 43, 300, 34, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (273, 103, 19, 10, 7, '2006-04-17 00:00:00', 1, 111);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (274, 104, 41, 50, 7, '2006-04-06 00:00:00', 1, 115);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (275, 105, 57, 100, 15, '2006-04-05 00:00:00', 1, 100);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (276, 106, 72, 50, 26, '2006-04-05 00:00:00', 1, 113);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (277, 107, 34, 300, 10, '2006-04-05 00:00:00', 1, 107);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (278, 108, 8, 25, 30, '2006-04-05 00:00:00', 1, 105);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (279, 109, 19, 25, 7, '2006-04-05 00:00:00', 1, 109);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (280, 110, 43, 250, 34, '2006-04-10 00:00:00', 1, 103);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (281, 90, 1, 40, 14, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (282, 92, 19, 20, 7, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (283, 111, 34, 50, 10, '2006-04-04 00:00:00', 1, 102);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (285, 91, 3, 50, 8, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (286, 91, 4, 40, 16, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (288, 140, 85, 10, 9, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (289, 141, 6, 10, 18.75, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (290, 142, 1, 1, 13.5, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (292, 146, 20, 40, 60, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (293, 146, 51, 40, 39, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (294, 147, 40, 120, 13, NULL, 0, NULL);
insert into purchase_order_details (id, purchase_order_id, product_id, quantity, unit_cost, date_received, posted_to_inventory, inventory_id) values (295, 148, 72, 40, 26, NULL, 0, NULL);
insert into purchase_order_status (id, status) values (0, 'New');
insert into purchase_order_status (id, status) values (1, 'Submitted');
insert into purchase_order_status (id, status) values (2, 'Approved');
insert into purchase_order_status (id, status) values (3, 'Closed');
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (90, 1, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (91, 3, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (92, 2, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (93, 5, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (94, 6, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (95, 4, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (96, 1, 5, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #30', 2, '2006-01-22 00:00:00', 5);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (97, 2, 7, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #33', 2, '2006-01-22 00:00:00', 7);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (98, 2, 4, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #36', 2, '2006-01-22 00:00:00', 4);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (99, 1, 3, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #38', 2, '2006-01-22 00:00:00', 3);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (100, 2, 9, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #39', 2, '2006-01-22 00:00:00', 9);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (101, 1, 2, '2006-01-14 00:00:00', '2006-01-22 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #40', 2, '2006-01-22 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (102, 1, 1, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #41', 2, '2006-04-04 00:00:00', 1);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (103, 2, 1, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #42', 2, '2006-04-04 00:00:00', 1);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (104, 2, 1, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #45', 2, '2006-04-04 00:00:00', 1);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (105, 5, 7, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, 'Check', 'Purchase generated based on Order #46', 2, '2006-04-04 00:00:00', 7);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (106, 6, 7, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #46', 2, '2006-04-04 00:00:00', 7);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (107, 1, 6, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #47', 2, '2006-04-04 00:00:00', 6);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (108, 2, 4, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #48', 2, '2006-04-04 00:00:00', 4);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (109, 2, 4, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #48', 2, '2006-04-04 00:00:00', 4);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (110, 1, 3, '2006-03-24 00:00:00', '2006-03-24 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #49', 2, '2006-04-04 00:00:00', 3);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (111, 1, 2, '2006-03-31 00:00:00', '2006-03-31 00:00:00', 2, NULL, 0, 0, NULL, 0, NULL, 'Purchase generated based on Order #56', 2, '2006-04-04 00:00:00', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (140, 6, NULL, '2006-04-25 00:00:00', '2006-04-25 16:40:51', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-04-25 16:41:33', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (141, 8, NULL, '2006-04-25 00:00:00', '2006-04-25 17:10:35', 2, NULL, 0, 0, NULL, 0, NULL, NULL, 2, '2006-04-25 17:10:55', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (142, 8, NULL, '2006-04-25 00:00:00', '2006-04-25 17:18:29', 2, NULL, 0, 0, NULL, 0, 'Check', NULL, 2, '2006-04-25 17:18:51', 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (146, 2, 2, '2006-04-26 18:26:37', '2006-04-26 18:26:37', 1, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (147, 7, 2, '2006-04-26 18:33:28', '2006-04-26 18:33:28', 1, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, 2);
insert into purchase_orders (id, supplier_id, created_by, submitted_date, creation_date, status_id, expected_date, shipping_fee, taxes, payment_date, payment_amount, payment_method, notes, approved_by, approved_date, submitted_by) values (148, 5, 2, '2006-04-26 18:33:52', '2006-04-26 18:33:52', 1, NULL, 0, 0, NULL, 0, NULL, NULL, NULL, NULL, 2);
insert into sales_reports (group_by, display, title, filter_row_source, "default") values ('Category', 'Category', 'Sales By Category', 'SELECT DISTINCT [Category] FROM [products] ORDER BY [Category];', 0);
insert into sales_reports (group_by, display, title, filter_row_source, "default") values ('country_region', 'Country/Region', 'Sales By Country', 'SELECT DISTINCT [country_region] FROM [customers Extended] ORDER BY [country_region];', 0);
insert into sales_reports (group_by, display, title, filter_row_source, "default") values ('Customer ID', 'Customer', 'Sales By Customer', 'SELECT DISTINCT [Company] FROM [customers Extended] ORDER BY [Company];', 0);
insert into sales_reports (group_by, display, title, filter_row_source, "default") values ('employee_id', 'Employee', 'Sales By Employee', 'SELECT DISTINCT [Employee Name] FROM [employees Extended] ORDER BY [Employee Name];', 0);
insert into sales_reports (group_by, display, title, filter_row_source, "default") values ('Product ID', 'Product', 'Sales by Product', 'SELECT DISTINCT [Product Name] FROM [products] ORDER BY [Product Name];', 1);
insert into shippers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (1, 'Shipping Company A', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123 Any Street', 'Memphis', 'TN', '99999', 'USA', NULL, NULL, '');
insert into shippers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (2, 'Shipping Company B', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123 Any Street', 'Memphis', 'TN', '99999', 'USA', NULL, NULL, '');
insert into shippers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (3, 'Shipping Company C', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '123 Any Street', 'Memphis', 'TN', '99999', 'USA', NULL, NULL, '');
insert into strings (string_id, string_data) values (2, 'Northwind Traders');
insert into strings (string_id, string_data) values (3, 'Cannot remove posted inventory!');
insert into strings (string_id, string_data) values (4, 'Back ordered product filled for Order #|');
insert into strings (string_id, string_data) values (5, 'Discounted price below cost!');
insert into strings (string_id, string_data) values (6, 'Insufficient inventory.');
insert into strings (string_id, string_data) values (7, 'Insufficient inventory. Do you want to create a purchase order?');
insert into strings (string_id, string_data) values (8, 'Purchase orders were successfully created for | products');
insert into strings (string_id, string_data) values (9, 'There are no products below their respective reorder levels');
insert into strings (string_id, string_data) values (10, 'Must specify customer name!');
insert into strings (string_id, string_data) values (11, 'Restocking will generate purchase orders for all products below desired inventory levels.  Do you want to continue?');
insert into strings (string_id, string_data) values (12, 'Cannot create purchase order.  No suppliers listed for specified product');
insert into strings (string_id, string_data) values (13, 'Discounted price is below cost!');
insert into strings (string_id, string_data) values (14, 'Do you want to continue?');
insert into strings (string_id, string_data) values (15, 'Order is already invoiced. Do you want to print the invoice?');
insert into strings (string_id, string_data) values (16, 'Order does not contain any line items');
insert into strings (string_id, string_data) values (17, 'Cannot create invoice!  Inventory has not been allocated for each specified product.');
insert into strings (string_id, string_data) values (18, 'Sorry, there are no sales in the specified time period');
insert into strings (string_id, string_data) values (19, 'Product successfully restocked.');
insert into strings (string_id, string_data) values (21, 'Product does not need restocking! Product is already at desired inventory level.');
insert into strings (string_id, string_data) values (22, 'Product restocking failed!');
insert into strings (string_id, string_data) values (23, 'Invalid login specified!');
insert into strings (string_id, string_data) values (24, 'Must first select reported!');
insert into strings (string_id, string_data) values (25, 'Changing supplier will remove purchase line items, continue?');
insert into strings (string_id, string_data) values (26, 'Purchase orders were successfully submitted for | products.  Do you want to view the restocking report?');
insert into strings (string_id, string_data) values (27, 'There was an error attempting to restock inventory levels.');
insert into strings (string_id, string_data) values (28, '| product(s) were successfully restocked.  Do you want to view the restocking report?');
insert into strings (string_id, string_data) values (29, 'You cannot remove purchase line items already posted to inventory!');
insert into strings (string_id, string_data) values (30, 'There was an error removing one or more purchase line items.');
insert into strings (string_id, string_data) values (31, 'You cannot modify quantity for purchased product already received or posted to inventory.');
insert into strings (string_id, string_data) values (32, 'You cannot modify price for purchased product already received or posted to inventory.');
insert into strings (string_id, string_data) values (33, 'Product has been successfully posted to inventory.');
insert into strings (string_id, string_data) values (34, 'Sorry, product cannot be successfully posted to inventory.');
insert into strings (string_id, string_data) values (35, 'There are orders with this product on back order.  Would you like to fill them now?');
insert into strings (string_id, string_data) values (36, 'Cannot post product to inventory without specifying received date!');
insert into strings (string_id, string_data) values (37, 'Do you want to post received product to inventory?');
insert into strings (string_id, string_data) values (38, 'Initialize purchase, orders, and inventory data?');
insert into strings (string_id, string_data) values (39, 'Must first specify employee name!');
insert into strings (string_id, string_data) values (40, 'Specified user must be logged in to approve purchase!');
insert into strings (string_id, string_data) values (41, 'Purchase order must contain completed line items before it can be approved');
insert into strings (string_id, string_data) values (42, 'Sorry, you do not have permission to approve purchases.');
insert into strings (string_id, string_data) values (43, 'Purchase successfully approved');
insert into strings (string_id, string_data) values (44, 'Purchase cannot be approved');
insert into strings (string_id, string_data) values (45, 'Purchase successfully submitted for approval');
insert into strings (string_id, string_data) values (46, 'Purchase cannot be submitted for approval');
insert into strings (string_id, string_data) values (47, 'Sorry, purchase order does not contain line items');
insert into strings (string_id, string_data) values (48, 'Do you want to cancel this order?');
insert into strings (string_id, string_data) values (49, 'Canceling an order will permanently delete the order.  Are you sure you want to cancel?');
insert into strings (string_id, string_data) values (100, 'Your order was successfully canceled.');
insert into strings (string_id, string_data) values (101, 'Cannot cancel an order that has items received and posted to inventory.');
insert into strings (string_id, string_data) values (102, 'There was an error trying to cancel this order.');
insert into strings (string_id, string_data) values (103, 'The invoice for this order has not yet been created.');
insert into strings (string_id, string_data) values (104, 'Shipping information is not complete.  Please specify all shipping information and try again.');
insert into strings (string_id, string_data) values (105, 'Cannot mark as shipped.  Order must first be invoiced!');
insert into strings (string_id, string_data) values (106, 'Cannot cancel an order that has already shipped!');
insert into strings (string_id, string_data) values (107, 'Must first specify salesperson!');
insert into strings (string_id, string_data) values (108, 'Order is now marked closed.');
insert into strings (string_id, string_data) values (109, 'Order must first be marked shipped before closing.');
insert into strings (string_id, string_data) values (110, 'Must first specify payment information!');
insert into strings (string_id, string_data) values (111, 'There was an error attempting to restock inventory levels.  | product(s) were successfully restocked.');
insert into strings (string_id, string_data) values (112, 'You must supply a Unit Cost.');
insert into strings (string_id, string_data) values (113, 'Fill back ordered product, Order #|');
insert into strings (string_id, string_data) values (114, 'Purchase generated based on Order #|');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (1, 'Supplier A', 'Andersen', 'Elizabeth A.', NULL, 'Sales Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (2, 'Supplier B', 'Weiler', 'Cornelia', NULL, 'Sales Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (3, 'Supplier C', 'Kelley', 'Madeleine', NULL, 'Sales Representative', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (4, 'Supplier D', 'Sato', 'Naoki', NULL, 'Marketing Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (5, 'Supplier E', 'Hernandez-Echevarria', 'Amaya', NULL, 'Sales Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (6, 'Supplier F', 'Hayakawa', 'Satomi', NULL, 'Marketing Assistant', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (7, 'Supplier G', 'Glasson', 'Stuart', NULL, 'Marketing Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (8, 'Supplier H', 'Dunton', 'Bryn Paul', NULL, 'Sales Representative', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (9, 'Supplier I', 'Sandberg', 'Mikael', NULL, 'Sales Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');
insert into suppliers (id, company, last_name, first_name, email_address, job_title, business_phone, home_phone, mobile_phone, fax_number, address, city, state_province, zip_postal_code, country_region, web_page, notes, attachments) values (10, 'Supplier J', 'Sousa', 'Luis', NULL, 'Sales Manager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '');

commit;
