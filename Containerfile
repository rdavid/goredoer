FROM golang:1.19.1-alpine AS goredoer
LABEL maintainer="David Rabkin <david@rabkin.co.il>"
RUN \
	apk add --no-cache --update \
		zstd~=1.5.2 && \
	rm -rf /var/cache/apk/*
ENV \
	SHA=98c1a8a189b33753fcd61e1dbdbe627dba3820621d2032a3856d89829eea08d9 \
	VER=1.27.1

# DL4006 is a bashism.
# Set the SHELL option -o pipefail before RUN with a pipe in.
# hadolint ignore=DL4006
RUN \
	wget --quiet \
		http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst && \
		printf '%s  %s' $SHA goredo-$VER.tar.zst | sha256sum -cs && \
	zstd --decompress < goredo-$VER.tar.zst | tar --extract --file -
WORKDIR /go/goredo-$VER/src
RUN go build -mod=vendor
