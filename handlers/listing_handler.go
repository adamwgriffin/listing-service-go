package handlers

import (
	"encoding/json"
	"listing-service/db"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ListingQueryResult struct {
	ID            int64
	Slug          string
	ListPrice     uint
	ListedDate    string
	AddressLine_1 string
	AddressLine_2 string
	City          string
	State         string
	Zip           string
	Latitude      float64
	Longitude     float64
	PlaceId       string
	Neighborhood  string
	Status        string
	Description   string
	Beds          uint
	Baths         uint
	Sqft          uint
	LotSize       uint
	View          bool
	Waterfront    bool
	PhotoGallery  json.RawMessage
}

type ListingAddress struct {
	Line1 string `json:"line1"`
	Line2 string `json:"line2"`
	City  string `json:"city"`
	State string `json:"state"`
	Zip   string `json:"zip"`
}

type ListingResponse struct {
	ID           int64           `json:"id"`
	Slug         string          `json:"slug"`
	ListPrice    uint            `json:"listPrice"`
	ListedDate   string          `json:"listedDate"`
	Address      ListingAddress  `json:"address"`
	Latitude     float64         `json:"latitude"`
	Longitude    float64         `json:"longitude"`
	PlaceId      string          `json:"placeId"`
	Neighborhood string          `json:"neighborhood"`
	Status       string          `json:"status"`
	Description  string          `json:"description"`
	Beds         uint            `json:"beds"`
	Baths        uint            `json:"baths"`
	Sqft         uint            `json:"sqft"`
	LotSize      uint            `json:"lotSize"`
	View         bool            `json:"view"`
	Waterfront   bool            `json:"waterfront"`
	PhotoGallery json.RawMessage `json:"photoGallery"`
}

var booleanFilters = map[string]string{
	"waterfront": "waterfront",
	"view":       "view",
}

func GetListingsInsideBoundary(ctx *gin.Context) {
	placeID := ctx.Param("place_id")

	query := db.Database.Table("listings l").
		Select(
			"l.id",
			"l.slug",
			"l.list_price",
			"l.listed_date",
			"l.address_line_1",
			"l.address_line_2",
			"l.city",
			"l.state",
			"l.zip",
			"ST_Y(l.geom) AS latitude",
			"ST_X(l.geom) AS longitude",
			"l.place_id",
			"l.neighborhood",
			`ls.name AS "status"`,
			"l.description",
			"l.beds",
			"l.baths",
			"l.sqft",
			"l.lot_size",
			"l.view",
			"l.waterfront",
			"COALESCE(pg_agg.photo_gallery, '[]') AS photo_gallery",
		).
		Joins("JOIN boundaries b ON ST_Contains(b.geom, l.geom)").
		Joins("LEFT JOIN listing_statuses ls ON l.listing_status_id = ls.id").
		Joins(`
			LEFT JOIN LATERAL (
				SELECT
					jsonb_agg(
						jsonb_build_object('url', pgi.url, 'caption', pgi.caption)
					) AS photo_gallery
				FROM
					photo_galleries pg
					JOIN photo_gallery_images pgi ON pg.id = pgi.photo_gallery_id
				WHERE
					pg.listing_id = l.id
			) AS pg_agg ON TRUE
		`).
		Where("b.place_id = ?", placeID)

	for param, column := range booleanFilters {
		if value, exists := ctx.GetQuery(param); exists {
			query = query.Where(column+" = ?", value == "true")
		}
	}

	var results []ListingQueryResult
	var response []ListingResponse

	err := query.Scan(&results).Error
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	for _, l := range results {
		r := ListingResponse{
			ID:           l.ID,
			Slug:         l.Slug,
			ListPrice:    l.ListPrice,
			ListedDate:   l.ListedDate,
			Latitude:     l.Latitude,
			Longitude:    l.Longitude,
			PlaceId:      l.PlaceId,
			Neighborhood: l.Neighborhood,
			Status:       l.Status,
			Description:  l.Description,
			Beds:         l.Beds,
			Baths:        l.Baths,
			Sqft:         l.Sqft,
			LotSize:      l.LotSize,
			View:         l.View,
			Waterfront:   l.Waterfront,
			PhotoGallery: l.PhotoGallery,
		}
		r.Address.Line1 = l.AddressLine_1
		r.Address.Line2 = l.AddressLine_2
		r.Address.City = l.City
		r.Address.State = l.State
		r.Address.Zip = l.Zip

		response = append(response, r)
	}

	ctx.JSON(http.StatusOK, response)
}
