#
# Build
#

FROM  golang:stretch as builder

ARG   ROOT_IMPORT_PATH
ARG   CMD_REL_PATH
ARG   BUILD_VERSION=v1.3.0

COPY  . /go/src/${ROOT_IMPORT_PATH}

WORKDIR /go/src/${ROOT_IMPORT_PATH}

RUN   go build -tags netgo -ldflags="-s -w -X ${ROOT_IMPORT_PATH}.Version=${BUILD_VERSION}" -o app ${CMD_REL_PATH}


#
# Main Image
#

FROM  scratch

LABEL maintainer="John Weldon <johnweldon4@gmail.com>" \
      company="John Weldon Consulting" \
      description="Custom CoreDNS"

ARG   ROOT_IMPORT_PATH

COPY  --from=builder /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
COPY  --from=builder /go/src/${ROOT_IMPORT_PATH}/app /app

ENTRYPOINT ["/app"]


