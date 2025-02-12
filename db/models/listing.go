package db

type Listing struct {
	ID           uint    `gorm:"primaryKey"`
	Line1        string  `gorm:"not null"`
	Geom         string  `gorm:"type:geometry(POINT,4326);not null"`
	Neighborhood *string `gorm:"column:neighborhood_name"`
	View         bool    `gorm:"not null"`
	Waterfront   bool    `gorm:"not null"`
}
