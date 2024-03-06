-- ================= BEFORE trigger =================
-- Tạo 1 trigger kiểm tra số chỗ trống trong lớp trước khi chèn sinh viên
SHOW TABLES;

DROP TABLE IF EXISTS students;

DROP TABLE IF EXISTS classroom;

CREATE TABLE
  classroom (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    available INT DEFAULT 5,
    PRIMARY KEY (id)
  );

CREATE TABLE
  students (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL,
    classroom_id INT,
    FOREIGN KEY (classroom_id) REFERENCES classroom (id),
    PRIMARY KEY (id)
  );

INSERT INTO
  classroom (name)
VALUES
  ('SQL'),
  ('Java'),
  ('Reactjs');

-- Create trigger before insert
CREATE TRIGGER trigger_before_insert_student BEFORE INSERT ON students 
FOR EACH ROW
BEGIN 
  DECLARE available_empty INT;
  SET
    available_empty = (
      SELECT
        available
      FROM
        classroom c
      WHERE
        c.id = NEW.classroom_id
    );

  IF available_empty <= 0 THEN SIGNAL SQLSTATE '45000'
  SET
    MESSAGE_TEXT = 'Không đủ chỗ trống trong phòng học';

  END IF;
END;


-- Create trigger after insert
DROP TRIGGER IF EXISTS trigger_after_insert_student;

CREATE TRIGGER trigger_after_insert_student AFTER INSERT ON students 
FOR EACH ROW 
BEGIN
  UPDATE classroom
  SET
    available = available - 1
  WHERE
    id = NEW.classroom_id;
END;

INSERT INTO
  students (name, classroom_id)
VALUES
  ('Duy', 1),
  ('Ha', 1),
  ('Manh', 1);

-- CREATE TRIGGER FOR UPDATE
DROP TRIGGER trigger_after_update_student;

CREATE TRIGGER trigger_after_update_student
AFTER UPDATE ON students
FOR EACH ROW
BEGIN
	DECLARE available_empty INT;
	SET available_empty = (SELECT available FROM classroom c WHERE c.id = NEW.classroom_id);

	IF available_empty <= 0  THEN
		SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Không đủ chỗ trống trong phòng học';
  ELSE
  	UPDATE classroom 
		SET available = available - 1
		WHERE id = NEW.classroom_id;
	
		UPDATE classroom 
		SET available = available + 1
		WHERE id = OLD.classroom_id; 
  END IF;
END;

SELECT * FROM students;
SELECT * FROM classroom;