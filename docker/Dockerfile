FROM osrf/ros:noetic-desktop-full-focal
ENV HOME=/root
EXPOSE 6066/tcp
RUN . /opt/ros/noetic/setup.sh && rosdep update

RUN apt-get update && apt-get install -y \
                                        git \
                                        nano \
                                        vim \
                                        build-essential \
                                        cmake \
                                        tzdata \
                                        curl

RUN apt-get update && apt-get install -y \
                                        mesa-utils \
                                        libgl1-mesa-glx \
                                        libgl1-mesa-dri \
                                        libnvidia-fbc1-535 \
                                        libnvidia-gl-535

RUN apt-get update && apt-get install -y \
                                        ros-noetic-moveit \
                                        ros-noetic-industrial-core \
                                        ros-noetic-gazebo-ros-pkgs \
                                        ros-noetic-gazebo-ros-control \
                                        ros-noetic-joint-state-controller \
                                        ros-noetic-effort-controllers \
                                        ros-noetic-position-controllers \
                                        ros-noetic-joint-trajectory-controller \
                                        ros-noetic-moveit-visual-tools \
                                        ros-noetic-rviz-visual-tools \
                                        python3-catkin-tools

WORKDIR $HOME
RUN mkdir -p workspaces/indy_ws/src/indy-ros
ENV WORKSPACES=${HOME}/workspaces
WORKDIR ${WORKSPACES}/indy_ws
RUN . /opt/ros/noetic/setup.sh && catkin_make

WORKDIR ${WORKSPACES}/indy_ws/src/indy-ros
# https://ryanfb.xyz/etc/2015/07/29/git_strategies_for_docker.html#run-git-clone
RUN --mount=type=bind,source=files/indy-ros_fixes.patch,target=/tmp/indy-ros_fixes.patch \
    git init && \
    git remote add upstream https://github.com/neuromeka-robotics/indy-ros.git && \
    git fetch upstream e09c2fbedfaf56dadd9e55977012951916862713 && \
    git checkout FETCH_HEAD && \
    git apply /tmp/indy-ros_fixes.patch

WORKDIR ${WORKSPACES}/indy_ws
RUN . /opt/ros/noetic/setup.sh && . ${WORKSPACES}/indy_ws/devel/setup.sh && catkin_make

WORKDIR ${HOME}
COPY files/.bashrc_custom .
RUN echo "source ~/.bashrc_custom" >> ~/.bashrc

WORKDIR ${WORKSPACES}
RUN mkdir -p catkin_ws/src
WORKDIR ${WORKSPACES}/catkin_ws
# Make sure to overlay workspace
# https://wiki.ros.org/catkin/Tutorials/workspace_overlaying
RUN . /opt/ros/noetic/setup.sh && . ${WORKSPACES}/indy_ws/devel/setup.sh && catkin_make

WORKDIR ${HOME}
VOLUME [ "${WORKSPACES}/catkin_ws/src" ]
VOLUME [ "${HOME}/.ros/" ]
