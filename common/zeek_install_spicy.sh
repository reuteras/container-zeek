#!/bin/bash -e

ZEEK_VER=$1
SPICY_VER=$2

if [[ "${SPICY_VER}" == "main" ]]; then
    SPICY_BRANCH=main
else
    SPICY_BRANCH="v${SPICY_VER}"
fi

SPICY_DIR=/usr/local/spicy-${SPICY_VER}
ZEEK_DIR=/usr/local/${ZEEK}-${ZEEK_VER}

export PATH=${ZEEK_DIR}/bin:${SPICY_DIR}/bin:${PATH}

mkdir -p /opt/src
cd /opt/src
git clone -b "${SPICY_BRANCH}" --single-branch --recursive https://github.com/zeek/spicy spicy
cd spicy
./configure --prefix="${SPICY_DIR}" --generator=Ninja --enable-ccache 
make
make install

# Clean
rm -rf .git 3rdparty/*/.git
rm -rf build
