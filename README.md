# container-zeek

Build for arm64 and amd64. Don't include spicy for arm64 until binaries are available for download from spicy [releases](https://github.com/zeek/spicy/releases).

## Build

    docker build --tag=reuteras/container-zeek zeek

## Run

    docker run -it --rm -v "$$PWD"/pcap:/pcap:ro -v "$$PWD"/output:/output -w /output reuteras/container-zeek /bin/bash
