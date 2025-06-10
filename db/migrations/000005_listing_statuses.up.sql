BEGIN;

CREATE TABLE
  listing_statuses (
    id INT PRIMARY KEY,
    "name" TEXT UNIQUE NOT NULL,
    "label" TEXT NOT NULL
  );

INSERT INTO
  listing_statuses (id, "name", "label")
VALUES
  (1, 'active', 'Active'),
  (2, 'pending', 'Pending'),
  (3, 'sold', 'Sold'),
  (4, 'rented', 'Rented');

COMMIT;
