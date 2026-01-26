# SPDX-FileCopyrightText: 2023-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
FROM golang:1.25.6-alpine AS builder
ENV \
	SHA=81f84b4b4a3c743334f921de516e0f9495da1571df216e1d07714fa6d82f4ee4 \
	VER=2.9.0
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

FROM alpine:3.23.0
LABEL \
	maintainer=David\ Rabkin\ <david@rabkin.co.il> \
	org.opencontainers.image.description='Includes the Goredo utility.' \
	org.opencontainers.image.licenses=0BSD \
	org.opencontainers.image.source=https://github.com/rdavid/goredoer \
	org.opencontainers.image.title=Goredoer \
	org.opencontainers.image.vendor=David\ Rabkin
COPY LICENSES/* /licenses/
COPY --from=builder /go/goredo /
