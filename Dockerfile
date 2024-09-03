# Use the official Golang image to build the application
FROM golang:1.21.4 AS build

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application
RUN go build -o main .

# Use a smaller base image for the final stage
FROM busybox:latest

# Set the working directory
WORKDIR /root/

# Copy the built binary from the build stage
COPY --from=build /app/main .

# Make the binary executable
RUN chmod +x /root/main

# Expose the port the app runs on
EXPOSE 8080

# Run the Go binary
CMD ["./main"]
