BEGIN;

CREATE TABLE
  boundary_types (id INT PRIMARY KEY, "name" TEXT UNIQUE NOT NULL);

INSERT INTO
  boundary_types (id, "name")
VALUES
  (1, 'neighborhood'),
  (2, 'city'),
  (3, 'zip_code'),
  (4, 'county'),
  (5, 'state'),
  (6, 'country'),
  (7, 'school_district'),
  (8, 'school');

COMMIT;
