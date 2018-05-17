
#!/bin/bash
# License: MIT. See license file in root directory
# Copyright(c) JetsonHacks (2017)
# Get more inspiration from 
# 1) https://stackoverflow.com/questions/37188623/ubuntu-how-to-install-opencv-for-python3?utm_medium=organic&utm_source=google_rich_qa&utm_campaign=google_rich_qa
# 2) https://www.begueradj.com/installing-opencv-3.2.0-for-python-3.5.2-on-ubuntu-16.04.2-lts.html


# Opencv version to be installed
OPENCV_VERSION='3.4.0'
# Use 3.4.0! (3.4.1 installs, but doesnt work with orb-slam. Tracking fails immediately for some unknown reason) 
 

echo "Installation of opencv (${OPENCV_VERSION}) ..."
sudo apt-get install -y \
    libglew-dev \
    libtiff5-dev \
    zlib1g-dev \
    libv4l-dev \
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
    qtbase5-dev \
    libgtk2.0-dev \ 
    libglew1.6-dev \
    cmake \
    pkg-config



# Optional 
sudo apt-get install -y libtbb2 libtbb-dev libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev libv4l-dev libxvidcore-dev libx264-dev libgtk-3-dev libjpeg8-dev d

# Install openblas (potentially used by opencv and numpy)
sudo apt-get install -y libopenblas-dev libopenblas-base

# TEST WORKAROUND (https://github.com/opencv/opencv/issues/9953#issuecomment-355124426)
#RUN THIS LINE: /usr/include/lapacke*.h to '/usr/include/openblas'
#cp /usr/include/lapacke*.h /usr/include/openblas
# To potentially fix below
#-- Found OpenBLAS libraries: /usr/lib/libopenblas.so
#-- Found OpenBLAS include: /usr/include/openblas
#-- LAPACK(OpenBLAS): LAPACK_LIBRARIES: /usr/lib/libopenblas.so
#CMake Warning at cmake/OpenCVFindLAPACK.cmake:29 (message):
#  LAPACK(OpenBLAS): CBLAS/LAPACK headers are not found in
#  '/usr/include/openblas'
#Call Stack (most recent call first):
#  cmake/OpenCVFindLAPACK.cmake:97 (ocv_lapack_check)
#  CMakeLists.txt:638 (include)


# Python 2.7
sudo apt-get install -y python-dev python-numpy python-py python-pytest
echo "Upgrade numpy (python2.7). This takes a long time!! "
python -m pip install --upgrade pip
python -m pip install numpy --upgrade --user

# Python 3.5
sudo apt-get install -y python3-dev python3-numpy python3-py python3-pytest 
echo "Upgrade numpy (python3.5). This takes a long time!! "
python3.5 -m pip install --upgrade pip
python3.5 -m pip install numpy --upgrade --user


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
    -DENABLE_NEON=ON \
    -DWITH_OPENCL=ON \
    -DWITH_FFMPEG=ON \
    -DWITH_GSTREAMER=ON \
    -DWITH_GSTREAMER_0_10=OFF \
    -DWITH_CUDA=ON \
    -DENABLE_FAST_MATH=1 \
    -DCUDA_FAST_MATH=1 \
    -DWITH_CUBLAS=1 \
    -DWITH_GTK=ON \
    -DWITH_VTK=ON \
    -DWITH_TBB=OFF \
    -DWITH_1394=OFF \
    -DWITH_OPENEXR=OFF \
    -DCUDA_TOOLKIT_ROOT_DIR=/usr/local/cuda-8.0 \
    -DBUILD_opencv_cudastereo=OFF \
    -DCUDA_ARCH_BIN=5.3 \
    -DCUDA_ARCH_PTX="" \
    -DINSTALL_C_EXAMPLES=OFF \
    -DINSTALL_TESTS=ON \
    -DOPENCV_TEST_DATA_PATH=../opencv_extra \
    -DOPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
    ../

# To avoid build bug in opencv. The cuda stereo is removed -DBUILD_opencv_cudastereo=OFF

# Reason why this build will not work as well as the one installed with apt-get. 
#	- DWITH_TBB=OFF \
#	- Use opencv 3.4.0 instead of 3.4.1
#	- Disable extra modules?
#	- Codecs stuff? Does the images look different? Measure the difference between the two. 

# Reasons why jetson board only uses 1 core.
# 	- Ensure that numpy uses OpenBLAS

# Consider running jetson_clocks.sh before compiling
make -j4


