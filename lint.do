# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Lints the project with any installed linters. Command output streams to
# the console through the shellbase loggers, and the script prints OK as the
# lint target content.
#
# Variable appears unused and file not following:
#  shellcheck disable=SC2034,SC1090
redo-ifchange \
	./.github/*.yml \
	./.github/workflows/*.yml \
	./*.do \
	./Containerfile \
	./README.adoc
readonly \
	BASE_APP_VERSION=0.9.20260709 \
	BASE_MIN_VERSION=0.9.20260707 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase first (missing %s).\n' "$BSH"
	exit 1
}
. "$BSH"
cmd_runif actionlint
cmd_runif hadolint ./Containerfile
cmd_runif reuse lint
cmd_runif shellcheck ./*.do
cmd_runif shfmt -d ./*.do
cmd_runif typos
cmd_runif vale sync
cmd_runif vale ./README.adoc
cmd_runif yamllint \
	./.github/*.yml \
	./.github/workflows/*.yml
printf OK
