-- Database: prescription_pharmacy

DROP DATABASE IF EXISTS prescription_pharmacy;

CREATE DATABASE prescription_pharmacy
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.utf8'
    LC_CTYPE = 'en_US.utf8'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

\connect prescription_pharmacy;

DROP TABLE IF EXISTS contract CASCADE;
DROP TABLE IF EXISTS doctor CASCADE;
DROP TABLE IF EXISTS make_drug CASCADE;
DROP TABLE IF EXISTS patient CASCADE;
DROP TABLE IF EXISTS pharmaceutical CASCADE;
DROP TABLE IF EXISTS pharmacy CASCADE;
DROP TABLE IF EXISTS prescription CASCADE;
DROP TABLE IF EXISTS primary_phy_patient CASCADE;
DROP TABLE IF EXISTS sell CASCADE;
