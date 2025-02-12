package handlers

import (
	"encoding/json"
	"listing-service/db"
	"net/http"

	"github.com/gin-gonic/gin"
)

type ListingQueryResult struct {
	ID           uint            `json:"id"`
	Line1        string          `json:"line1"`
	Geometry     json.RawMessage `json:"geometry"`
	Neighborhood *string         `json:"neighborhood"`
	View         bool            `json:"view"`
	Waterfront   bool            `json:"waterfront"`
}

var booleanFilters = map[string]string{
	"waterfront": "waterfront",
	"view":       "view",
}

func GetListingsInsideBoundary(ctx *gin.Context) {
	placeID := ctx.Param("place_id")

	query := db.Database.Table("listings l").
		Select(`l.id, l.line1, ST_AsGeoJSON(l.geom, 15)::json AS "geometry", l.neighborhood, l.view, l.waterfront`).
		Joins("JOIN boundaries b ON ST_Contains(b.geom, l.geom)").
		Where("b.place_id = ?", placeID)

	for param, column := range booleanFilters {
		if value, exists := ctx.GetQuery(param); exists {
			query = query.Where(column+" = ?", value == "true")
		}
	}

	var results []ListingQueryResult

	err := query.Scan(&results).Error
	if err != nil {
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}

	ctx.JSON(http.StatusOK, results)
}
