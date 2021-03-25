FROM        scratch
WORKDIR     /go
COPY        bin/service .
ENTRYPOINT  ["/go/service"]
