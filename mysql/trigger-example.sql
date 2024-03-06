SHOW TABLES;

-- Có 2 bảng
-- Kho (mã, tên, tổng tài sản, sức chứa)
DROP TABLE store;

CREATE TABLE store(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) UNIQUE,
	total_assets INT DEFAULT 0,
	capacity INT DEFAULT 5,
	PRIMARY KEY(id)
);

DELETE FROM store ;
INSERT INTO store (name) VALUES('Household_equipment'),('Office'),('Food');

-- Sản phẩm (mã, tên, số lượng, giá trị, mã kho)
DROP TABLE products;

CREATE TABLE products(
	id INT NOT NULL AUTO_INCREMENT,
	name VARCHAR(50) NOT NULL UNIQUE,
	quantity INT,
	price INT,
	store_id INT NOT NULL,
	PRIMARY KEY(id),
	FOREIGN KEY (store_id) REFERENCES store(id)
);

-- Trước khi insert sp vào kho thì kiểm tra chỗ trống trong kho
CREATE TRIGGER trigger_check_store_capacity
BEFORE INSERT 
ON products
FOR EACH ROW
BEGIN 
	DECLARE capactity_available INT;
	SET capactity_available = (SELECT capacity FROM store s WHERE s.id = NEW.store_id);

	IF capactity_available <= 0  THEN
		SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Kho đã đầy';
   END IF;
END;

-- Sau khi thêm sp vào kho thì cập nhật lại tổng tài sản và sức chứa cho kho
DROP TRIGGER trigger_update_assets_store;
CREATE TRIGGER trigger_update_assets_store
AFTER INSERT 
ON products
FOR EACH ROW
BEGIN 
	UPDATE store
	SET total_assets = total_assets +  (NEW.quantity * NEW.price),capacity = capacity - NEW.quantity
	WHERE id = NEW.store_id;
END;

-- Tạo procedure để thêm và hiển thị lại giá trị vừa thêm ở từng bảng
CREATE PROCEDURE add_product(
    IN product_name VARCHAR(50),
    IN product_quantity INT,
    IN product_price INT,
    IN store_name VARCHAR(50)
)
BEGIN
    DECLARE store_id INT;
    
    -- Thêm dữ liệu vào bảng store nếu chưa tồn tại
    INSERT INTO store(name)
    VALUES (store_name)
    ON DUPLICATE KEY UPDATE name = store_name;
    
    -- Lấy store_id của cửa hàng
    SELECT id INTO store_id FROM store WHERE name = store_name;
    
    -- Thêm dữ liệu vào bảng products
    INSERT INTO products(name, quantity, price, store_id)
    VALUES (product_name, product_quantity, product_price, store_id);
    
    -- Hiển thị giá trị mới thêm vào từng bảng
    SELECT * FROM store WHERE id = store_id;
    SELECT * FROM products WHERE name = product_name;
END;

-- Tạo trigger phù hợp để:
-- Khi cập nhật sản phẩm thì cập nhật tổng tài sản tương ứng với kho
CREATE TRIGGER trigger_after_update_assets_store
AFTER UPDATE 
ON products
FOR EACH ROW
BEGIN 
	UPDATE store
	SET total_assets = total_assets - (OLD.quantity * OLD.price)
	WHERE id = OLD.store_id;
	
	UPDATE store
	SET total_assets = total_assets  + (NEW.quantity * NEW.price)
	WHERE id = NEW.store_id;
END;

-- Khi xoá kho thì kiểm tra sản phẩm có tồn tại không, nếu không mới được xoá
DROP TRIGGER trigger_check_product_before_delete;
CREATE TRIGGER trigger_check_product_before_delete
BEFORE DELETE
ON store
FOR EACH ROW
BEGIN 
	DECLARE total_products_in_current_store INT;
	
	SET total_products_in_current_store = (SELECT count(*) FROM products p WHERE p.store_id = OLD.id);
	
	IF total_products_in_current_store > 0 THEN
		SIGNAL SQLSTATE '45000' 
    SET MESSAGE_TEXT = 'Không thể xoá kho đang chứa sản phẩm';
	END IF;
END;

-- ============================ TEST ============================================
SELECT * FROM store;
SELECT store.id as store_id, store.capacity as store_capacity FROM products p 
RIGHT JOIN store ON p.store_id = store.id GROUP BY store.id;

INSERT INTO products(store_id,name,quantity,price)
VALUES
	(1,'Chair',2,75000);

SELECT count(*) as total_products, store_id FROM products p
WHERE p.store_id = 1;

DELETE FROM store WHERE id = 2;

SELECT count(*) FROM products p WHERE p.store_id = 3;





