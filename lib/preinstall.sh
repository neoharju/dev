#!/usr/bin/env bash
# lib/preinstall.sh
#
# Basic checks to make sure install may start normally

# Guard against being sourced twice
if [[ -n "${__DEV_PREINSTALL_SH_LOADED:-}" ]]; then
	return 0
fi
__DEV_PREINSTALL_SH_LOADED=1

set -Eeuo pipefail

# shellcheck source=common.sh
source common.sh

readonly MIN_DISK_MB=100000
SUDO_KEEPALIVE_PID=""

disk_space_mb() {
    df -BM --output=avail "$HOME" |
        tail -n1 |
        tr -dc '0-9'
}

require_pacman() {
  if ! command -v pacman &> /dev/null; then
    die "Missing pacman package manager (Arch-based distribution)."
  fi
  log_ok "Verified pacman is installed."

}

require_not_root() {
    (( EUID != 0 )) && return

    die "Installer should run as a regular user with sudo privileges."
}

start_sudo_keepalive() {
    (
        while true; do
            sudo -n true
            sleep 60
        done
    ) &
    SUDO_KEEPALIVE_PID=$!
}

stop_sudo_keepalive() {
    [[ -n $SUDO_KEEPALIVE_PID ]] || return

    kill "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
    wait "$SUDO_KEEPALIVE_PID" 2>/dev/null || true
}

check_sudo() {
    sudo -v || die "This installer requires sudo privileges."

    start_sudo_keepalive
    trap stop_sudo_keepalive EXIT

    log_ok "Sudo access verified."
}
