ARG ZEEK_VERSION=4.0.5
ARG SPICY_VERSION=main
ARG BUILD_TYPE=Release

FROM debian:bullseye as builder
LABEL maintainer="Coding <code@ongoing.today>"

ARG ZEEK_VERSION
ARG SPICY_VERSION
ARG BUILD_TYPE
ENV ZEEK_VER ${ZEEK_VERSION}
ENV SPICY_VER ${SPICY_VERSION}
ENV WD /scratch
ENV PCAP /pcap

RUN mkdir ${WD} ${PCAP}
WORKDIR /scratch

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install --no-install-recommends \
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
        make \
        ninja-build \
        python3 \
        python3-dev \
        python3-git \
        python3-pip \
        python3-semantic-version \
        python3-setuptools \
        python3-wheel \
        zlib1g-dev && \
    python3 -m pip install --no-cache-dir pyzmq zkg "btest>=0.66" pre-commit

ADD ./common/buildzeek ${WD}/common/buildzeek
RUN ${WD}/common/buildzeek zeek ${ZEEK_VER} ${BUILD_TYPE}
ADD ./common/zeek_install_spicy.sh ${WD}/common/zeek_install_spicy.sh
RUN ${WD}/common/zeek_install_spicy.sh ${ZEEK_VER} ${SPICY_VER}
ADD ./common/zeek_install_plugins.sh ${WD}/common/zeek_install_plugins.sh
RUN ${WD}/common/zeek_install_plugins.sh ${ZEEK_VER} ${SPICY_VER}
ADD ./common/clean.sh ${WD}/common/clean.sh
RUN ${WD}/common/clean.sh ${ZEEK_VER} ${SPICY_VER}

# Make final image
FROM debian:bullseye
ARG ZEEK_VERSION
ARG SPICY_VERSION
ENV ZEEK_VER ${ZEEK_VERSION}
ENV SPICY_VER ${SPICY_VERSION}

RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get -y install --no-install-recommends \
        git \
        libpcap0.8 \
        libssl1.1 \
        libmaxminddb0 \
        python3.9 \
        python3-git \
        python3-pip \
        python3-semantic-version && \
    update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.9 1 && \
    mkdir /output && \
    apt-get clean && apt-get autoremove -y && rm -rf /var/lib/apt/lists/*

COPY --from=builder /usr/local/zeek-${ZEEK_VER} /usr/local/zeek-${ZEEK_VER}
COPY --from=builder /usr/local/spicy-${SPICY_VER} /usr/local/spicy-${SPICY_VER}

ENV PATH /usr/local/zeek-${ZEEK_VER}/bin:/usr/local/spicy-${SPICY_VER}/bin:$PATH
WORKDIR /output
CMD /bin/bash -l
