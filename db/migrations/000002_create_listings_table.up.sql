CREATE TABLE IF NOT EXISTS listings (
  id SERIAL PRIMARY KEY,
  line1 TEXT NOT NULL,
  geom GEOMETRY(POINT, 4326) NOT NULL,
  neighborhood text,
  view BOOLEAN NOT NULL DEFAULT false,
  waterfront BOOLEAN NOT NULL DEFAULT false
);

CREATE INDEX listings_geom_idx ON listings USING GIST(geom);
