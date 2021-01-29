#!/usr/bin/env bash

# Copyright The Lyrid Inc. Authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# The install script is based off of the MIT-licensed script from glide,
# the package manager for Go: https://github.com/Masterminds/glide.sh/blob/master/get
PROJECT_NAME="lc"


: ${USE_SUDO:="true"}
: ${LC_INSTALL_DIR:="/usr/local/bin"}


# initArch discovers the architecture for this system.
initArch() {
  ARCH=$(uname -m)
  case $ARCH in
#    x86) ARCH="386";;
    x86_64) ARCH="amd64";;
  esac
}

# initOS discovers the operating system for this system.
initOS() {
  OS=$(echo `uname`|tr '[:upper:]' '[:lower:]')

  case "$OS" in
    # Minimalist GNU for Windows
    mingw*) OS='windows';;
  esac
}

runAsRoot() {
  local CMD="$*"

  if [ $EUID -ne 0 -a $USE_SUDO = "true" ]; then
    CMD="sudo $CMD"
  fi

  $CMD
}

# verifySupported checks that the os/arch combination is supported for
# binary builds.
verifySupported() {
  local supported="darwin-amd64\nlinux-amd64\nwindows-amd64"
  if ! echo "${supported}" | grep -q "${OS}-${ARCH}"; then
    echo "No prebuilt binary for ${OS}-${ARCH}."
    #echo "To build from source, go to https://dev.lyrid.io/sky/lc"
    exit 1
  fi

  if ! type "curl" > /dev/null && ! type "wget" > /dev/null; then
    echo "Either curl or wget is required"
    exit 1
  fi
}


# checkLCInstalledVersion checks which version of helm is installed and
# if it needs to be changed.
checkLCInstalledVersion() {
  if [[ -f "${LC_INSTALL_DIR}/${PROJECT_NAME}" ]]; then
    local version=$("${LC_INSTALL_DIR}/${PROJECT_NAME}" --version  | cut -d' ' -f3)
    if [[ -z "$version" ]]; then
      echo "LC ${version} is already installed"
      return 0
    else
      echo "LC Latest is available. Please remove the older LC and continue install."
      return 0
    fi
  else
    return 1
  fi
}

downloadFile() {
  if [[ "$OS" == "darwin" ]] ; then
    DOWNLOAD_URL="https://api.lyrid.io/client/dl/mac"
  fi
  if [[ "$OS" == "linux" ]] ;  then
    DOWNLOAD_URL="https://api.lyrid.io/client/dl/linux"
  fi
  if [[ "$OS" == "windows" ]] ;  then 
    DOWNLOAD_URL="https://api.lyrid.io/client/dl/win"
  fi
  LC_TMP_ROOT="$(mktemp -dt lc-installer-XXXXXX)"
  LC_TMP_FILE="$LC_TMP_ROOT/$PROJECT_NAME"
  echo "Downloading $DOWNLOAD_URL"

  if type "curl" > /dev/null; then
    curl -SsL "$DOWNLOAD_URL" -o "$LC_TMP_FILE"
    chmod 700 "$LC_TMP_FILE"
  elif type "wget" > /dev/null; then
    wget -q -O "$LC_TMP_FILE" "$DOWNLOAD_URL"
    chmod 700 "$LC_TMP_FILE"
  fi
}

installFile() {
  runAsRoot cp "$LC_TMP_FILE" "$LC_INSTALL_DIR"
  echo "$PROJECT_NAME installed into $HELM_INSTALL_DIR/$PROJECT_NAME"
}

fail_trap() {
  result=$?
  if [ "$result" != "0" ]; then
    if [[ -n "$INPUT_ARGUMENTS" ]]; then
      echo "Failed to install $PROJECT_NAME with the arguments provided: $INPUT_ARGUMENTS"
      help
    else
      echo "Failed to install $PROJECT_NAME"
    fi
    echo -e "\tFor support, go to https://dev.lyrid.io/sky/lc."
  fi
  cleanup
  exit $result
}

testVersion() {
  set +e
  LC="$(command -v $PROJECT_NAME)"
  if [ "$?" = "1" ]; then
    echo "$PROJECT_NAME not found. Is $HELM_INSTALL_DIR on your "'$PATH?'
    exit 1
  fi
  set -e
  echo "Run '$PROJECT_NAME init' to configure $PROJECT_NAME."
}

help () {
  echo "Accepted cli arguments are:"
  echo -e "\t[--help|-h ] ->> prints this help"
  echo -e "\t[--no-sudo]  ->> install without sudo"
}

cleanup() {
  if [[ -d "${LC_TMP_ROOT:-}" ]]; then
    rm -rf "$LC_TMP_ROOT"
  fi
}

trap "fail_trap" EXIT
set -e

# Parsing input arguments (if any)
export INPUT_ARGUMENTS="${@}"
set -u
while [[ $# -gt 0 ]]; do
  case $1 in
    '--no-sudo')
       USE_SUDO="false"
       ;;
    '--help'|-h)
       help
       exit 0
       ;;
    *) exit 1
       ;;
  esac
  shift
done
set +u

initArch
initOS
verifySupported

if ! checkLCInstalledVersion; then
  downloadFile
  installFile
fi
testVersion
cleanup