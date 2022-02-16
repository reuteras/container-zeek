#!/bin/bash

find /usr/local/zeek-"${ZEEK_VER}"/{bin,lib} -type f -exec file {} \; | grep stripped | cut -f1 -d: | xargs strip -s
find /usr/local/zeek-"${ZEEK_VER}" -type d -name .git -exec rm -rf {} \;
rm -rf /usr/local/zeek-"${ZEEK_VER}"/var/lib/zkg/clones/package/*/build
strip -s "${SPICY_DIR}"/lib/*
