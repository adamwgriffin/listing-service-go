BEGIN;

-- The unaccent removes accents from Unicode characters, making slugs more consistent.
CREATE EXTENSION unaccent;

-- The function to generate the slug for a listing and avoid duplicates.
CREATE
OR REPLACE FUNCTION generate_unique_slug (
  address_line_1 TEXT,
  address_line_2 TEXT,
  city TEXT,
  state TEXT,
  zip TEXT
) RETURNS TEXT AS $$
DECLARE
  unique_slug TEXT;
  counter INT := 2;
  full_address TEXT;
BEGIN
  full_address := TRIM(
    address_line_1 || ' ' ||
    COALESCE(address_line_2 || ' ', '') || -- Add address2 with a leading space if it's not NULL
    city || ' ' ||
    state || ' ' ||
    zip
  );

  unique_slug := lower(regexp_replace(unaccent(full_address), '\s+', '-', 'g'));

  WHILE EXISTS (SELECT 1 FROM listings WHERE slug = unique_slug) LOOP
    unique_slug := lower(regexp_replace(unaccent(full_address), '\s+', '-', 'g')) || '-' || counter;
    counter := counter + 1;
  END LOOP;

  RETURN unique_slug;
END;
$$ LANGUAGE plpgsql;

-- Function to execute with the trigger
CREATE
OR REPLACE FUNCTION generate_slug_trigger_function () RETURNS TRIGGER AS $$
BEGIN
  NEW.slug := generate_unique_slug(NEW.address_line_1, NEW.address_line_2, NEW.city, NEW.state, NEW.zip);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

COMMIT;
