# shellcheck shell=sh
# vi:et lbr noet sw=2 ts=2 tw=79 wrap
# SPDX-FileCopyrightText: 2024-2026 David Rabkin
# SPDX-License-Identifier: 0BSD
redo-ifchange ./Containerfile

# shellcheck disable=SC2034 # Variable appears unused.
readonly \
	BASE_APP_VERSION=0.9.20260610 \
	BASE_MIN_VERSION=0.9.20240202 \
	BSH=/usr/local/bin/base.sh
[ -r "$BSH" ] || {
	printf >&2 'Install shellbase first (missing %s).\n' "$BSH"
	exit 1
}
set -- "$@" --quiet

# shellcheck disable=SC1090 # File not following.
. "$BSH"
validate_cmd podman

# Tracks whether this script started the VM and should stop it on exit.
# Exit code 125 means the VM is already running or still starting up.
stop_vm=true
out="$(podman machine start 2>&1)" || {
	[ $? = 125 ] || die "$out"
	printf >&2 'Podman VM is already running or is still starting.\n'
	stop_vm=false
}
out="$(podman build --file ./Containerfile --format docker . 2>&1)" || die "$out"
if [ "$stop_vm" = true ]; then
	podman machine stop
fi
