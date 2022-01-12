#!/bin/bash

steptxt="----->"
GREEN='\033[1;32m'
YELLOW='\033[1;33m'
RED='\033[1;31m'
NC='\033[0m'                              # No Color

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
  if [ ! -d "${CACHE_DIR}/dist/odoo" ]; then
    git clone --progress --depth=1 https://github.com/odoo/odoo "${CACHE_DIR}/dist/odoo"
  else
    cd "${CACHE_DIR}/dist/odoo" || return
    git pull origin
  fi
  cd "${CACHE_DIR}/dist/odoo" || return
  cp -a "${CACHE_DIR}/dist/odoo/." "${BUILD_DIR}"
  finished
}
