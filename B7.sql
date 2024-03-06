-- Tạo cơ sở dữ liệu để quản lý sinh viên
-- Yêu cầu:
-- có thông tin sinh viên, lớp (*: môn, điểm)
-- có kiểm tra ràng buộc
CREATE TABLE
  classroom (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL
  );

CREATE TABLE
  subject (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) UNIQUE NOT NULL,
  );

CREATE TABLE
  students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    gender BIT DEFAULT '0',
    birthday DATE,
    classroom_id INT,
    CONSTRAINT fk_classroom FOREIGN KEY (classroom_id) REFERENCES classroom (id)
  );

CREATE TABLE
  score (
    student_id INT NOT NULL,
    subject_id INT NOT NULL,
    score FLOAT NOT NULL,
    CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES students (id),
    CONSTRAINT fk_subject FOREIGN KEY (subject_id) REFERENCES subject (id),
    PRIMARY KEY (student_id, subject_id)
  );

INSERT INTO
  classroom (name)
VALUES
  ('LT'),
  ('KHMT'),
  ('KeToan'),
  ('CoKhi'),
  ('DienTu');

INSERT INTO
  subject (name)
VALUES
  ('SQL'),
  ('Toan1'),
  ('CSDL'),
  ('Reactjs'),
  ('Nextjs');

INSERT INTO
  students (name, classroom_id)
VALUES
  ('Long', 1),
  ('May', 2),
  ('Trung', 3),
  ('Trong', 4),
  ('Quang', 5),
  ('Thanh', NULL),
  ('Phi', NULL),
  ('Viet', 2),
  ('Nam', 3);

INSERT INTO
  score (subject_id, student_id, score)
VALUES
  (1, 2, 1.5),
  (1, 2, 2.3),
  (2, 3, 8.0),
  (2, 1, 10),
  (3, 4, 6),
  (3, 1, 5.2),
  (4, 7, 5.4),
  (5, 6, 6.5);

-- Thêm mỗi bảng số bản ghi nhất định
-- Lấy ra tất cả sinh viên kèm thông tin lớp
SELECT
  *
FROM
  students
  INNER JOIN classroom ON students.classroom_id = classroom.id;

-- Đếm số sinh viên theo từng lớp
SELECT
  classroom.name,
  COUNT(students)
FROM
  students
  INNER JOIN classroom ON students.classroom_id = classroom.id
GROUP BY
  classroom.name;

-- Lấy sinh viên kèm thông tin điểm và tên môn
SELECT
  students.id,
  students.name,
  subject.name,
  score.score
FROM
  score
  INNER JOIN subject ON score.subject_id = subject.id
  INNER JOIN students ON students.id = score.student_id;

-- (*) Lấy điểm trung bình của sinh viên của lớp LT
SELECT
  AVG(score)
FROM
  score
  INNER JOIN subject ON score.subject_id = subject.id
  INNER JOIN students ON score.student_id = students.id
  INNER JOIN classroom ON students.classroom_id = classroom.id
  AND classroom.name = 'LT';

-- (*) Lấy điểm trung bình của sinh viên của môn SQL
SELECT
  AVG(score)
FROM
  score
  INNER JOIN subject ON score.subject_id = subject.id
  AND subject.name = 'SQL';

-- (*) Lấy điểm trung bình của sinh viên theo từng lớp
SELECT
  AVG(score),
  classroom.names
FROM
  score
  INNER JOIN students ON score.student_id = students.id
  INNER JOIN classroom ON students.classroom_id = classroom.id
GROUP BY
  classroom.name;


CREATE OR REPLACE PROCEDURE select_all_student ()
AS $$
BEGIN
  SELECT * FROM students;
END ;
$$
LANGUAGE plpgsql ;