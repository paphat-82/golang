# Use a specific version of the Go image to avoid unintended updates
FROM golang:1.21.4 AS build

# Set the working directory
WORKDIR /app

# Copy only necessary files
COPY go.mod go.sum ./

# Download dependencies
RUN go mod download

# Copy the rest of the application code
COPY . .

# Build the Go application with optimizations
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Use a smaller and more secure base image for the final stage
FROM busybox:stable-glibc

# Set the working directory
WORKDIR /root/

# Copy the built binary from the build stage
COPY --from=build /app/main .

# Make the binary executable
RUN chmod +x /root/main

# Expose the necessary port
EXPOSE 8080

# Run the Go binary as a non-root user if possible
USER nobody

# Run the Go binary
CMD ["./main"]
