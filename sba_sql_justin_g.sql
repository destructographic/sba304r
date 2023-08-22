-- drop the "cms" database if it exists
DROP DATABASE IF EXISTS cms;

-- build "cms" database from provided CMS_Database.sql
SOURCE CMS_Database.sql;



-- create stored procedures to fullfill each requiment

-- requirement A: List Department Courses
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


-- requirement B: List Most Popular Courses
DELIMITER $$
CREATE PROCEDURE ListMostPopularCourses()
BEGIN
    -- course name and number of students in each course
    SELECT c.name AS "Course Name", COUNT(sc.studentId) AS "# Students"
    FROM course AS c
    LEFT JOIN studentCourse AS sc ON c.id = sc.courseId
    GROUP BY c.id
    ORDER BY "# Students" DESC, c.name ASC;
END;
$$
DELIMITER ;


-- requirement C-1: List Courses with No Faculty
DELIMITER $$
CREATE PROCEDURE ListCoursesNoFaculty()
BEGIN
    -- course names with no faculty
    SELECT c.name AS "Course Name"
    FROM course AS c
    LEFT JOIN facultyCourse AS fc ON c.id = fc.courseId
    WHERE fc.facultyId IS NULL
    ORDER BY c.name ASC;
END;
$$
DELIMITER ;


-- requirement C-2: List Course Names and Student Count (No Faculty)
DELIMITER $$
CREATE PROCEDURE ListCourseStudentCountNoFaculty()
BEGIN
    -- course names and # of students with no faculty
    SELECT c.name AS "Course Name", COUNT(sc.studentId) AS "# Students"
    FROM course AS c
    LEFT JOIN studentCourse AS sc ON c.id = sc.courseId
    LEFT JOIN facultyCourse AS fc ON c.id = fc.courseId
    WHERE fc.facultyId IS NULL
    GROUP BY c.id
    ORDER BY "# Students" DESC, c.name ASC;
END;
$$
DELIMITER ;


-- requirement D: List Total Students Enrolled by Year
DELIMITER $$
CREATE PROCEDURE ListTotalStudentsEnrolledByYear()
BEGIN
    -- list total # of students enrolled by year
    SELECT COUNT(sc.studentId) AS "Students", YEAR(sc.startdate) AS "Year"
    FROM studentCourse AS sc
    GROUP BY YEAR(sc.startdate)
    ORDER BY YEAR(sc.startdate) ASC;
END;
$$
DELIMITER ;



-- call the stored procedures for each requirement

-- requirement A
CALL ListDepartmentCourses();

-- requirement B
CALL ListMostPopularCourses();

-- requirement C-1
CALL ListCoursesNoFaculty();

-- requirement C-2
CALL ListCourseStudentCountNoFaculty();

-- requirement D
CALL ListTotalStudentsEnrolledByYear();

-- end of script
