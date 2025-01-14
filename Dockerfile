# Copyright 2022 - offen.software <hioffen@posteo.de>
# SPDX-License-Identifier: MPL-2.0

FROM golang:1.23-alpine as builder

WORKDIR /app

## Cache dependencies:
COPY go.mod go.sum ./
RUN apk add --no-cache git && go mod download

# Copy and build source files:
COPY . .
WORKDIR /app/cmd/backup
RUN go build -o backup .

FROM alpine:3.20

WORKDIR /root

RUN apk add --no-cache ca-certificates && \
  chmod a+rw /var/lock

COPY --from=builder /app/cmd/backup/backup /usr/bin/backup

ENTRYPOINT ["/usr/bin/backup", "-foreground"]
