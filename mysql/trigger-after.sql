-- AFTER UPDATE
-- Tạo 1 trigger sẽ update số lượng sinh viên vào lớp sau khi insert sinh viên
SHOW TABLES;

DROP TABLE IF EXISTS students;

DROP TABLE IF EXISTS classroom;

CREATE TABLE
  students (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(50),
    phone_number varchar(12) UNIQUE,
    birth_day date DEFAULT '2000-01-01',
    classroom_id int,
    PRIMARY KEY (id),
    FOREIGN KEY (classroom_id) REFERENCES classroom (id)
  );

CREATE TABLE
  classroom (
    id int NOT NULL AUTO_INCREMENT,
    name varchar(50) character
    SET
      utf8mb4 COLLATE utf8mb4_unicode_ci,
      total_students int DEFAULT 0,
      PRIMARY KEY (id)
  );

INSERT INTO
  classroom (name)
VALUES
  ('SQL'),
  ('Lập trình'),
  ('Nextjs');

INSERT INTO
  students (name, phone_number, classroom_id)
VALUES
  ('Long', '0389926795', 1);

DROP TRIGGER update_total_students_trigger;

CREATE TRIGGER update_total_student AFTER INSERT ON students FOR EACH ROW BEGIN
UPDATE classroom
SET
  total_students = total_students + 1
WHERE
  id = NEW.classroom_id;

END;

-- trigger after delete
CREATE TRIGGER trigger_after_delete_student AFTER DELETE ON students FOR EACH ROW BEGIN
UPDATE classroom
SET
  total_students = total_students - 1
WHERE
  id = OLD.classroom_id;

END;

-- trigger after update
CREATE TRIGGER trigger_after_udpate_student AFTER
UPDATe ON students FOR EACH ROW BEGIN
UPDATE classroom
SET
  total_students = total_students - 1
WHERE
  id = OLD.classroom_id;

END;

INSERT INTO
  students (name, phone_number, classroom_id)
VALUES
  ('Trung', '0389926793', 1);

DELETE FROM students
WHERE
  id = 7;

SELECT
  *
FROM
  students s;

SELECT
  *
FROM
  classroom c;