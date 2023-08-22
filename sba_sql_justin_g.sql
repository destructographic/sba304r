-- check if db exists
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'cms';

-- create db if it doesn't exist
CREATE DATABASE IF NOT EXISTS cms;


USE cms;

-- run the provided script CMS_Database.sql
SOURCE CMS_Database.sql;
