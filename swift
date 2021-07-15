#!/usr/bin/env sh

docker run --cap-add sys_ptrace -it --rm --mount type=bind,source="${PWD}",target=/src --workdir=/src -p 8080:8080 swift-docker-dev swift ${@}