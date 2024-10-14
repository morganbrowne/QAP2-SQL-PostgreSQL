--Scenario
--You’re tasked with developing a system to manage university students, professors, courses, and their enroll
-- University Course Enrollment 


--==========================
--Create Needed tables:

-- Create Students Table...
CREATE TABLE students (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    school_enrollment_date DATE
);

-- Create Professors Table... 

CREATE TABLE professors (
    id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(100)
);

-- Create Courses Table... 

CREATE TABLE courses (
    id SERIAL PRIMARY KEY,
    course_name VARCHAR(100),
    course_description TEXT,
    professor_id INT,
    CONSTRAINT fk_professor
        FOREIGN KEY (professor_id)
        REFERENCES professors(id)
);

-- Create Enrollments Table... 

CREATE TABLE enrollments (
    student_id INT,
    course_id INT,
    enrollment_date DATE,
    PRIMARY KEY (student_id, course_id),
    CONSTRAINT fk_student
        FOREIGN KEY (student_id)
        REFERENCES students(id),
    CONSTRAINT fk_course
        FOREIGN KEY (course_id)
        REFERENCES courses(id)
);

--=============================
-- Insert Data into tables:

-- Insert Students Data Into Students Table... 

INSERT INTO students (first_name, last_name, email, school_enrollment_date)
VALUES
	('John', 'Doe', 'john.doe@example.com', '2024-09-01'),
	('John', 'Deer', 'john.deer@example.com', '2024-09-02'),
	('Mark', 'Foe', 'mark.foe@example.com', '2024-09-03'),
	('Jane', 'Smith', 'jane.smith@example.com', '2024-09-01'),
	('Kale', 'Write', 'kale.write@example.com', '2024-09-04');

-- Insert Professors Data into Professors Table... 

INSERT INTO professors (first_name, last_name, department)
VALUES 
	('John', 'Keating', 'Physics'),
	('Will', 'Hunting', 'Mathematics'),
	('Mia', 'Wallace', 'Business'),
	('Michael', 'Scofield', 'Engineering');

-- Match Courses and description to the professor using their id... 

INSERT INTO courses (course_name, course_description, professor_id)
VALUES 
	('Physics 101', 'Introduction to Physics', '1'),
	('Math 1901', 'Introduction to Math', '2'),
	('Business 1000', 'Introduction to Business', '3');

	
-- Insert Data into enrollments table... 

INSERT INTO enrollments (student_id, course_id, enrollment_date)
VALUES
	('1', '1', '2024-09-01'),
	('1', '2', '2024-09-01'),
	('2', '1', '2024-09-02'),
	('3', '3', '2024-09-01'),
	('2', '3', '2024-09-03');
	
--=======================
-- SQL Queries..

-- How to Gather the names of students enrolled in 'Physics 101'...
SELECT CONCAT(students.first_name, ' ', students.last_name) AS full_name
FROM students
JOIN enrollments ON students.id = enrollments.student_id
JOIN courses ON courses.id = enrollments.course_id
WHERE courses.course_name = 'Physics 101';

-- How to Gather a list of all courses with the professors name belonging to the courses... 
SELECT courses.course_name, 
       CONCAT(professors.first_name, ' ', professors.last_name) AS professor_full_name
FROM courses
JOIN professors ON courses.professor_id = professors.id;

-- Gather all courses that have students enrolled in them... 
SELECT DISTINCT courses.course_name
FROM courses
JOIN enrollments ON courses.id = enrollments.course_id;

-- Updating Data... 

-- Update a students E-Mail...
UPDATE students
SET email = 'markfoe.uni@example.com'
WHERE first_name = 'Mark' AND last_name = 'Foe';

-- Delete Data... 

-- Remove a student from a course... 
DELETE FROM enrollments
WHERE student_id = (SELECT id FROM students WHERE first_name = 'John' AND last_name = 'Doe')
AND course_id = (SELECT id FROM courses WHERE course_name = 'Physics 101');
