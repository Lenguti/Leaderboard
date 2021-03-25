FROM        scratch
WORKDIR     /go
COPY        src/service .
ENTRYPOINT  ["/go/service"]
