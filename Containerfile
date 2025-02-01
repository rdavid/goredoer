FROM golang:1.23.5-alpine AS builder
ENV \
	SHA=0e53b444a6eb9c5a13088cd680e2e697a5a0e059710c1ad8e30879fe9dc0770c \
	VER=2.6.4
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.su/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.11 \
		zstd~=1.5 \
	&& curl --location --remote-name --silent $URL \
	&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
	&& zstd --decompress < $NME | \
		tar --extract --file - --strip-components=2 goredo-$VER/src \
	&& unset GOPATH \
	&& go build -mod=vendor

FROM alpine:3.21.2
LABEL \
	maintainer=David\ Rabkin\ <david@rabkin.co.il> \
	org.opencontainers.image.description='Includes the Goredo utility.' \
	org.opencontainers.image.licenses=0BSD \
	org.opencontainers.image.source=https://github.com/rdavid/goredoer \
	org.opencontainers.image.title=Goredoer \
	org.opencontainers.image.vendor=David\ Rabkin
COPY LICENSE /licenses/LICENSE
COPY --from=builder /go/goredo /
