-- Tạo bảng lưu thông tin điểm của sinh viên (mã, họ tên, điểm lần 1, điểm lần 2)
-- Với điều kiện:
-- điểm không được phép nhỏ hơn 0 và lớn hơn 10
-- điểm lần 1 nếu không nhập mặc định sẽ là 5
-- (*) điểm lần 2 không được nhập khi mà điểm lần 1 lớn hơn hoặc bằng 5
-- (**) tên không được phép ngắn hơn 2 ký tự
CREATE TABLE
  students (
    id SERIAL PRIMARY KEY,
    name varchar(50) CHECK (LENGTH (name) >= 2),
    firstScore FLOAT DEFAULT 5 CHECK (
      firstScore >= 0
      AND firstScore <= 10
    ),
    secondScore FLOAT CHECK (
      secondScore >= 0
      AND secondScore <= 10
      AND (
        firstScore < 5
        OR secondScore IS NULL
      )
    )
  );

-- Điền 5 sinh viên kèm điểm
INSERT INTO
  students (name, firstScore, secondScore)
VALUES
  ('Quang', 4, 9),
  ('Long', 3, 9);

-- Lấy ra các bạn điểm lần 1 hoặc lần 2 lớn hơn 5
SELECT
  *
FROM
  students
WHERE
  firstScore > 5
  OR secondScore > 5;

-- Lấy ra các bạn qua môn ngay từ lần 1
SELECT
  *
FROM
  students
WHERE
  firstScore >= 5;

-- Lấy ra các bạn trượt môn
SELECT
  *
FROM
  students
WHERE
  firstScore < 5
  AND (
    secondScore IS NULL
    OR secondScore < 5
  );

-- (*) Đếm số bạn qua môn sau khi thi lần 2
SELECT
  COUNT(*)
from
  students
WHERE
  (
    firstScore < 5
    AND secondScore IS NOT NULL
    AND secondScore >= 5
  );

-- (**) Đếm số bạn cần phải thi lần 2 (tức là thi lần 1 chưa qua nhưng chưa nhập điểm lần 2)
SELECT
  COUNT(*)
from
  students
WHERE
  (
    firstScore < 5
    AND secondScore IS NULL
  );