-- create "cms" db if it doesn't exist
SELECT SCHEMA_NAME
FROM INFORMATION_SCHEMA.SCHEMATA
WHERE SCHEMA_NAME = 'cms';

IF FOUND_ROWS() = 0 THEN
    SOURCE CMS_Database.sql;
END IF;



-- create stored procedures

-- procedure for requirement A: List Department Courses
DELIMITER $$
CREATE PROCEDURE ListDepartmentCourses()
BEGIN
    -- list each department and number of courses offered
    SELECT d.name AS "Department Name", COUNT(c.id) AS "# Courses"
    FROM department AS d
    LEFT JOIN course AS c ON d.id = c.deptId
    GROUP BY d.id, d.name
    ORDER BY "# Courses" ASC;
END;
$$
DELIMITER ;



-- call the stored procedures for each requirement

-- requirement A
CALL ListDepartmentCourses();

-- end of script
