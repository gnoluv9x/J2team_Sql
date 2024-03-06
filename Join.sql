-- Tạo bảng lưu sinh viên và lớp
CREATE TABLE
  room (id SERIAL PRIMARY KEY, name VARCHAR(50));

CREATE TABLE
  students (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    room_id INT,
    CONSTRAINT fk_room FOREIGN KEY (room_id) REFERENCES room (id)
  );

INSERT INTO
  room (name)
VALUES
  ('IT'),
  ('KinhTe'),
  ('KeToan'),
  ('SinhHoc');

INSERT INTO
  students (name, room_id)
VALUES
  ('Long', 1),
  ('Trang', 4),
  ('Quang', 3),
  ('Trung', 2),
  ('Hoc', 1),
  ('Trong', 2),
  ('Linh', NULL),
  ('Nhan', NULL);

-- Chọn tất cả sinh viên và lớp của họ?
SELECT
  *
FROM
  students
  INNER JOIN room ON students.room_id = room.id;

-- Chọn tất cả sinh viên và lớp của họ (nếu có)?
SELECT
  *
FROM
  students
  LEFT JOIN room ON students.room_id = room.id;

-- Chọn tất cả những sinh viên chưa có lớp?
SELECT
  *
FROM
  students
  LEFT JOIN room ON students.room_id = room.id
WHERE
  students.room_id IS NULL;