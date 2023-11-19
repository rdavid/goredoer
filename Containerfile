FROM golang:1.21.4-alpine AS builder
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
ENV \
	SHA=a140bf37a34b11506b142ded484b16117501979a3264d9aa45315615b80bfb38 \
	VER=2.4.0
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
