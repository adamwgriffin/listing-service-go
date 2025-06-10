FROM golang:alpine

WORKDIR /app

RUN go install github.com/air-verse/air@latest \
  && go install -tags 'postgres' github.com/golang-migrate/migrate/v4/cmd/migrate@latest

COPY go.mod go.sum ./
RUN go mod download

CMD ["air", "-c", ".air.toml"]
