# Build Stage
FROM golang:1.20.4 AS Builder

WORKDIR /app

COPY go.mod ./

RUN go get -d -v ./...

COPY . .

RUN CGO_ENABLED=0 GOOS=linux go build -a -installsuffix cgo -o hello-world .

# Run Stage
FROM alpine:latest 

RUN apk --no-cache add ca-certificates

WORKDIR /root/

# Copying the binary of the application from the builder stage.
COPY --from=Builder /app/hello-world .

ENV PORT=3000
ENTRYPOINT ["./hello-world"]