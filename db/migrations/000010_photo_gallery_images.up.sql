CREATE TABLE
  photo_gallery_images (
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    photo_gallery_id INT NOT NULL,
    "url" TEXT NOT NULL,
    caption TEXT,
    "position" INT NOT NULL,
    CONSTRAINT unique_gallery_position UNIQUE (photo_gallery_id, "position"),
    FOREIGN KEY (photo_gallery_id) REFERENCES photo_galleries (id) ON DELETE CASCADE
  );
