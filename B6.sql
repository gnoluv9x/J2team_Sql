-- Tạo cơ sở dữ liệu để lưu thông tin kinh doanh của 1 cửa hàng
-- Yêu cầu có đủ:
-- thông tin khách hàng
-- thông tin sản phẩm
-- thông tin hoá đơn
--  =============== CREAT TABLE ===============
CREATE TABLE
  shop_customer (
    id SERIAL,
    name VARCHAR(50),
    year_of_birth CHAR(4),
    phone CHAR(12) UNIQUE,
    PRIMARY KEY (id)
  );

CREATE TABLE
  shop_product (
    id SERIAL,
    name VARCHAR(50),
    type VARCHAR(50),
    price INT,
    category VARCHAR(50),
    PRIMARY KEY (id)
  );

CREATE TABLE
  shop_invoice (
    id SERIAL,
    quantity INT,
    product_id INT,
    customer_id INT,
    PRIMARY KEY (id),
    CONSTRAINT fk_product FOREIGN KEY (product_id) REFERENCES shop_product (id),
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES shop_customer (id),
  );

--  =============== INSERT ===============
INSERT INTO
  shop_customer (name, year_of_birth, phone)
VALUES
  ('Trang', '1998', '0372667055');

INSERT INTO
  shop_product (name, type, price, category)
VALUES
  ('Áo Gucci', 'áo', 5000000, 'Thời trang');

INSERT INTO
  shop_invoice (quantity, product_id, customer_id)
VALUES
  (3, 2, 1);

--  =============== SELECT ===============
SELECT
  shop_invoice.id,
  shop_invoice.quantity,
  shop_product."name",
  shop_product.price,
  shop_customer."name" AS customer_name,
  shop_customer.phone AS customer_phone
FROM
  shop_invoice
  JOIN shop_product ON shop_invoice.product_id = shop_product.id
  JOIN shop_customer ON shop_invoice.customer_id = shop_customer.id;