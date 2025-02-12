package main

import (
	"listing-service/db"
	"listing-service/lib"
	"listing-service/routes"
	"log"

	"github.com/gin-gonic/gin"
)

func main() {
	config, err := lib.LoadConfig(".")
	if err != nil {
		log.Fatal("Cannot load config")
	}
	db.ConnectDB(config.DatabaseURL)

	router := gin.Default()
	routes.HealthcheckRoutes(router)
	routes.ListingRoutes(router)
	router.Run(config.ServerAddress)
}
