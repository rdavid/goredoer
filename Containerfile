FROM golang:1.21.5-alpine AS builder
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
ENV \
	SHA=915c421d743d3e368b62f881f2c7fca078859e2c8dac730ee82fea4998632bb9 \
	VER=2.5.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.5 \
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

FROM alpine:3.19.0
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
COPY --from=builder /go/goredo /
