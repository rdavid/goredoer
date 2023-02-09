# Goredoer [![publisher](https://github.com/rdavid/goredoer/actions/workflows/publish.yml/badge.svg)](https://github.com/rdavid/goredoer/actions/workflows/publish.yml) [![hits of code](https://hitsofcode.com/github/rdavid/goredoer?branch=master&label=hits%20of%20code)](https://hitsofcode.com/view/github/rdavid/goredoer?branch=master) [![license](https://img.shields.io/badge/license-0BSD-blue?color=blue&labelColor=gray&logo=freebsd&logoColor=lightgray&style=flat)](https://github.com/rdavid/goredoer/blob/master/LICENSE)
Container image for building
[`goredo`](http://www.goredo.cypherpunks.ru/Install.html).

* [About](#about)
* [Build](#build)
* [Use](#use)
* [License](#license)

## About
Hi, I'm [David Rabkin](http://cv.rabkin.co.il).

`goredoer` is a container image, which downloads, validates, extracts, and
builds Sergey Matveev's
[`goredo`](http://www.goredo.cypherpunks.ru/Install.html) utility. It is an
implementation of Daniel J. Bernstein's (aka, djb)
[build system](http://cr.yp.to/redo.html).

## Build
To build the image locally, start VM if needed `podman machine start`:
```sh
git clone git@github.com:rdavid/goredoer.git &&
	cd goredoer &&
	podman build --file ./Containerfile --format docker .
```
## Use
```sh
COPY --from=ghcr.io/rdavid/goredoer:v0.9.20230210 /go/goredo .
RUN goredo -symlinks
```
See an example, how [`shellbase`](https://github.com/rdavid/shellbase) uses the
`goredoer`'s image in its
[`Containerfile`](https://github.com/rdavid/shellbase/blob/master/container/alpine/Containerfile).

## License
`goredoer` is copyright [David Rabkin](http://cv.rabkin.co.il) and available
under a
[Zero-Clause BSD license](https://github.com/rdavid/goredoer/blob/master/LICENSE).
