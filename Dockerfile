ARG GO_VERSION
FROM golang:${GO_VERSION:-1.13.0}

RUN \
    apt-get update \
      && apt-get install -y --no-install-recommends \
         zip \
      && rm -rf /var/lib/apt/lists/*

COPY ./ /go/src/github.com/elastic/integrations-registry
EXPOSE 8080

WORKDIR "/go/src/github.com/elastic/integrations-registry"

ENV GO111MODULE=on
RUN go mod vendor
RUN go get -u github.com/magefile/mage
RUN mage build

# This directory contains the packages at the moment but is only used during the build process
# If we keep it, it means all packages exist twice.
RUN rm -rf dev

ENTRYPOINT ["go", "run", "."]
# Make sure it's accessible from outside the container
CMD ["--address=0.0.0.0:8080"]
