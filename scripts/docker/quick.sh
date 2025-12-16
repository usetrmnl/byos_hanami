#! /usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail
IFS=$'\n\t'

OPERATING_SYSTEM="$(uname)"

# Label: Abort
# Description: Prints error message and exits script.
# Parameters: $1 (required): The error message.
abort() {
  local message="$1"

  printf "%s\n" "ERROR: $message"
  exit 1
}

if [ -z "${BASH_VERSION:-}" ]; then
  abort "Bash is required to interpret this script."
fi

if [[ -n "${INTERACTIVE-}" && -n "${NONINTERACTIVE-}" ]]; then
  abort "Please unset one or both of these variables then retry: INTERACTIVE and NONINTERACTIVE."
fi

if [[ -n "${POSIXLY_CORRECT+1}" ]]
then
  abort "Bash must not run in POSIX mode. Please unset POSIXLY_CORRECT and retry."
fi

if [[ "${OPERATING_SYSTEM}" != "Darwin" && "${OPERATING_SYSTEM}" != "Linux" ]]; then
  abort "Terminus quick setup is only supported on macOS and Linux."
fi

if ! command -v git > /dev/null 2>&1; then
  abort "Git not found. Please install Git and retry."
fi

if ! docker info > /dev/null 2>&1; then
  abort "Docker is not running. Please install and start Docker then retry."
fi

if [[ ! -w "." ]]; then
  abort "Current directory is not writable. Please choose a writable location and retry."
fi

if [[ -d "terminus" ]]; then
  abort "Terminus project directory exists. Please remove or run from a different location."
fi

git clone https://github.com/usetrmnl/byos_hanami terminus
cd terminus
printf "%s\n" "Terminus has been cloned into: $PWD."
bin/setup docker
docker compose up --pull always
