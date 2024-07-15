#!/usr/bin/env bash

# docker_run.sh

docker run -it \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -p 6066 \
  --runtime=nvidia --gpus all \ # Uncomment if using NVIDIA GPU
  # --device=/dev/dri:/dev/dri \ # Uncomment if using Intel iGPU
  --name apicoo_ros1 \
  limjh16/indy-ros-noetic
