FROM golang:1.19-alpine AS goredoer
LABEL maintainer="David Rabkin <david@rabkin.co.il>"
RUN \
	apk add --no-cache --update \
		zstd~=1.5 && \
	rm -rf /var/cache/apk/*
ENV \
	SHA=63cfdb24f14ec7071b5bb8ed237023410826ea9f21d48e8e6c9f43ae2af34176 \
	VER=1.27.0

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
