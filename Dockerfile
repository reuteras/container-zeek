# Build zeek
FROM ubuntu:focal
LABEL maintainer="Coding <code@ongoing.today>"

ARG TARGETARCH

ENV DEBIAN_FRONTEND noninteractive
# Tracking latest and not "-lts"
ENV ZEEK_LTS="" 
ENV ZEEK_VERSION="4.1.1-0"
ENV SPICY_VERSION="1.3.0"

ENV ZEEK_DIR "/opt/zeek"
ENV SPICY_DIR "/opt/spicy"
ENV PATH "${ZEEK_DIR}/bin:${SPICY_DIR}/bin:${ZEEK_DIR}/lib/zeek/plugins/packages/spicy-plugin/bin:${PATH}"

ENV CCACHE_DIR "/var/spool/ccache"

COPY ./common/zeek_install_plugins.sh /usr/local/bin/
COPY ./common/zeek_install_spicy.sh /usr/local/bin/

RUN apt-get update && \
    apt-get upgrade -yq && \
    apt-get -y install --no-install-recommends \
        binutils \
        bison \
        build-essential \
        ca-certificates \
        ccache \
        clang-11 \
        cmake \
        curl \
        file \ 
        flex \
        g++ \
        gawk \
        git \
        gnupg2 \
        libcurl4-openssl-dev \
        libfl-dev \
        libmaxminddb0 \
        libmaxminddb-dev \
        libncurses5-dev \
        libpcap0.8 \
        libpcap-dev \
        libssl-dev \
        locales-all \
        make \
        ninja-build \
        python3-dev \
        python3-git \
        python3-pip \
        python3-semantic-version \
        python3-setuptools \
        python3-wheel \
        swig \
        wget \
        zlib1g-dev && \
    python3 -m pip install --no-cache-dir pyzmq && \
    mkdir -p /tmp/zeek-packages && \
    cd /tmp/zeek-packages && \
    curl -sSL --remote-name-all \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/libbroker${ZEEK_LTS}-dev_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}-core-dev_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}-core_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}-libcaf-dev_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}-btest_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}-btest-data_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeek${ZEEK_LTS}-zkg_${ZEEK_VERSION}_$TARGETARCH.deb" \
        "https://download.zeek.org/binary-packages/xUbuntu_20.04/$TARGETARCH/zeekctl${ZEEK_LTS}_${ZEEK_VERSION}_$TARGETARCH.deb" && \
    dpkg -i ./*.deb && \
    /usr/local/bin/zeek_install_spicy.sh && \
    cd /tmp && \
    apt-get clean && \
    apt-get autoremove -y && \
    apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /var/cache/*/*

CMD ["/bin/bash"]
