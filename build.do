# shellcheck shell=sh
# vi: lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
#
# Builds the goredoer container image with Podman. The variable STP tracks
# whether the script started the Podman VM and should stop it on exit. Exit
# code 125 from podman machine start means the VM is already running or is
# still starting up. The script closes the redo jobserver descriptors 3 and 4
# for podman machine start, so the VM daemon does not inherit them and stall
# redo. The script prints OK to stdout for the redo target.
#
# Silences warnings about unused variables and unfollowed sourced files:
#  shellcheck disable=SC2034,SC1090
redo-ifchange ./Containerfile
readonly \
	BASE_APP_VERSION=0.9.20261008 \
	BASE_MIN_VERSION=0.9.20260707 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase first (missing %s).\n' "$BSH"
	exit 1
}
. "$BSH"
STP=true
cmd_run sh -c 'podman machine start 3>&- 4>&-' || {
	[ $? = 125 ] || die
	log Podman VM is already running.
	STP=false
}
cmd_run podman build --file ./Containerfile --format docker .
[ "$STP" = false ] || cmd_run podman machine stop
printf OK
