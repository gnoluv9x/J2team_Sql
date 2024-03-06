-- Tạo function thao tác với bảng lớp (mã, tên) và sinh viên (mã, tên, giới tính, ngày sinh, mã lớp):
CREATE TYPE gender AS ENUM(
  'f',
  'm'
);

CREATE TABLE classroom(
  id serial,
  name varchar(50) UNIQUE NOT NULL,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS students;

CREATE TABLE students(
  id serial,
  name varchar(50) NOT NULL,
  gender gender DEFAULT 'f',
  phone_number char(12) UNIQUE NOT NULL,
  birth_day date,
  classroom_id int,
  CONSTRAINT fk_classroom FOREIGN KEY (classroom_id) REFERENCES classroom(id),
  PRIMARY KEY (id))
-- Insert values
INSERT INTO classroom(
  name)
  VALUES (
    'IT'),
(
    'Accountant'),
(
    'Mechanical'),
(
    'Electrical'
);

INSERT INTO students(name, gender, phone_number, birth_day, classroom_id)
  VALUES ('Long', 'm', '0389926795', '1998-11-01', 1),
('Trang', 'f', '0372667055', '1998-11-01', 2),
('Nam', 'm', '0389123456', '1996-10-11', 3),
('Quỳnh', 'f', '0389123457', '1999-01-21', 2),
('Trung', 'm', '0389123458', '2000-04-22', 1);

-- hiển thị tên giới tính
CREATE OR REPLACE FUNCTION func_get_gender(gender gender)
  RETURNS char
  AS $$
DECLARE
  gender_name ALIAS FOR gender;
BEGIN
  IF gender_name = 'f' THEN
    RETURN 'Nữ';
  ELSE
    RETURN 'Nam';
  END IF;
END
$$
LANGUAGE plpgsql;

SELECT
  name,
  func_get_gender(gender)
FROM
  students;

-- hiển thị tuổi
CREATE OR REPLACE FUNCTION func_get_age_from_birth_day(birthday date)
  RETURNS int
  AS $$
BEGIN
  RETURN DATE_PART('YEAR', AGE(NOW(), birthday));
END
$$
LANGUAGE plpgsql;

SELECT
  NAME,
  func_get_age_from_birth_day(BIRTH_DAY) AS AGE
FROM
  STUDENTS;

-- join 2 bảng và hiển thị lại toàn bộ thông tin theo mã sinh viên truyền vào
CREATE OR REPLACE FUNCTION func_get_student_details(student_id int)
  RETURNS TABLE(
    name varchar(50),
    age int,
    gender char,
    phone_number char(12),
    classroom_name varchar(50)
  )
  AS $$
BEGIN
  RETURN QUERY
  SELECT
    students.name,
    func_get_age_from_birth_day(students.birth_day) AS age,
    func_get_gender(students.gender) AS gender,
    students.phone_number,
    classroom.name AS classroom_name
  FROM
    students
    INNER JOIN classroom ON students.classroom_id = classroom.id
  WHERE
    students.id = student_id;
END
$$
LANGUAGE plpgsql;

SELECT
  *
FROM
  func_get_student_details(1);

