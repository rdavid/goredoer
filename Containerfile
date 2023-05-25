FROM golang:1.20.4-alpine
LABEL maintainer=David\ Rabkin\ <david@rabkin.co.il>
COPY LICENSE /licenses/LICENSE
ENV \
	SHA=825b20daaf2315de33e82b8ace567769f271fd2ec0c3a2c2c45012fee1cb9548 \
	VER=1.30.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.ru/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.1.1 \
		zstd~=1.5.5 \
		&& rm -rf /var/cache/apk/* \
		&& curl --location --remote-name --silent $URL \
		&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
		&& zstd --decompress < $NME | \
			tar --extract --file - --strip-components=2 goredo-$VER/src \
		&& unset GOPATH \
		&& go build -mod=vendor \
		&& find . ! -path . -type d -exec rm -fr {} + \
		&& find . ! -name goredo -type f -exec rm -f {} +
