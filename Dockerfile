FROM golang:1.17 AS builder
ENV CGO_ENABLED 0
ADD . /app
WORKDIR /app
RUN go build -ldflags "-s -w" -v -o domain-exporter .

FROM alpine:3
RUN apk update && \
    apk add openssl && \
    rm -rf /var/cache/apk/* \
    && mkdir /app

WORKDIR /app

ADD Dockerfile /Dockerfile

COPY --from=builder /app/domain-exporter /app/domain-exporter

RUN chown nobody /app/domain-exporter \
    && chmod 500 /app/domain-exporter

USER nobody

ENTRYPOINT ["/app/domain-exporter"]