# container-zeek

## Build

    docker build --tag=reuteras/container-zeek zeek

## Run

    docker run -it --rm -v "$$PWD"/pcap:/pcap:ro -v "$$PWD"/output:/output -w /output reuteras/container-zeek /bin/bash
