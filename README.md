# Noetic Container Documentation
- This container was made to run in root mode
    - Rootless mode is unable to run overlay networking, which might be useful in the future
- The networking is the default bridged mode, exposing port 6066 for [IndyDCP](http://docs.neuromeka.com/3.0.0/en/IndyDCP/section1/) to communicate
- Packages installed followed <http://docs.neuromeka.com/3.0.0/en/ROS/section1/>

### `.bashrc` edits
- `force_color_prompt=yes` in line 39 was uncommented
- All additional commands are in `.bashrc_custom`

### Dev quickstart and `docker build` command
```console
git clone https://github.com/limjh16/indy-ros-noetic-docker.git
cd indy-ros-noetic-docker
docker build docker/ -t limjh16/indy-ros-noetic
./scripts/docker_run.sh
## in a separate terminal
./scripts/xhost_add.sh
```
---

# Docker X11 and GUI
```console
apt install mesa-utils # install in Container
```

### Intel iGPU
```console
apt install libgl1-mesa-glx libgl1-mesa-dri # install in Container
```
<https://wiki.ros.org/docker/Tutorials/Hardware%20Acceleration#Intel>

### NVIDIA GPU
```console
apt install libnvidia-fbc1-535 libnvidia-gl-535 # install in Container
```
<https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html> - install ON HOST

### Helper Scripts
<https://wiki.ros.org/docker/Tutorials/GUI#The_simple_way> - reference of the next 2 files, for X-servers
```bash
#!/usr/bin/env bash

# docker_run.sh

docker run -it \
  --env="DISPLAY" \
  --env="QT_X11_NO_MITSHM=1" \
  --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
  -p 6066 \
  # --runtime=nvidia --gpus all \ # Uncomment if using NVIDIA GPU
  # --device=/dev/dri:/dev/dri \ # Uncomment if using Intel iGPU
  --name apicoo_ros1 \
  limjh16/indy-ros-noetic
```

```bash 
#!/usr/bin/env bash

# xhost_add.sh

export containerId=$(docker ps -l -q)
xhost +local:`docker inspect --format='{{ .Config.Hostname }}' $containerId`
```

## SSH keys in Docker
- Easy way to share ssh keys with host: <https://stackoverflow.com/a/46406567> (mount host .ssh into docker)
- More secure / legitimate / reproducable way? Untested. <https://stackoverflow.com/a/36648428> (using ssh-agent)
- OR use ssh mounts, untested also. <https://docs.docker.com/build/building/secrets/#ssh-mounts> <https://stackoverflow.com/a/66301568>

---

# IndyDCP and issues

IndyDCP3 and the default ROS2 indy_driver.py uses gRPC protocol, not well supported

IndyDCP2 (which is broken by default, some undefined variables) and default ROS1 uses TCP, this works.
ROS1 driver: <https://github.com/neuromeka-robotics/indy-ros/blob/release-2.3/indy_driver_py/src/dcp_driver.py>
- Work needed to change ROS2 driver to use IndyDCP2, abandoned for now. Will use ROS1.

ROS1 broken files to change: (these changes are in `files/indy-ros_fixes.patch` and are auto-applied)
- [indy-ros/indy7_moveit_config/launch/planning_context.launch](https://github.com/neuromeka-robotics/indy-ros/blob/release-2.3/indy7_moveit_config/launch/planning_context.launch#L9) needs to remove `.py` after `xacro` on line 9
  - Reference: <https://wiki.ros.org/noetic/Migration#Use_xacro_instead_of_xacro.py>
- [indy-ros/indy7_v2_description/CMakeLists.txt](https://github.com/neuromeka-robotics/indy-ros/blob/release-2.3/indy7_v2_description/CMakeLists.txt#L2) line 2 needs to change to `project(indy7_v2_description)`
- PR submitted, pending merge <https://github.com/neuromeka-robotics/indy-ros/pull/8>
