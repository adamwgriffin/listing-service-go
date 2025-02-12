package routes

import (
	"listing-service/handlers"

	"github.com/gin-gonic/gin"
)

func HealthcheckRoutes(router *gin.Engine) {
	router.GET("/ping", handlers.Ping)
}
