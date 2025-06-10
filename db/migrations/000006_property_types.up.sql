BEGIN;

-- We're not adding SERIAL to the id because we want it to be a constant that is
-- always the same.
CREATE TABLE
  property_types (
    id INT PRIMARY KEY,
    "name" TEXT UNIQUE NOT NULL,
    "label" TEXT NOT NULL
  );

INSERT INTO
  property_types (id, "name", "label")
VALUES
  (1, 'single-family', 'House'),
  (2, 'condo', 'Condo'),
  (3, 'townhouse', 'Townhouse'),
  (4, 'manufactured', 'Manufactured'),
  (5, 'land', 'Land'),
  (6, 'multi-family', 'Multi-Family');

COMMIT;
