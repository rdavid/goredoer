# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Builds the goredoer container image with Podman. The variable stp tracks
# whether the script started the Podman VM and should stop it on exit. Exit
# code 125 from podman machine start means the VM is already running or is
# still starting up. The script prints OK to stdin for the redo target.
#
# Variable appears unused and file not following:
#  shellcheck disable=SC2034,SC1090
redo-ifchange ./Containerfile
readonly \
	BASE_APP_VERSION=0.9.20260709 \
	BASE_MIN_VERSION=0.9.20260707 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase first (missing %s).\n' "$BSH"
	exit 1
}
. "$BSH"
stp=true
cmd_run podman machine start || {
	[ $? = 125 ] || die
	log Podman VM is already running.
	stp=false
}
cmd_run podman build --file ./Containerfile --format docker .
[ "$stp" = false ] || podman machine stop
printf OK
