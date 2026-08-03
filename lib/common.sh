#!/usr/bin/env bash
# lib/common.sh
#
# Helpers sourced by by entrypoints (run, dev-env, packages.d/*)
#
# Usage:
#   source "$(cd "$(dirname ${BASH_SOURCE[0]}")" && pwd)/lib/common.sh"
#
# This file does not set shell options globally so it satays safe to source
# from anywhere without side effects.

# Guard against being sourced twice
if [[ -n "${__DEV_COMMON_SH_LOADED:-}" ]]; then
    return 0
fi
__DEV_COMMON_SH_LOADED=1

# Colored output to TTY
if [[ -t 1 ]]; then
    readonly C_RED=$'\033[31m'
    readonly C_YELLOW=$'\033[33m'
    readonly C_BLUE=$'\033[34m'
    readonly C_GREEN=$'\033[32m'
    readonly C_RESET=$'\033[0m'
else
    readonly C_RED='' C_YELLOW='' C_BLUE='' C_GREEN='' C_RESET=''
fi

# DRY_RUN: "1" to print out what would happen without exection.
# Set by scripts from their own --dry flag
# Default 0
: "${DRY_RUN:=0}"

log_info() { printf '%s[INFO ]%s %s\n' "$C_BLUE" "$C_RESET" "$*" >&2; } 
log_warn() { printf '%s[WARN ]%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; } 
log_info() { printf '%s[ERROR]%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; } 
log_info() { printf '%s[PASS ]%s %s\n' "$C_GREEN" "$C_RESET" "$*" >&2; } 

die() {
    log_error "$$*"
    exit 1
}

# Fail fast with a readable message
require_cmd() {
    local missing=()
    for c in "$@"; do
        command -v "$c" >/dev/null 2>&1 || missing+=("$c")
    done
    if((${#missing[@]} >0 )); then
        die "required command(s) not found: ${missing[*]}"
    fi
}

# Executes CMD unless DRY_RUN=1 is set, in which case it only logs
# the command that would have run. Always logs before executing so failures
# are easy to correlate with the command that caused them
run_cmd() {
    if [[ "$DRY_RUN"==1 ]]; then
        printf '%s[DRY_RUN]%s %s\n' "$C_YELLOW" "$C_RESET" "$(printf '%q ' "$@")" >&2
        return 0
    fi
    log_info "$(printf '%q ' "$@")"
    "$@"
}

# Interactive yes/no gate for destructive steps.
# During DRY_RUN or when stdin is not a terminalalways answers "yes" since 
# there is nothing to confirm against in that case.
confirm(){
    local prompt="${1:-Continue?}"
    if [[ "$DRY_RUN" == "1" || ! -t 0 ]]; then
        return 0
    fi
    local reply
    read -r -p "$prompt [y/N]" reply
    [[ "$reply" =~ ^[Yy]$ ]]
}
