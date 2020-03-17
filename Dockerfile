#
# Build
#

FROM  golang:stretch as builder

ARG   ROOT_IMPORT_PATH
ARG   CMD_REL_PATH
ARG   BUILD_VERSION=v0.0.1
ARG   GO111MODULE=on

COPY  . /go/src/${ROOT_IMPORT_PATH}

WORKDIR /go/src/${ROOT_IMPORT_PATH}

RUN   CGO_ENABLED=0 \
      go build -a \
        -mod=vendor \
        -tags netgo \
        -ldflags="-s -w -extldflags -static -X ${ROOT_IMPORT_PATH}.Version=${BUILD_VERSION}" \
        -o app ${CMD_REL_PATH}


#
# Main Image
#

FROM  scratch

LABEL maintainer="John Weldon <john@tempusbreve.com>" \
      company="Tempus Breve Software" \
      description="Custom CoreDNS"

ARG   ROOT_IMPORT_PATH

COPY  --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY  --from=builder /go/src/${ROOT_IMPORT_PATH}/app /app

ENTRYPOINT ["/app"]

