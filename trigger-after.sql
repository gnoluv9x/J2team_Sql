-- Thêm sinh viên đồng thời tăng số lượng sv ở bảng lớp
-- Row-level triggers
DROP TABLE IF EXISTS classroom;

CREATE TABLE classroom(
  ID serial,
  NAME varchar(50),
  number_students int DEFAULT 0,
  PRIMARY KEY (ID)
);

DROP TABLE IF EXISTS students;

CREATE TABLE students(
  ID serial,
  NAME varchar(50),
  CLASSROOM_ID int,
  CONSTRAINT fk_classroom_id FOREIGN KEY (CLASSROOM_ID) REFERENCES classroom(id)
);

INSERT INTO classroom(name)
  VALUES ('Reactjs'),
('SQL'),
('Nextjs');

CREATE OR REPLACE FUNCTION func_after_insert_student()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS $$
BEGIN
  UPDATE
    classroom
  SET
    number_students = number_students + 1
  WHERE
    id = NEW.classroom_id;
  RETURN NEW;
END;
$$;

DROP TRIGGER trigger_after_insert_student ON students;

CREATE TRIGGER trigger_after_insert_student
  AFTER INSERT ON students
  FOR EACH ROW
  EXECUTE PROCEDURE func_after_insert_student();

INSERT INTO students(name, classroom_id)
  VALUES ('Trung', 1);

INSERT INTO students(name, classroom_id)
  VALUES ('Long', 2);

INSERT INTO students(name, classroom_id)
  VALUES ('Quang', 3);

INSERT INTO students(name, classroom_id)
  VALUES ('Trang', 1);

INSERT INTO students(name, classroom_id)
  VALUES ('Hạnh', 2);

INSERT INTO students(name, classroom_id)
  VALUES ('Mai', 1);

INSERT INTO students(name, classroom_id)
  VALUES ('Anh', 2);

-- After delete
CREATE OR REPLACE FUNCTION func_after_delete_student()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS $$
BEGIN
  UPDATE
    classroom
  SET
    number_students = number_students - 1
  WHERE
    id = OLD.classroom_id;
  RETURN OLD;
END;
$$;

DROP TRIGGER trigger_after_delete_student CREATE TRIGGER trigger_after_delete_student
  AFTER DELETE ON students
  FOR EACH ROW
  EXECUTE PROCEDURE func_after_delete_student();

DELETE FROM students
WHERE id = 13;

-- Create trigger for update
CREATE OR REPLACE FUNCTION func_after_update_student()
  RETURNS TRIGGER
  LANGUAGE PLPGSQL
  AS $$
BEGIN
  UPDATE
    classroom
  SET
    number_students = number_students - 1
  WHERE
    id = OLD.classroom_id;
  UPDATE
    classroom
  SET
    number_students = number_students + 1
  WHERE
    id = NEW.classroom_id;
  RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trigger_after_update_student
  AFTER UPDATE ON students
  FOR EACH ROW
  EXECUTE PROCEDURE func_after_update_student();

UPDATE
  students
SET
  classroom_id = 2
WHERE
  id = 10;

UPDATE
  classroom
SET
  number_students = 2
WHERE
  id IN (2, 3);

SELECT
  *
FROM
  students;

SELECT
  *
FROM
  classroom
ORDER BY
  id ASC;

