FROM golang:1.21.3-alpine AS builder
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
ENV \
	SHA=cfbbbbd5514ca2ae15c07a21327631fda8414a44591e823c3197adf603be5d5c \
	VER=1.31.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.3 \
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
