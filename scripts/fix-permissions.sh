#!/bin/bash

# Set ownership for all files in the backup area, based on the host and user
# names encoded into their paths.
#
# This should run only when the backup server is being deployed.  It should be
# useful only when the backup server is being REdeployed, if there are backups
# still present on the big disk, but new non-matching UIDs have been generated.
#
# It could be more efficient to change the UIDs than to chown all the files.
# On the other hand, it's nice to avoid messing with accounts.


shopt -s nullglob


function main() {
  cd /backup/ || fail "Failed to enter backup root."

  hp="${PWD}"
  for host in *; do 
    if test 'snapshots' = "${host}"; then 
      continue
    fi
    cd "${host}" || fail "Failed to enter host directory:  '${host}'"
    up="${PWD}"
    for user in *; do 
      cd "${user}" || fail "Failed to enter user directory:  '${user}'"
      output "Changing ownership for:  '${user}' at '${host}'"
      chown -R "${user}-at-${host}:${user}-at-${host}" . || fail "Failed to chown:  '${user}' at '${host}'"
      output "Ownership changes complete for:  '${user}' at '${host}'"
      cd "${up}" || fail "Failed to return to host directory for '${host}':  '${up}'"
    done
    cd "${hp}" || fail "Failed to return to backup root:  '${hp}'"
  done
}


function warn() {
  output "WARNING:  ${1}" >&2
}


function fail() {
  output "ERROR:  ${1}" >&2
  exit "${2:-1}"
}


function output() {
  printf "%s\n" "${@}"
}


main
