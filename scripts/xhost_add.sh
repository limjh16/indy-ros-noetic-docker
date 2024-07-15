#!/usr/bin/env bash

# xhost_add.sh

export containerId=$(docker ps -l -q)
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $containerId`
