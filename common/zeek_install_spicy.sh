#!/bin/bash -e

ZEEK=${1}
VER=${2}

SPICY_DIR=/usr/local/spicy-${VER}
ZEEK_DIR=/usr/local/${ZEEK}-${VER}

export PATH=$ZEEK_DIR/bin:$PATH

cd /tmp
git clone --recursive https://github.com/zeek/spicy
cd spicy
./configure --prefix="${SPICY_DIR}" --generator=Ninja --enable-ccache && make && make install
