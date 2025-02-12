migrateup:
	docker-compose exec app sh -c 'migrate -database $$DATABASE_URL -path db/migrations -verbose up'

migratedown:
	docker-compose exec app sh -c 'migrate -database $$DATABASE_URL -path db/migrations -verbose down'

.PHONY: migrateup migratedown
