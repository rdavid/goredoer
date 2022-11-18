FROM golang:1.19.3-alpine AS goredoer
LABEL maintainer="David Rabkin <david@rabkin.co.il>"
RUN \
	apk add --no-cache --update \
		zstd~=1.5.2 \
		&& rm -rf /var/cache/apk/*
ENV \
	SHA=9a5cdaa2c6fb1986b0d5d7ebfcd97122b0d7506fc30ca3da0578b04461d53c67 \
	VER=1.28.0

# DL4006 is a bashism.
# Set the SHELL option -o pipefail before RUN with a pipe in.
# hadolint ignore=DL4006
RUN \
	wget --quiet \
		http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst \
		&& printf '%s  %s' $SHA goredo-$VER.tar.zst | sha256sum -cs \
		&& zstd --decompress < goredo-$VER.tar.zst | tar --extract --file -
WORKDIR /go/goredo-$VER/src
RUN go build -mod=vendor
