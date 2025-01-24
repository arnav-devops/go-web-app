# Base stage with Golang
FROM golang:1.22.5 AS base

WORKDIR /app

# Copy and download Go modules
COPY go.mod ./
RUN go mod download

# Copy the source code
COPY . ./

# Build the Go application
RUN go build -o main .

# Final stage with Distroless image
FROM gcr.io/distroless/base

WORKDIR /

# Copy the built binary and static files from the base stage
COPY --from=base /app/main .
COPY --from=base /app/static ./static

# Expose the application port
EXPOSE 8081

# Command to run the application
CMD ["./main"]
