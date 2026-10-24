# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Runs every installed linter on the project. Shellbase loggers stream the
# linter output to the console. The script prints OK to stdout as the redo
# target.
#
# Silences shellcheck warnings about unused variables and sourced files:
#  shellcheck disable=SC2034,SC1091
redo-ifchange \
	./.github/*.yml \
	./.github/workflows/*.yml \
	./*.do \
	./Containerfile \
	./README.adoc
readonly \
	BASE_APP_VERSION=0.9.20261024 \
	BASE_MIN_VERSION=0.9.20260707
. base.sh
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
