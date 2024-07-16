#!/usr/bin/env bash

# docker_run.sh

gpu_support_args=()
if command -v nvidia_smi &> /dev/null
then
  gpu_support_args+=(--runtime nvidia --gpus all)
else
  gpu_support_args+=(--device=/dev/dri:/dev/dri)
fi

docker run -it \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -p 6066 \
  "${gpu_support_args[@]}" \
  --name apicoo_ros1 \
  --privileged \
  limjh16/indy-ros-noetic
