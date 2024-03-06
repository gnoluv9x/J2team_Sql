-- Bài tập tổng hợp kiến thức (sau mỗi 3 buổi mình sẽ đăng 1 bài thế này, các bạn có thể bình luận đáp án ở đây hoặc trên Discord để xem ai có câu trả lời chính xác nhất nhé):
-- Sếp yêu cầu bạn thiết kế cơ sở dữ liệu quản lý lương nhân viên
CREATE TABLE
  employee_salaries (
    id SERIAL,
    salary int,
    name varchar(50),
    birthday date,
    gender bit,
    start_date date,
    job char(20),
    PRIMARY KEY (id)
  );

-- Với điều kiện:
-- mã nhân viên không được phép trùng
-- lương là số nguyên dương
-- tên không được phép ngắn hơn 2 ký tự
ALTER TABLE employee_salaries ADD CONSTRAINT check_name_length CHECK (LENGTH (name) >= 2);

-- tuổi phải lớn hơn 18
ALTER TABLE employee_salaries ADD CONSTRAINT check_age CHECK (
  AGE (CURRENT_DATE, birthday) > interval "18 years"
);

-- giới tính mặc định là nữ
ALTER TABLE employee_salaries
ALTER COLUMN gender
SET DEFAULT '0';

-- ngày vào làm mặc định là hôm nay
ALTER TABLE employee_salaries
ALTER COLUMN start_date
SET DEFAULT CURRENT_DATE;

-- (*) nghề nghiệp phải nằm trong danh sách ('IT','kế toán','doanh nhân thành đạt')
ALTER TABLE employee_salaries ADD CONSTRAINT check_job CHECK (job in ('IT', 'Kế toán', 'Doanh nhân thành đạt'));

-- tất cả các cột không được để trống
ALTER TABLE employee_salaries
ALTER COLUMN salary
SET
  NOT NULL,
ALTER COLUMN name
SET
  NOT NULL,
ALTER COLUMN birthday
SET
  NOT NULL,
ALTER COLUMN gender
SET
  NOT NULL,
ALTER COLUMN start_date
SET
  NOT NULL,
ALTER COLUMN job
SET
  NOT NULL;

-- 1. Công ty có 5 nhân viên
INSERT INTO
  employee_salaries (salary, name, birthday, gender, start_date, job)
VALUES
  (
    16500,
    'Quỳnh',
    '1996-01-27',
    '0',
    '2023-11-11',
    'Kế toán'
  );

-- 2. Tháng này sinh nhật sếp, sếp tăng lương cho nhân viên sinh tháng này thành 100. (*: tăng lương cho mỗi bạn thêm 100)
UPDATE employee_salaries
SET
  salary = 100
WHERE
  EXTRACT(
    MONTH
    FROM
      birthday
  ) = EXTRACT(
    MONTH
    FROM
      CURRENT_DATE
  );

--* Tăng cho mỗi bạn 100
UPDATE employee_salaries
SET
  salary = salary + 100
WHERE
  EXTRACT(
    MONTH
    FROM
      birthday
  ) = EXTRACT(
    MONTH
    FROM
      CURRENT_DATE
  );

-- 3. Dịch dã khó khăn, cắt giảm nhân sự, cho nghỉ việc bạn nào lương dưới 50. (*: xoá cả bạn vừa thêm 100 nếu lương cũ dưới 50). (**: đuổi cả nhân viên mới vào làm dưới 2 tháng)
DELETE FROM employee_salaries
WHERE
  salary < 50;

-- * Xoá cả những bạn vừa thêm 100 nếu lương cũ dưới 50
DELETE FROM employee_salaries
WHERE
  (
    EXTRACT(
      MONTH
      FROM
        birthday
    ) = EXTRACT(
      MONTH
      FROM
        CURRENT_DATE
    )
  )
  AND (
    salary <= 150
    OR salary >= 100
  );

-- **: đuổi cả nhân viên mới vào làm dưới 2 tháng
DELETE FROM employee_salaries
WHERE
  (
    EXTRACT(
      MONTH
      FROM
        AGE (CURRENT_DATE, start_date)
    ) < 2
  );

-- 4. Lấy ra tổng tiền mỗi tháng sếp phải trả cho nhân viên. (*: theo từng nghề)
SELECT
  SUM(salary)
FROM
  employee_salaries;

SELECT
  SUM(salary) as it_salaries
FROM
  employee_salaries
GROUP BY
  job;

-- Lấy ra trung bình lương nhân viên. (*: theo từng nghề)
SELECT
  job,
  ROUND(AVG(salary), 2)
FROM
  employee_salaries
GROUP BY
  job;

-- 5. (*) Lấy ra các bạn mới vào làm hôm nay
SELECT
  *
FROM
  employee_salaries
WHERE
  start_date = CURRENT_DATE;

-- 6. (*) Lấy ra 3 bạn nhân viên cũ nhất
SELECT
  top 3 *
FROM
  employee_salaries
ORDER BY
  start_date ASC
limit
  3;

-- 7. (**) Tách những thông tin trên thành nhiều bảng cho dễ quản lý, lương 1 nhân viên có thể nhập nhiều lần