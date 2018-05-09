#!/bin/bash
# License: MIT. See license file in root directory
# Copyright(c) JetsonHacks (2017)
# Get more inspiration from 
# 1) https://stackoverflow.com/questions/37188623/ubuntu-how-to-install-opencv-for-python3?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# 2) https://www.begueradj.com/installing-opencv-3.2.0-for-python-3.5.2-on-ubuntu-16.04.2-lts.html

sudo apt-get install -y \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libjpeg-dev \
    libpng12-dev \
    libjasper-dev \
    libavcodec-dev \
    libavformat-dev \
    libavutil-dev \
    libpostproc-dev \
    libswscale-dev \
    libeigen3-dev \
    libtbb-dev \
    libgtk2.0-dev \ 
    cmake \
    pkg-config



# Optional 
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev libv4l-dev libxvidcore-dev libx264-dev libgtk-3-dev libjpeg8-dev 


# Python 2.7
sudo apt-get install -y python-dev python-numpy python-py python-pytest

sudo apt-get install -y python3.5-dev
sudo apt-get install -y python-devel

# Computation libraries 
sudo apt-get install -y libatlas-base-dev numpy gfortran

# GStreamer support
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 

sudo apt-get install -y ocl-icd-opencl-dev
sudo apt-get install -y libomp-dev

#pip install virtualenv --user
#wget https://bootstrap.pypa.io/get-pip.py

#sudo python3 get-pip.py
#sudo pip3 install virtualenv virtualenvwrapper

#pip install numpy
sudo apt-get install -y python3-pip
sudo pip3 install virtualenv 


cd ..
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout -b v3.3.0 3.3.0
cd ..

git clone https://github.com/opencv/opencv_extra.git
cd opencv_extra
git checkout -b v3.3.0 3.3.0
cd ..

virtualenv cv_virtual_env
cd cv_virtual_env
source bin/activate
cd ..


cd opencv
sudo mkdir build
cd build
# Jetson TX1 
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_PNG=OFF \
    -DBUILD_TIFF=OFF \
    -DBUILD_TBB=OFF \
    -DBUILD_JPEG=OFF \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=OFF \
    -DBUILD_EXAMPLES=ON \
    -DBUILD_opencv_java=OFF \
    -DBUILD_opencv_python2=ON \
    -DBUILD_opencv_python3=ON \
    -DENABLE_PRECOMPILED_HEADERS=OFF \
    -DWITH_OPENCL=ON \
    -DWITH_OPENMP=ON \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_CUDA=ON \
    -DWITH_GTK=ON \
    -DWITH_VTK=OFF \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
    -DCUDA_ARCH_BIN=5.3 \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=ON \
    -DOPENCV_TEST_DATA_PATH=../opencv_extra/testdata \
    ../

# Consider running jetson_clocks.sh before compiling
make -j4
make

