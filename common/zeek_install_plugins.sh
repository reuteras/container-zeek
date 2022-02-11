#!/bin/bash

ZEEK=$1
VER=$2

SPICY_DIR=/usr/local/spicy-${VER}
ZEEK_DIR=/usr/local/${ZEEK}-${VER}

export PATH=${ZEEK_DIR}/bin:${SPICY_DIR}:${PATH}

zkg autoconfig --force

#  "https://github.com/0xl3x1/zeek-EternalSafety"
#  "https://github.com/corelight/CVE-2020-16898"
#  "https://github.com/corelight/SIGRed"
#  "https://github.com/corelight/zeek-community-id"
#  "https://github.com/corelight/zeek-xor-exe-plugin|master"
#  "https://github.com/corelight/zerologon"
#  "https://github.com/mitre-attack/bzar"
#  "https://github.com/precurse/zeek-httpattacks"
#  "https://github.com/salesforce/hassh"
#  "https://github.com/salesforce/ja3"
#  "https://github.com/zeek/spicy-analyzers"

ZKG_PACKAGE_NAMES=(
    "zeek/activecm/zeek-open-connections"
    "zeek-sniffpass"
    "zeek-community-id"
    "zeek/spicy-plugin"
)

for package in "${ZKG_PACKAGE_NAMES[@]}"; do
    zkg install --force --skiptests "${package}"
done

sed -i"" -e 's/# @load packages/@load packages/' "${ZEEK_DIR}"/share/zeek/site/local.zeek

zeekctl deploy
