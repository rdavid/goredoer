FROM golang:1.21.3-alpine AS builder
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
ENV \
	SHA=8ad85be2088a380d1e825dc2bb3f09cf4dc1c09ed3496ba7f0ef28615aeb1137 \
	VER=2.1.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.4 \
		zstd~=1.5 \
		&& rm -rf /var/cache/apk/* \
		&& curl --location --remote-name --silent $URL \
		&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
		&& zstd --decompress < $NME | \
			tar --extract --file - --strip-components=2 goredo-$VER/src \
		&& unset GOPATH \
		&& go build -mod=vendor \
		&& find . ! -path . -type d -exec rm -fr {} + \
		&& find . ! -name goredo -type f -exec rm -f {} +

FROM alpine:3.18.4
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
COPY --from=builder /go/goredo /
