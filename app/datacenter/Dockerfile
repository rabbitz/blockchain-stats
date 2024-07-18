FROM golang:alpine AS builder

LABEL stage=gobuilder

ENV CGO_ENABLED 1

RUN apk update --no-cache && apk add --no-cache tzdata
RUN apk --update --no-cache add g++

WORKDIR /build

ADD go.mod .
ADD go.sum .
RUN go mod download
COPY .. .
COPY app/datacenter/etc /app/etc
RUN go build -ldflags="-s -w" -o /app/datacenter app/datacenter/datacenter.go

FROM alpine:latest

COPY --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/ca-certificates.crt
COPY --from=builder /usr/share/zoneinfo/UTC /usr/share/zoneinfo/UTC
ENV TZ UTC

WORKDIR /app
COPY --from=builder /app/datacenter /app/datacenter
COPY --from=builder /app/etc /app/etc

CMD ["./datacenter", "-f", "etc/datacenter-api.yaml"]
