FROM nvcr.io/nvidia/l4t-base:r32.2

MAINTAINER benson

# setup timezone & install packages
ENV DEBIAN_FRONTEND=noninteractive
RUN echo 'Etc/UTC' > /etc/timezone && \
    ln -s /usr/share/zoneinfo/Etc/UTC /etc/localtime && \
    apt-get update && \
    apt-get install -q -y tzdata dirmngr gnupg2 python-pip && \
    apt-get install -y --no-install-recommends make g++ && \
    apt-get install -y libusb-1.0 gtk+-3.0 build-essential libglfw3-dev software-properties-common && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# setup keys and source.list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654 && \
    echo "deb http://packages.ros.org/ros/ubuntu bionic main" > /etc/apt/sources.list.d/ros1-latest.list

# install bootstrap tools
RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosdep \
    python-rosinstall \
    python-vcstools \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# setup environment
ENV LANG=C.UTF-8
ENV LC_ALL=C.UTF-8

# bootstrap rosdep
RUN rosdep init \
    && rosdep update

# install ros packages
ENV ROS_DISTRO melodic
RUN apt-get update && apt-get install -y \ 
    ros-${ROS_DISTRO}-ros-core=1.4.1-0* \
    ros-${ROS_DISTRO}-perception=1.4.1-0* \
    ros-${ROS_DISTRO}-rgbd-launch \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# setup entrypoint
COPY ./ros_entrypoint.sh /

WORKDIR /tmp

# installing tensorflow from wheel
RUN apt-get update && apt-get install -y python3-pip && rm -rf /var/lib/apt/lists/*
RUN wget https://developer.download.nvidia.com/compute/redist/jp/v43/tensorflow-gpu/tensorflow_gpu-1.15.0+nv19.12-cp36-cp36m-linux_aarch64.whl
RUN pip3 install cython
RUN pip3 install numpy
RUN pip3 install tensorflow_gpu-1.15.0+nv19.12-cp36-cp36m-linux_aarch64.whl \
        Pillow pandas

# set the version of the realsense library
ENV LIBREALSENSE_VERSION 2.24.0
RUN wget https://github.com/IntelRealSense/librealsense/archive/v${LIBREALSENSE_VERSION}.tar.gz && \
    tar -xvzf v${LIBREALSENSE_VERSION}.tar.gz && \
    rm v${LIBREALSENSE_VERSION}.tar.gz && \
    mkdir -p librealsense-${LIBREALSENSE_VERSION}/build && \
    cd librealsense-${LIBREALSENSE_VERSION}/build && \
    cmake .. && \
    make && \
    make install && \
    rm -rf librealsense-${LIBREALSENSE_VERSION}


ENTRYPOINT ["/ros_entrypoint.sh"]
WORKDIR /
CMD ["bash"]
