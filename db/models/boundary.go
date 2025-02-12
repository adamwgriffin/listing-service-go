package db

type Boundary struct {
	ID      uint   `gorm:"primaryKey"`
	PlaceID string `gorm:"uniqueIndex;not null"`
	Name    string `gorm:"not null"`
	Type    string `gorm:"not null;check:type IN ('neighborhood','city','zip_code','county','state','country','school_district','school')"`
	Geom    string `gorm:"type:geometry(MULTIPOLYGON,4326);not null"`
}
