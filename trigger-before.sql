-- Trigger before thường được sử dụng để kiểm tra dữ liệu: Thứ tự
-- Thêm sinh viên vào lớp còn chỗ trống
DROP TABLE IF EXISTS classroom;

DELETE FROM classroom;

CREATE TABLE classroom(
  id serial,
  name varchar(50),
  empty int DEFAULT 5,
  PRIMARY KEY (id)
);

DROP TABLE IF EXISTS students;

DELETE FROM students;

CREATE TABLE students(
  id serial,
  name varchar(50),
  classroom_id int,
  CONSTRAINT fk_classroom_id FOREIGN KEY (classroom_id) REFERENCES classroom(id)
);

INSERT INTO classroom(name)
  VALUES ('SQL'),
('Reactjs'),
('Nextjs');

-- Create trigger to check empty before insert
CREATE OR REPLACE FUNCTION func_insert_student_to_classroom()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
DECLARE
  total_students int;
  max_students constant int := 5;
BEGIN
  SELECT
    count(*) INTO total_students
  FROM
    students
  WHERE
    classroom_id = NEW.classroom_id;
  RAISE NOTICE 'BEFORE Total student: %, NEW: %', total_students, NEW;
  IF total_students = max_students THEN
    RAISE EXCEPTION 'Không đủ chỗ trống';
  END IF;
  RETURN NEW;
END;
$$;

-- Create trigger to update empty
CREATE OR REPLACE FUNCTION func_decrease_empty_classroom()
  RETURNS TRIGGER
  LANGUAGE plpgsql
  AS $$
DECLARE
  total_students int;
  available_slots int;
BEGIN
  UPDATE
    classroom
  SET
    empty = empty - 1
  WHERE
    id = NEW.classroom_id;
  SELECT
    count(*) INTO total_students
  FROM
    students
  WHERE
    classroom_id = NEW.classroom_id;
  SELECT
    empty INTO available_slots
  FROM
    classroom
  WHERE
    id = NEW.classroom_id;
  RAISE NOTICE 'AFTER total_students: %, AFTER available_student: %', total_students, available_slots;
  RETURN NEW;
END;
$$;

CREATE TRIGGER trigger_insert_student_to_classroom
  BEFORE INSERT ON students
  FOR EACH ROW
  EXECUTE PROCEDURE func_insert_student_to_classroom();

CREATE TRIGGER trigger_decrease_empty_classroom
  AFTER INSERT ON students
  FOR EACH ROW
  EXECUTE PROCEDURE func_decrease_empty_classroom();

SELECT
  *
FROM
  classroom;

SELECT
  *
FROM
  students;

INSERT INTO students(name, classroom_id)
  VALUES ('Huynh', 7),
('Thai', 7),
('Tuan', 7),
('Long', 7),
('Trang', 7);

SELECT
  $$ I 'm ALSO a string constant$$;

