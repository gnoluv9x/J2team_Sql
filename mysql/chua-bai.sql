SHOW TABLES;

-- Create table khoa
DROP TABLE khoa;

CREATE TABLE khoa(
	ma INT(2) ZEROFILL NOT NULL AUTO_INCREMENT,
	tenkhoa VARCHAR(255) UNIQUE,
	namthanhlap DATE,
	PRIMARY KEY(ma)
);

CREATE TABLE trigger_log (
    id INT AUTO_INCREMENT PRIMARY KEY,
    log_message VARCHAR(255),
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

DELETE FROM khoa;

SELECT * FROM khoa;

INSERT INTO khoa(tenkhoa,namthanhlap) 
VALUES
	('Khoa Nội', '1989-03-23'),
	('Khoa Ngoại', '1989-03-23'),
	('Khoa Nhi', '1989-03-23'),
	('Khoa Thần kinh', '1993-06-15');

-- Create table nhanvien
DROP TABLE nhanvien;

CREATE TABLE nhanvien(
	manhanvien INT(3) ZEROFILL NOT NULL AUTO_INCREMENT,
	tennhanvien VARCHAR(255) NOT NULL,
	ngaysinh DATE,
	makhoa INT(2) ZEROFILL,
	PRIMARY KEY(manhanvien),
	FOREIGN KEY(makhoa) REFERENCES khoa(ma)
);

SELECT * FROM nhanvien n ;

INSERT INTO nhanvien (tennhanvien,ngaysinh,makhoa)
VALUES
	('Tôn Thất Tùng','1939-03-02',1),
	('Trần Quán Ánh', '1945-06-20',1),
	('Phạm Thị Tươi', '1966-06-24',2),
	('Phạm Thanh Thảo', '1975-10-20',2),
	('Nguyễn Hà Thanh', '1977-11-02',2),
	('Tô Huy Rứa', '1950-02-13',3),
	('Vũ Thái Hà', '1960-03-15',3),
	('Phạm Văn Hùng', '1970-12-13',4),
	('Nguyễn Vũ Trường Sơn', '1965-03-15',4);

-- Create table benhnhan
DROP TABLE benhnhan;

CREATE TABLE benhnhan(
	mabenhnhan INT(4) ZEROFILL NOT NULL AUTO_INCREMENT,
	tenbenhnhan VARCHAR(255) NOT NULL,
	ngaysinh DATE,
	benh TEXT NOT NULL,
	makhoa INT(2) ZEROFILL,
	ngaynhap DATE,
	ngayxuat DATE,
	PRIMARY KEY(mabenhnhan),
	FOREIGN KEY(makhoa) REFERENCES khoa(ma)
);

SELECT * FROM benhnhan b
INNER JOIN khoa ON b.makhoa = khoa.ma;

INSERT INTO benhnhan (tenbenhnhan,ngaysinh,benh,makhoa,ngaynhap,ngayxuat)
VALUES
	('Nguyễn Quang A','1945-04-05','Đau ruột thừa',1,'2009-03-12','2009-03-18'),
	('Trần Văn Tuất','1946-04-15','Đau đầu',4,'2009-03-12','2009-03-23'),
	('Phạm Tuấn Tú','2003-09-15','Viêm họng',3,'2009-03-15','2009-03-20'),
	('Phạm Thị Mùi','2008-03-05','Đau dại dày',3,'2009-03-19','2009-04-20'),
	('Tô Hương Linh','1995-02-15','Viêm dạ dày',1,'2009-04-01','2009-04-21'),
	('Trường Giang','1992-02-15','Đau chân',2,'2009-04-05','2009-04-12'),
	('Tăng Thanh Hà','1987-10-15','Viêm họng',1,'2009-04-12','2009-04-12');

-- =========================================== Làm bài ===========================================

--     a) Hãy thống kê số lượng bệnh nhân theo khoa
SELECT * FROM benhnhan b ;

SELECT k.ma as ma_khoa, k.tenkhoa as ten_khoa, count(*) as tong_benh_nhan FROM benhnhan b 
INNER JOIN khoa k ON b.makhoa = k.ma
GROUP BY ma_khoa;

--     b) Hãy thống kê  số lượng nhân viên theo khoa

SELECT k.ma as ma_khoa , k.tenkhoa ,count(*) as tong_nhan_vien FROM nhanvien n 
INNER JOIN khoa k ON n.makhoa = k.ma
GROUP BY ma_khoa;

--     c) Tạo mới một bảng ảo tên là benhnhankhoanhi gồm đầy đủ thông tin của các bệnh nhân khoa Nhi.

DROP TABLE benhnhankhoanhi;
CREATE TEMPORARY TABLE benhnhankhoanhi
SELECT * FROM benhnhan b INNER JOIN khoa k ON b.makhoa = k.ma WHERE k.ma = 3;

EXPLAIN SELECT * FROM benhnhankhoanhi;

--     d) Tạo mới một thủ tục tên là DSNV liệt kê đầy đủ thông tin về các nhân viên của một khoa nào đó. Thủ tục này có tham số truyền vào là tên một khoa.
 
DROP PROCEDURE DSNV;

CREATE PROCEDURE DSNV(IN tenKhoa VARCHAR(255))
BEGIN
	SELECT * FROM nhanvien n
	INNER JOIN khoa k ON n.makhoa = k.ma
	WHERE k.tenkhoa = tenkhoa;
END;

CALL DSNV('Khoa Ngoại');

--     e) Tạo thủ tục có tên là PSnhanvien với tham số đưa vào là Mã khoa, thông tin trả ra là MaNV, TenNV, Ngay sinh của nhân viên thuộc khoa đó.

DROP PROCEDURE PSnhanvien;

CREATE PROCEDURE PSnhanvien(IN makhoa INT)
BEGIN
	SELECT k.tenkhoa as tenkhoa, manhanvien as MaNV, tennhanvien as TenNV, ngaysinh as 'Ngay sinh' FROM nhanvien nv
	INNER JOIN khoa k ON nv.makhoa = k.ma
	WHERE nv.makhoa  = makhoa;
END;

CALL PSnhanvien (4);

--     f) Tạo trigger thỏa mãn điều kiện không có 2 khoa trùng tên => Đã sử dụng UNIQUE constraint
