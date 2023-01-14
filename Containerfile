FROM golang:1.20-rc-alpine
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
ENV \
	SHA=9a5cdaa2c6fb1986b0d5d7ebfcd97122b0d7506fc30ca3da0578b04461d53c67 \
	VER=1.28.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=7.87.0 \
		zstd~=1.5.2 \
		&& rm -rf /var/cache/apk/* \
		&& curl --location --remote-name --silent $URL \
		&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
		&& zstd --decompress < $NME | tar --extract --file -
WORKDIR /go/goredo-$VER/src
RUN go build -mod=vendor
