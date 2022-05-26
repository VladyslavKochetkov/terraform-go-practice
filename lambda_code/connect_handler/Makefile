build:
	echo "Building testing_go lambda"
	GOOS=linux CGO_ENABLED=0 go build -o ./bin/main ./cmd/main.go
	zip -9jr lambda_source.zip ./bin/main