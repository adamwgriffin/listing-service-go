db-dump:
	docker compose exec database sh -c 'pg_dump -U $$POSTGRES_USER $$POSTGRES_DB > /docker-entrypoint-initdb.d/db_dump.sql'

migrateup:
	docker-compose exec app sh -c 'migrate -database $$DATABASE_URL -path db/migrations -verbose up'

migratedown:
	docker-compose exec app sh -c 'migrate -database $$DATABASE_URL -path db/migrations -verbose down'

.PHONY: migrateup migratedown db-dump
