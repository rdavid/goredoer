FROM golang:1.21.6-alpine AS builder
ENV \
	SHA=5d32ffa2d7c2282e794ec501055a2bb3692016938587eea87a438e69f3a1714b \
	VER=2.6.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.5 \
		zstd~=1.5 \
		&& curl --location --remote-name --silent $URL \
		&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
		&& zstd --decompress < $NME | \
			tar --extract --file - --strip-components=2 goredo-$VER/src \
		&& unset GOPATH \
		&& go build -mod=vendor

FROM alpine:3.19.0
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
COPY --from=builder /go/goredo /
