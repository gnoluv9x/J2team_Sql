--1. Tạo bảng lưu thông tin khách hàng (mã, họ tên, số điện thoại, địa chỉ, giới tính, ngày sinh)
CREATE TABLE
  Customers (
    id SERIAL PRIMARY KEY,
    name varchar(50),
    phone char(11),
    address varchar(255),
    gender bit,
    birthday date
  );

--2. Thêm 5 khách hàng
INSERT INTO
  customers (name, phone, address, gender, birthday)
VALUES
  (
    'Long',
    '0389926795',
    'lam thao - phu tho',
    '1',
    '1990-11-26'
  ),
  (
    'Trang',
    '0372667055',
    'tan ky - nghe an',
    '0',
    '1998-11-01'
  ),
  (
    'Đức',
    '0123456789',
    'tho xuan - thanh hoa',
    '1',
    '1989-04-01'
  ),
  (
    'Oanh',
    '0123456789',
    'tuyen quang',
    '0',
    '1993-01-01'
  ),
  (
    'Phong',
    '0123456789',
    'lang Mia - Lang Giang - Bac Giang',
    '1',
    '1990-07-14'
  ),
  (
    'Long',
    '0389926795',
    'lam thao - phu tho',
    '1',
    '1990-01-01'
  ),
  (
    'Trang',
    '0372667055',
    'tan ky - nghe an',
    '0',
    '1998-02-01'
  ),
  (
    'Đức',
    '0123456789',
    'tho xuan - thanh hoa',
    '1',
    '1989-01-01'
  ),
  (
    'Oanh',
    '0123456789',
    'tuyen quang',
    '0',
    '1993-01-01'
  ),
  (
    'Phong',
    '0123456789',
    'lang Mia - Lang Giang - Bac Giang',
    '1',
    '1990-07-14'
  );

--3. Hiển thị chỉ họ tên và số điện thoại của tất cả khách hàng
SELECT
  name,
  phone
FROM
  customers;

--4. Cập nhật khách có mã là 2 sang tên Tuấn
UPDATE customers
set
  name = 'Tuấn'
where
  id = 2;

SELECT
  id,
  name,
  phone
FROM
  customers;

--5. Xoá khách hàng có mã lớn hơn 3 và giới tính là Nam
DELETE FROM customers
WHERE
  id > 3
  AND gender = '1';

--6. (*) Lấy ra khách hàng sinh tháng 1
SELECT
  *
FROM
  customers
WHERE
  EXTRACT(
    MONTH
    FROM
      birthday
  ) = 1;

--7. (*) Lấy ra khách hàng có họ tên trong danh sách (Anh,Minh,Đức) và giới tính Nam hoặc chỉ cần năm sinh trước 2000
SELECT
  *
FROM
  customers
WHERE
  EXTRACT(
    YEAR
    FROM
      birthday
  ) < 2000
  OR (
    name in ('Anh', 'Minh', 'Đức')
    AND gender = '1'
  );

--8. (**) Lấy ra khách hàng có tuổi lớn hơn 18
SELECT
  *
FROM
  customers
WHERE
  AGE (current_date, birthday) > interval '18 years';

--9. (**) Lấy ra 3 khách hàng mới nhất
SELECT
  *
FROM
  customers
ORDER BY
  id DESC
LIMIT
  3;

--10. (**) Lấy ra khách hàng có tên chứa chữ T
SELECT
  *
FROM
  customers
WHERE
  -- position('T' in name) > 0;
  name LIKE '%T%';

--11. (***) Thay đổi bảng sao cho chỉ nhập được ngày sinh bé hơn ngày hiện tại
ALTER TABLE customers ADD CONSTRAINT verify_birthday CHECK (birthday < CURRENT_TIMESTAMP)