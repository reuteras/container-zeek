#!/bin/bash -e

find /usr/local/zeek-"${ZEEK_VER}"/{bin,lib} /usr/local/spicy-"${SPICY_VER}"/lib/* -type f -exec file {} \; | grep stripped | cut -f1 -d: | xargs strip -s
find /usr/local/zeek-"${ZEEK_VER}" -type d -name .git -print0 | xargs rm -rf 
rm -rf /usr/local/zeek-"${ZEEK_VER}"/var/lib/zkg/clones/package/*/build
