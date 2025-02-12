CREATE TABLE IF NOT EXISTS boundaries (
  id SERIAL PRIMARY KEY,
  place_id TEXT UNIQUE NOT NULL,
  name TEXT NOT NULL,
  type TEXT CHECK (
    type IN (
      'neighborhood',
      'city',
      'zip_code',
      'county',
      'state',
      'country',
      'school_district',
      'school'
    )
  ) NOT NULL,
  geom GEOMETRY(MULTIPOLYGON, 4326) NOT NULL
);

COMMENT ON COLUMN boundaries.place_id IS 'The Google Maps geocoder place_id.';

COMMENT ON COLUMN boundaries.geom IS 'Using SRID 4326 ensures compatibility with GeoJSON (WGS 84)';

CREATE INDEX boundaries_geom_idx ON boundaries USING GIST(geom);
