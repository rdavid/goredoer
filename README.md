# Goredoer

[![linters](https://github.com/rdavid/goredoer/actions/workflows/lint.yml/badge.svg)](https://github.com/rdavid/goredoer/actions/workflows/lint.yml)
[![publisher](https://github.com/rdavid/goredoer/actions/workflows/publish.yml/badge.svg)](https://github.com/rdavid/goredoer/actions/workflows/publish.yml)
[![hits of code](https://hitsofcode.com/github/rdavid/goredoer?branch=master&label=hits%20of%20code)](https://hitsofcode.com/view/github/rdavid/goredoer?branch=master)
[![release)](https://img.shields.io/github/v/release/rdavid/goredoer?color=blue&label=%20&logo=semver&logoColor=white&style=flat)](https://github.com/rdavid/goredoer/releases)
[![license](https://img.shields.io/github/license/rdavid/goredoer?color=blue&labelColor=gray&logo=freebsd&logoColor=lightgray&style=flat)](https://github.com/rdavid/goredoer/blob/master/LICENSE)

* [About](#about)
* [Build](#build)
* [Using](#using)
* [License](#license)

## About

`goredoer` is the container image, which downloads, validates, extracts, and
builds Sergey Matveev's
[`goredo`](http://www.goredo.cypherpunks.ru/Install.html) utility. It is the
implementation of Daniel J. Bernstein's (aka, djb) build system
[`redo`](http://cr.yp.to/redo.html).

## Build

To build the image locally, start VM if needed `podman machine start`:

```sh
git clone git@github.com:rdavid/goredoer.git &&
  cd goredoer &&
  podman build --file ./Containerfile --format docker .
```

## Using

```sh
COPY --from=ghcr.io/rdavid/goredoer:0.9.20230410 /go/goredo .
RUN goredo -symlinks
```

See an example, how [`shellbase`](https://github.com/rdavid/shellbase) uses the
`goredoer`'s image in its
[`Containerfile`](https://github.com/rdavid/shellbase/blob/master/container/alpine/Containerfile).

## License

`goredoer` is copyright [David Rabkin](http://cv.rabkin.co.il) and available
under a
[Zero-Clause BSD license](https://github.com/rdavid/goredoer/blob/master/LICENSE).
