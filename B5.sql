-- Ban lãnh đạo thành phố yêu cầu bạn tạo bảng lưu các con vật trong sở thú
-- Với điều kiện tự bạn quy ước (hãy áp dụng check và default)
CREATE TABLE
  animals (
    id SERIAL,
    name VARCHAR(50),
    legs INT,
    environment VARCHAR(50),
    age FLOAT,
    CONSTRAINT check_legs CHECK (
      legs <= 10
      AND legs >= 0
    ),
    CONSTRAINT check_environment CHECK (environment in ('underwater', 'land', 'air')),
    CONSTRAINT check_age CHECK (age > 0),
    PRIMARY KEY (id)
  );

-- Sở thú hiện có 7 con
INSERT INTO
  animals (name, legs, environment, age)
VALUES
  ('bird', 2, 'air', 3),
  ('dog', 4, 'land', 5),
  ('cat', 4, 'land', 6),
  ('chicken', 2, 'land', 0.5),
  ('fish', 0, 'underwater', 0.5),
  ('snake', 0, 'underwater', 2),
  ('giraffe', 4, 'land', 8),
  ('lion', 4, 'land', 12);

-- Thống kê có bao nhiêu con 4 chân
SELECT
  COUNT(*)
FROM
  animals
WHERE
  legs = 4;

-- Thống kê số con tương ứng với số chân
SELECT
  legs,
  COUNT(legs) as quantity
FROM
  animals
GROUP BY
  legs;

-- Thống kê số con theo môi trường sống
SELECT
  environment,
  COUNT(environment) as animal_quantity
FROM
  animals
GROUP BY
  environment;

-- Thống kê tuổi thọ trung bình theo môi trường sống
SELECT
  environment,
  AVG(age) as age_average
FROM
  animals
GROUP BY
  environment;

-- Lấy ra 3 con có tuổi thọ thọ cao nhất
SELECT
  *
FROM
  animals
ORDER BY
  AGE DESC
LIMIT
  3;

-- (*) Tách những thông tin trên thành 2 bảng cho dễ quản lý (1 môi trường sống gồm nhiều con)
CREATE TABLE
  environment (id SERIAL PRIMARY KEY, name VARCHAR(50) UNIQUE);

INSERT INTO
  environment (name)
VALUES
  ('Landing'),
  ('Underwater'),
  ('Air');

DROP TABLE IF EXIST;

CREATE TABLE
  animals (
    id SERIAL,
    name VARCHAR(50) UNIQUE,
    legs INT,
    environment_id INT,
    age FLOAT,
    CONSTRAINT check_legs CHECK (
      legs <= 10
      AND legs >= 0
    ),
    CONSTRAINT check_age CHECK (age > 0),
    PRIMARY KEY (id),
    FOREIGN KEY (environment_id) REFERENCES environment.id
  );

SELECT
  id,
  name,
  legs,
  age,
  animals.environment_id
FROM
  animals
  JOIN environment ON animals.environment_id = environment.id;