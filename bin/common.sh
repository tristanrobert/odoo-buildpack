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

function install_wkhtmltopdf() {
  wkhtmltopdf_VERSION="$1"
  step "Fetching wkhtmltopdf ${wkhtmltopdf_VERSION}"
  if [ -f "${CACHE_DIR}/dist/wkhtmltox_${wkhtmltopdf_VERSION}-1.focal_amd64.deb" ]; then
    info "File already downloaded"
  else
    ${CURL} -o "${CACHE_DIR}/dist/wkhtmltox_${wkhtmltopdf_VERSION}-1.focal_amd64.deb" "https://github.com/wkhtmltopdf/packaging/releases/download/${wkhtmltopdf_VERSION}-1/wkhtmltox_${wkhtmltopdf_VERSION}-1.focal_amd64.deb"
  fi
  ${APT_GET} install -y --no-install-recommends "${CACHE_DIR}/dist/wkhtmltox_${wkhtmltopdf_VERSION}-1.focal_amd64.deb"
  finished
}

function install_odoo() {  
  ODOO_VERSION="$1"
  step "Fetching odoo latest nightly ${ODOO_VERSION}"
  if [ -f "${CACHE_DIR}/dist/odoo_${ODOO_VERSION}.latest_all.deb" ]; then
    info "File already downloaded"
  else
    ${CURL} -o "${CACHE_DIR}/dist/odoo_${ODOO_VERSION}.latest_all.deb" "https://nightly.odoo.com/${ODOO_VERSION}/nightly/deb/odoo_${ODOO_VERSION}.latest_all.deb"
  fi
  # fix error in scalingo-20
  sed -i 's/bionic-pgdg/focal-pgdg/g' /etc/apt/sources.list
  ${APT_GET} update 
  ${APT_GET} install --no-install-recommends -y postgresql-client
  ${APT_GET} full-upgrade -y
  ${APT_GET} install -y --no-install-recommends "${CACHE_DIR}/dist/odoo_${ODOO_VERSION}.latest_all.deb"
  sed -i 's/;addons/addons/g' /etc/odoo/odoo.conf
  finished
}
