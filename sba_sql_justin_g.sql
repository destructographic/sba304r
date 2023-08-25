-- drop the "cms" database if it exists
DROP DATABASE IF EXISTS cms;

-- build "cms" database from provided CMS_Database.sql
SOURCE CMS_Database.sql;



-- ### create stored procedures to fullfill each requiment ### 

-- requirement A: List Department Courses
DELIMITER $$
CREATE PROCEDURE ListDepartmentCourses()
BEGIN
    -- list each department and number of courses offered
    SELECT d.name AS `Department Name`, COUNT(c.id) AS `# Courses`
    FROM department AS d
    LEFT JOIN course AS c ON d.id = c.deptId
    GROUP BY d.id, d.name
    ORDER BY `# Courses` ASC;
END;
$$
DELIMITER ;


-- requirement B: List Most Popular Courses
DELIMITER $$
CREATE PROCEDURE ListMostPopularCourses()
BEGIN
    -- course name and number of students in each course
    SELECT c.name AS `Course Name`, COUNT(sc.studentId) AS `# Students`
    FROM course AS c
    LEFT JOIN studentCourse AS sc ON c.id = sc.courseId
    GROUP BY c.id
    ORDER BY `# Students` DESC, c.name ASC;
END;
$$
DELIMITER ;


-- requirement C-1: List Courses with No Faculty
DELIMITER $$
CREATE PROCEDURE ListCoursesNoFaculty()
BEGIN
    -- course names with no faculty
    SELECT c.name AS `Course Name`
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
    SELECT c.name AS `Course Name`, COUNT(sc.studentId) AS `# Students`
    FROM course AS c
    LEFT JOIN studentCourse AS sc ON c.id = sc.courseId
    LEFT JOIN facultyCourse AS fc ON c.id = fc.courseId
    WHERE fc.facultyId IS NULL
    GROUP BY c.id
    ORDER BY `# Students` DESC, `Course Name` ASC;
END;
$$
DELIMITER ;


-- requirement D: List Total Students Enrolled by Year
DELIMITER $$
CREATE PROCEDURE ListTotalStudentsEnrolledByYear()
BEGIN
    -- list total # of students enrolled by year
    SELECT COUNT(sc.studentId) AS `Students`, YEAR(sc.startdate) AS `Year`
    FROM studentCourse AS sc
    GROUP BY YEAR(sc.startdate)
    ORDER BY YEAR(sc.startdate) ASC;
END;
$$
DELIMITER ;


-- requirement E: List August Admissions
DELIMITER $$
CREATE PROCEDURE ListAugustAdmissions()
BEGIN
    -- list start date and # of students for August admissions
    SELECT sc.startdate AS `Start Date`, COUNT(sc.studentId) AS `# Students`
    FROM studentCourse AS sc
    WHERE MONTH(sc.startdate) = 8
    GROUP BY YEAR(sc.startdate), MONTH(sc.startdate)
    ORDER BY sc.startdate ASC;
END;
$$
DELIMITER ;


-- requirement F: List Students Taking Major Courses
CREATE VIEW StudentsTakingMajorCoursesView AS
SELECT s.firstname AS `First Name`, s.lastname AS `Last Name`, COUNT(sc.courseId) AS `# Courses`
FROM student AS s
LEFT JOIN studentCourse AS sc ON s.id = sc.studentId
WHERE sc.progress IS NOT NULL
GROUP BY s.id, s.firstname, s.lastname
ORDER BY `# Courses` ASC, s.lastname ASC;

DELIMITER $$
CREATE PROCEDURE ListStudentsTakingMajorCourses()
BEGIN
    -- query the view and output results
    SELECT `First Name`, `Last Name`, `# Courses` FROM StudentsTakingMajorCoursesView;
END $$
DELIMITER ;


-- requirement G: List Students Needing Tutoring
DELIMITER $$
CREATE PROCEDURE ListStudentsNeedingTutoring()
BEGIN
    -- students with average progress less than 50%
    SELECT s.firstname AS `First Name`, s.lastname AS `Last Name`,
           ROUND(AVG(sc.progress), 1) AS `Average Progress`
    FROM student AS s
    LEFT JOIN studentCourse AS sc ON s.id = sc.studentId
    GROUP BY s.id, `First Name`, `Last Name`
    HAVING `Average Progress` < 50.0
    ORDER BY `Average Progress` DESC;
END;
$$
DELIMITER ;



-- ### call the stored procedures for each requirement ### 

DELIMITER $$
CREATE PROCEDURE RunAllRequirements()
BEGIN  
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

    -- requirement E
    CALL ListAugustAdmissions();

    -- requirement F
    CALL ListStudentsTakingMajorCourses();

    -- requirement G
    CALL ListStudentsNeedingTutoring();
END;
$$
DELIMITER ;



CALL RunAllRequirements();



-- end of script
