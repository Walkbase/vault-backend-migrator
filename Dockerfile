# defaults which may be overridden from the build command
ARG GO_VERSION=1.13
ARG ALPINE_VERSION=3.11

# build stage
FROM golang:${GO_VERSION}-alpine${ALPINE_VERSION} AS builder

COPY . /go/src/github.com/adamdecaf/vault-backend-migrator
WORKDIR /go/src/github.com/adamdecaf/vault-backend-migrator
RUN go install

# final stage
FROM alpine:${ALPINE_VERSION}

RUN apk update && apk --no-cache add ca-certificates
COPY --from=builder /usr/local/go/lib/time/zoneinfo.zip /usr/local/go/lib/time/zoneinfo.zip
COPY --from=builder /go/bin/vault-backend-migrator /usr/bin/vault-backend-migrator
ENTRYPOINT [ "/usr/bin/vault-backend-migrator" ]
