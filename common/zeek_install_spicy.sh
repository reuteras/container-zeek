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

export PATH=$ZEEK_DIR/bin:$PATH

mkdir -p /opt/spicy
cd /opt/spicy
git clone -b "${SPICY_BRANCH}" --single-branch --recursive https://github.com/zeek/spicy src
cd src
rm -rf .git 3rdparty/*/.git
./configure --prefix="${SPICY_DIR}" --generator=Ninja --enable-ccache 
make
make install
rm -rf build
strip -s "${SPICY_DIR}"/lib/*
