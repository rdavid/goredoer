# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
# Builds the goredoer container image with Podman. The variable stp tracks
# whether this script started the Podman VM and should stop it on exit. Exit
# code 125 from podman machine start means the VM is already running or is
# still starting up.
# Variable appears unused and file not following:
#  shellcheck disable=SC2034,SC1090
redo-ifchange ./Containerfile
readonly \
	BASE_APP_VERSION=0.9.20260706 \
	BASE_MIN_VERSION=0.9.20240202 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase first (missing %s).\n' "$BSH"
	exit 1
}
set -- "$@" --quiet
. "$BSH"
cmd_exists podman || die
stp=true
out="$(podman machine start 2>&1)" || {
	[ $? = 125 ] || die "$out"
	printf >&2 'Podman VM is already running or is still starting.\n'
	stp=false
}
out="$(podman build --file ./Containerfile --format docker . 2>&1)" ||
	die "$out"
[ "$stp" = false ] || podman machine stop
