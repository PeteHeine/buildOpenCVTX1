#!/bin/bash
# License: MIT. See license file in root directory
# Copyright(c) JetsonHacks (2017)
# Get more inspiration from 
# 1) https://stackoverflow.com/questions/37188623/ubuntu-how-to-install-opencv-for-python3?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# 2) https://www.begueradj.com/installing-opencv-3.2.0-for-python-3.5.2-on-ubuntu-16.04.2-lts.html

OPENCV_VERSION='3.4.1'

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

# Python 3.5
sudo apt-get install -y python3.5-dev
sudo apt-get install -y python-devel
sudo apt-get install -y python3-numpy

# Computation libraries 
sudo apt-get install -y libatlas-base-dev numpy gfortran

# GStreamer support
sudo apt-get install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev 

sudo apt-get install -y ocl-icd-opencl-dev
sudo apt-get install -y libomp-dev

# Consider using a virtual environment
#pip install virtualenv --user
#wget https://bootstrap.pypa.io/get-pip.py

#pip install numpy
#sudo apt-get install -y python3-pip
#sudo pip3 install virtualenv 

# Version have been updated to 3.4.1. However, this have not been tested. 
cd ..
git clone https://github.com/opencv/opencv.git
cd opencv
git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}
cd ..

# THIS HAVENT BEEN TESTED
git clone https://github.com/opencv/opencv_contrib.git
cd opencv_contrib
git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}
cd ..

git clone https://github.com/opencv/opencv_extra.git
cd opencv_extra
git checkout -b v${OPENCV_VERSION} ${OPENCV_VERSION}
cd ..

#cd ~/
#virtualenv cv_virtual_env
#source cv_virtual_env/bin/activate

#sudo apt-get install -y python3-numpy
#cd -


cd opencv
mkdir build
cd build
# Jetson TX1 
cmake \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=/usr \
    -DBUILD_PNG=ON \
    -DBUILD_TIFF=ON \
    -DBUILD_TBB=ON \
    -DBUILD_JPEG=ON \
    -DBUILD_JASPER=OFF \
    -DBUILD_ZLIB=ON \
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
    -DENABLE_FAST_MATH=1 \
    -DCUDA_FAST_MATH=1 \
    -DWITH_CUBLAS=1 \
    -DWITH_GTK=ON \
    -DWITH_VTK=ON \
    -DWITH_TBB=ON \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
    -DCUDA_ARCH_BIN=5.3 \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=ON \
    -DINSTALL_TESTS=ON \
    -DOPENCV_TEST_DATA_PATH=../opencv_extra \
    -DOPENCV_EXTRA_MODULES_PATH=../opencv_extra/modules \
    ../


#    -DPYTHON_EXECUTABLE=/usr/bin/python3 \
#    -DBUILD_PNG=OFF \
#    -DBUILD_TIFF=OFF \
#    -DBUILD_JPEG=OFF \
#    -DBUILD_ZLIB=OFF \
#    -DWITH_VTK=OFF \
# Consider running jetson_clocks.sh before compiling
make -j4


