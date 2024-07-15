FROM osrf/ros:noetic-desktop-full
ENV HOME=/root
EXPOSE 6066/tcp
RUN rosdep update

RUN apt update && apt install -y \
                        git \
                        nano \
                        vim \
                        build-essential \
                        cmake \
                        tzdata \
                        curl \
                        mesa-utils \
                        libgl1-mesa-glx \
                        libgl1-mesa-dri \
                        libnvidia-fbc1-535 \
                        libnvidia-gl-535 \
                        ros-noetic-moveit \
                        ros-noetic-industrial-core \
                        ros-noetic-gazebo-ros-pkgs \
                        ros-noetic-gazebo-ros-control \
                        ros-noetic-joint-state-controller \
                        ros-noetic-effort-controllers \
                        ros-noetic-position-controllers \
                        ros-noetic-joint-trajectory-controller

WORKDIR $HOME
RUN mkdir -p indy_ws/src/indy-ros
WORKDIR ${HOME}/indy_ws
RUN . /opt/ros/noetic/setup.sh && catkin_make

WORKDIR ${HOME}/indy_ws/src/indy-ros
# https://ryanfb.xyz/etc/2015/07/29/git_strategies_for_docker.html#run-git-clone
RUN --mount=type=bind,source=files/indy-ros_fixes.patch,target=/tmp/indy-ros_fixes.patch \
    git init && \
    git remote add upstream https://github.com/neuromeka-robotics/indy-ros.git && \
    git fetch upstream e09c2fbedfaf56dadd9e55977012951916862713 && \
    git checkout FETCH_HEAD && \
    git apply /tmp/indy-ros_fixes.patch

WORKDIR ${HOME}/indy_ws
RUN . /opt/ros/noetic/setup.sh && catkin_make

WORKDIR ${HOME}
COPY files/.bashrc_custom .
RUN echo "source ~/.bashrc_custom" >> ~/.bashrc

WORKDIR ${HOME}
RUN mkdir -p catkin_ws/src 
WORKDIR ${HOME}/catkin_ws
RUN . /opt/ros/noetic/setup.sh && catkin_make

WORKDIR ${HOME}
VOLUME [ "${HOME}/catkin_ws/src" ]
VOLUME [ "${HOME}/.ros/" ]
