FROM golang:1.22.2-alpine

# Install curl
RUN apk add --no-cache curl

# Create a directory for your application
WORKDIR /app

# Copy your go file and go.mod (and go.sum if exists) into the image
COPY pgproxy.go go.mod go.sum* /app/

# Download dependencies
RUN go mod download

# Build your Go application
RUN go build -o pgproxy pgproxy.go

# Create a directory for tailscale-state
RUN mkdir /app/tailscale-state

# Download the cacert.pem file if the ETag has changed
RUN curl --etag-compare etag.txt --etag-save etag.txt --remote-name https://curl.se/ca/cacert.pem

# Set up the entrypoint for the container
ENTRYPOINT ["/bin/sh", "-c", "FIXIE_SOCKS_HOST=$FIXIE_SOCKS_HOST TS_AUTHKEY=$TAILSCALE_AUTHKEY ./pgproxy --hostname $TAILSCALE_HOSTNAME --upstream-addr $DB_HOST --upstream-ca-file /app/cacert.pem --state-dir /app/tailscale-state"]

