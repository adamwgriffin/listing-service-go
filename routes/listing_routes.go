package routes

import (
	"listing-service/handlers"

	"github.com/gin-gonic/gin"
)

func ListingRoutes(router *gin.Engine) {
	listingGroup := router.Group("/listing/search")
	listingGroup.GET("/boundary/:place_id", handlers.GetListingsInsideBoundary)
}
