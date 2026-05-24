FROM golang:1.24-alpine AS builder

WORKDIR /app

COPY go.mod .
COPY go.sum .

RUN go mod download

COPY . .

RUN go build -o usque -ldflags="-s -w" .

# scratch won't be enough, because we need a cert store
FROM alpine:latest

# Keep ca-certificates up to date for TLS connections
RUN apk --no-cache add ca-certificates && update-ca-certificates

WORKDIR /app

COPY --from=builder /app/usque /bin/usque

# Add tzdata so the container can handle timezone-aware logging if needed
RUN apk --no-cache add tzdata

# Run as non-root user for better security
RUN adduser -D -u 1000 appuser
USER appuser

ENTRYPOINT ["/bin/usque"]
