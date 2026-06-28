# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
redo-ifchange \
	./.github/*.yml \
	./.github/workflows/*.yml \
	./*.do \
	./Containerfile \
	./README.adoc

# shellcheck disable=SC2034 # Variable appears unused.
readonly \
	BASE_APP_VERSION=0.9.20260628 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase first (missing %s).\n' "$BSH"
	exit 1
}
set -- "$@" --quiet

# shellcheck disable=SC1090 # File not following.
. "$BSH"

# Runs a linter only when its command is installed, propagating failures.
run_if() {
	cmd_exists "$1" || return 0
	"$@"
}
run_if actionlint
run_if hadolint ./Containerfile
run_if shellcheck ./*.do
run_if shfmt -d ./*.do
run_if typos
run_if vale sync
run_if vale ./README.adoc
run_if yamllint ./.github/*.yml ./.github/workflows/*.yml
