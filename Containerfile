# SPDX-FileCopyrightText: 2023-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
FROM golang:1.25.6-alpine AS builder
ENV \
	SHA=dc668707f17b80a62e963e14c05b266f9445e6c88ed137d4108fa8b3833557ad \
	VER=2.9.1
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.cypherpunks.su/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl~=8.17 \
		zstd~=1.5 \
	&& curl --location --remote-name --silent $URL \
	&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
	&& zstd --decompress < $NME | \
		tar --extract --file - --strip-components=2 goredo-$VER/src \
	&& unset GOPATH \
	&& go build -mod=vendor

FROM alpine:3.23.3
LABEL \
	maintainer=David\ Rabkin\ <david@rabkin.co.il> \
	org.opencontainers.image.description='Includes the Goredo utility.' \
	org.opencontainers.image.licenses=0BSD \
	org.opencontainers.image.source=https://github.com/rdavid/goredoer \
	org.opencontainers.image.title=Goredoer \
	org.opencontainers.image.vendor=David\ Rabkin
COPY LICENSES/* /licenses/
COPY --from=builder /go/goredo /
