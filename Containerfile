FROM golang:1.20-rc-alpine AS goredoer
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
RUN \
	apk add --no-cache --update \
		curl~=7.87.0 \
		zstd~=1.5.2 \
		&& rm -rf /var/cache/apk/*
ENV \
	SHA=9a5cdaa2c6fb1986b0d5d7ebfcd97122b0d7506fc30ca3da0578b04461d53c67 \
	VER=1.28.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst

# Set the SHELL option -o pipefail before RUN with a pipe in.
# hadolint ignore=DL4006
RUN \
	curl --location --remote-name --silent $URL \
		&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
		&& zstd --decompress < $NME | tar --extract --file -
WORKDIR /go/goredo-$VER/src
RUN go build -mod=vendor
