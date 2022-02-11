FROM debian:bullseye as builder
LABEL maintainer="Coding <code@ongoing.today>"

ENV WD /scratch

RUN mkdir ${WD}
WORKDIR /scratch

RUN apt-get update && apt-get upgrade -y
RUN apt-get -y install --no-install-recommends \
    bison \
    build-essential \
    ca-certificates \
    cmake \
    flex \
    gawk \
    git \
    libcurl4-openssl-dev \
    libmaxminddb-dev \
    libncurses5-dev \
    libpcap-dev \
    libssl-dev \
    python3.9-dev \
    swig \
    wget \
    binutils \
    ccache \
    file \
    gcc \
    g++ \
    google-perftools \
    jq \
    libfl-dev \
    libgoogle-perftools-dev \
    libkrb5-dev \
    libpcap0.8-dev \
    libssl-dev \
    locales-all \
    make \
    ninja-build \
    python3 \
    python3-dev \
    python3-pip \
    python3-setuptools \
    python3-wheel \
    zlib1g-dev 

ARG ZEEK_VER=4.0.5

ARG BUILD_TYPE=Release
ENV VER ${ZEEK_VER}
ADD ./common/buildzeek ${WD}/common/buildzeek
RUN ${WD}/common/buildzeek zeek ${VER} ${BUILD_TYPE}
RUN apt-get -y install python3-git python3-pip python3-semantic-version python3-setuptools python3-wheel --no-install-recommends
RUN python3 -m pip install --no-cache-dir pyzmq zkg "btest>=0.66" pre-commit
ADD ./common/zeek_install_spicy.sh ${WD}/common/zeek_install_spicy.sh
RUN ${WD}/common/zeek_install_spicy.sh zeek ${VER}
ADD ./common/zeek_install_plugins.sh ${WD}/common/zeek_install_plugins.sh
RUN ${WD}/common/zeek_install_plugins.sh zeek ${VER}

# Make final image
FROM debian:bullseye
ARG ZEEK_VER=4.0.5
ENV VER ${ZEEK_VER}

RUN apt-get update && \
    apt-get -y install --no-install-recommends \
        git \
        libpcap0.8 \
        libssl1.1 \
        libmaxminddb0 \
        python3.9 \
        python3-pip && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    python3 -m pip install --no-cache-dir btest sphinx_rtd_theme && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/zeek-${VER} /usr/local/zeek-${VER}
COPY --from=builder /usr/local/spicy-${VER} /usr/local/spicy-${VER}
RUN ln -s /usr/local/zeek-${VER} /zeek
RUN ln -s /usr/local/spicy-${VER} /spicy

env PATH /zeek/bin:/spicy/bin:$PATH
CMD /bin/bash -l
