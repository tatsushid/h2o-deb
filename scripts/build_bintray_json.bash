#!/bin/bash

cd $(dirname "$0") || exit 1

TEMPLATE_FILE="bintray.json.tmpl"
DST_DIR="../bintray"
CHANGELOG="../src/debian/changelog"

PKG_VERSION=$(sed -ne '1s/^h2o[[:space:]]*(\([^)]*\)).*/\1/p' "$CHANGELOG")
DATE=$(date +%Y-%m-%d)

[ -d "$DST_DIR" ] || mkdir "$DST_DIR"

for PKG_NAME in $@; do
    DST_FILE="bintray-${PKG_NAME}.json"
    PKG_DIR="${PKG_NAME:0:1}"

    sed -e "s/@PKG_NAME@/${PKG_NAME}/g" \
        -e "s/@PKG_VERSION@/${PKG_VERSION}/g" \
        -e "s/@PKG_DIR@/${PKG_DIR}/g" \
        -e "s/@DATE@/${DATE}/g" \
        "$TEMPLATE_FILE" > "${DST_DIR}/${DST_FILE}"
done
