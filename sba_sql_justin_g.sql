-- check if "cms" db exists
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'cms';

-- if "cms" does not exist, run "CMS_Database.sql" script
IF FOUND_ROWS() = 0 THEN
    SOURCE CMS_Database.sql;
END IF;


-- 

-- End of script.
