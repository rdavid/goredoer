# SPDX-FileCopyrightText: 2023-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
FROM golang:1.27-alpine AS builder
ENV \
	SHA=9229effbd8add272b489af12d96f0037c156cb575137d9cdcd5786f27e1a6364 \
	VER=2.10.0
ENV \
	NME=goredo-$VER.tar.zst \
	URL=http://www.goredo.stargrave.org/download/goredo-$VER.tar.zst
SHELL ["/bin/ash", "-eo", "pipefail", "-c"]
RUN \
	apk add --no-cache --update \
		curl=8.22.0-r0 \
		zstd=1.5.7-r2 \
	&& curl --location --remote-name --silent $URL \
	&& printf %s\ \ %s $SHA $NME | sha256sum -cs \
	&& zstd --decompress < $NME | \
		tar --extract --file - --strip-components=2 goredo-$VER/src \
	&& unset GOPATH \
	&& go build -mod=vendor

FROM alpine:3.24.1
LABEL \
	maintainer=David\ Rabkin\ <david@rabkin.co.il> \
	org.opencontainers.image.description='Includes the Goredo utility' \
	org.opencontainers.image.licenses=0BSD \
	org.opencontainers.image.source=https://github.com/rdavid/goredoer \
	org.opencontainers.image.title=Goredoer \
	org.opencontainers.image.vendor=David\ Rabkin
COPY LICENSES/* /licenses/
COPY --from=builder /go/goredo /
