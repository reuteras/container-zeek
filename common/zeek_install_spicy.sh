#!/bin/bash

# Don't run on arm64

[[ $BUILDARCH == "arm64" ]] && exit

mkdir -p /tmp/spicy-packages
cd /tmp/spicy-packages || exit
curl -sSL --remote-name-all \
    "https://github.com/zeek/spicy/releases/download/v${SPICY_VERSION}/spicy_linux_debian10.deb"
dpkg -i ./*.deb
cd /tmp || exit
mkdir -p "${CCACHE_DIR}"
zkg autoconfig --force
zkg install --force --skiptests zeek/spicy-plugin
bash /usr/local/bin/zeek_install_plugins.sh
find "${ZEEK_DIR}"/lib -type d -name CMakeFiles -exec rm -rf "{}" \; 2>/dev/null || true
find "${ZEEK_DIR}"/var/lib/zkg -type d -name build -exec rm -rf "{}" \; 2>/dev/null || true
find "${ZEEK_DIR}"/var/lib/zkg/clones -type d -name .git -execdir bash -c "pwd; du -sh; git pull --depth=1 --ff-only; git reflog expire --expire=all --all; git tag -l | xargs -r git tag -d; git gc --prune=all; du -sh" \;
rm -rf "${ZEEK_DIR}"/var/lib/zkg/scratch
find "${ZEEK_DIR}/" "${SPICY_DIR}/" -type f -exec file "{}" \; | grep -Pi "ELF 64-bit.*not stripped" | sed 's/:.*//' | xargs -l -r strip --strip-unneeded
find "${ZEEK_DIR}/" "${SPICY_DIR}/" -type f -exec file "{}" \; | grep -Pi "current ar archive" | sed 's/:.*//' | xargs -l -r strip --strip-unneeded
mkdir -p "${ZEEK_DIR}"/var/lib/zkg/clones/package/spicy-plugin/build/plugin/bin/
ln -s -r "${ZEEK_DIR}"/lib/zeek/plugins/packages/spicy-plugin/bin/spicyz \
    "${ZEEK_DIR}"/var/lib/zkg/clones/package/spicy-plugin/build/plugin/bin/spicyz
mkdir -p "${ZEEK_DIR}"/var/lib/zkg/clones/package/spicy-plugin/plugin/lib/
ln -s -r "${ZEEK_DIR}"/lib/zeek/plugins/packages/spicy-plugin/lib/bif \
    "${ZEEK_DIR}"/var/lib/zkg/clones/package/spicy-plugin/plugin/lib/bif && \
cd /usr/lib/locale || exit
ls -- * | grep -Piv "^(en|en_US|en_US\.utf-?8|C\.utf-?8)$" | xargs -l -r rm -rf
