BEGIN;

CREATE TABLE
  listings (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    place_id TEXT,
    slug TEXT UNIQUE NOT NULL,
    address_line_1 TEXT NOT NULL,
    address_line_2 TEXT,
    city TEXT NOT NULL,
    "state" TEXT NOT NULL CHECK (LENGTH(state) = 2),
    zip TEXT NOT NULL,
    geom GEOMETRY (POINT, 4326) NOT NULL,
    neighborhood TEXT,
    list_price INT NOT NULL,
    sold_price INT,
    listed_date TIMESTAMP WITH TIME ZONE NOT NULL,
    sold_date TIMESTAMP WITH TIME ZONE,
    property_type_id INT NOT NULL,
    listing_status_id INT NOT NULL,
    "description" TEXT,
    beds INT NOT NULL DEFAULT 0,
    baths INT NOT NULL DEFAULT 0,
    sqft INT,
    lot_size INT,
    year_built INT,
    rental BOOLEAN NOT NULL DEFAULT FALSE,
    waterfront BOOLEAN NOT NULL DEFAULT FALSE,
    "view" BOOLEAN NOT NULL DEFAULT FALSE,
    fireplace BOOLEAN NOT NULL DEFAULT FALSE,
    basement BOOLEAN NOT NULL DEFAULT FALSE,
    garage BOOLEAN NOT NULL DEFAULT FALSE,
    new_construction BOOLEAN NOT NULL DEFAULT FALSE,
    "pool" BOOLEAN NOT NULL DEFAULT FALSE,
    air_conditioning BOOLEAN NOT NULL DEFAULT FALSE,
    FOREIGN KEY (property_type_id) REFERENCES property_types (id),
    FOREIGN KEY (listing_status_id) REFERENCES listing_statuses (id),
    property_details JSONB NOT NULL DEFAULT '[]'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP NOT NULL
  );

COMMENT ON COLUMN listings.place_id IS 'The Google Maps geocoder place_id.';

COMMENT ON COLUMN listings.geom IS 'The lat/lng for the listing. Using SRID 4326 ensures compatibility with GeoJSON (WGS 84)';

CREATE INDEX listings_geom_idx ON listings USING GIST (geom);

CREATE INDEX listings_place_id_idx ON listings (place_id);

CREATE TRIGGER listings_set_updated_at_trigger BEFORE
UPDATE ON listings FOR EACH ROW
EXECUTE FUNCTION set_updated_at ();

-- Trigger definition (same as before)
CREATE TRIGGER generate_slug_trigger BEFORE INSERT
OR
UPDATE ON listings FOR EACH ROW
EXECUTE PROCEDURE generate_slug_trigger_function ();

COMMIT;
