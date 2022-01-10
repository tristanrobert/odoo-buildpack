#!/bin/bash

steptxt="----->"
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'                              # No Color
CURL="curl -L --retry 15 --retry-delay 2" # retry for up to 30 seconds
APT_GET="apt-get -o debug::nolocking=true"

info() {
  echo -e "${GREEN}       $*${NC}"
}

warn() {
  echo -e "${YELLOW} !!    $*${NC}"
}

err() {
  echo -e "${RED} !!    $*${NC}" >&2
}

step() {
  echo "$steptxt $*"
}

start() {
  echo -n "$steptxt $*... "
}

finished() {
  echo "done"
}

function indent() {
  c='s/^/       /'
  case $(uname) in
  Darwin) sed -l "$c" ;; # mac/bsd sed: -l buffers on line boundaries
  *) sed -u "$c" ;;      # unix/gnu sed: -u unbuffered (arbitrary) chunks of data
  esac
}

function install_odoo() {  
  ODOO_VERSION="$1"
  step "Fetching odoo latest nightly ${ODOO_VERSION}"
  if [ -f "${CACHE_DIR}/dist/odoo_${ODOO_VERSION}.latest.tar.gz" ]; then
    info "File already downloaded"
  else
    ${CURL} -o "${CACHE_DIR}/dist/odoo_${ODOO_VERSION}.latest.tar.gz" "https://nightly.odoo.com/${ODOO_VERSION}/nightly/src/odoo_${ODOO_VERSION}.latest.tar.gz"
  fi
  if [ ! -d "${CACHE_DIR}/dist/odoo" ]; then
    mkdir "${CACHE_DIR}/dist/odoo"
  fi
  tar -zxf "${CACHE_DIR}/dist/odoo_${ODOO_VERSION}.latest.tar.gz" -C "${CACHE_DIR}/dist/odoo" --strip-components=1
  sed -i 's/python-ldap/#python-ldap/g' "${CACHE_DIR}/dist/odoo/requirements.txt"
  cp -a "${CACHE_DIR}/dist/odoo/." "${BUILD_DIR}"
  finished
}
