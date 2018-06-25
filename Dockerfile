FROM nvidia/cuda:9.0-cudnn7-devel-ubuntu16.04
# FROM nvidia/cuda:9.0-devel-ubuntu16.04

LABEL maintainer='Yaxuan Dai <daiyaxuan2018@outlook.com>'

# cudnn provided, run ./run.sh firstly.
# RUN cd /root && mkdir Setup
# COPY cudnn.deb /root/Setup/
# COPY cudnn_patch1.deb /root/Setup/
# COPY cudnn_patch2.deb /root/Setup/
# RUN dpkg -i /root/Setup/cudnn.deb && dpkg -i /root/Setup/cudnn_patch1.deb && dpkg -i /root/Setup/cudnn_patch2.deb 
# ENV LD_LIBRARY_PATH="/usr/local/cuda-9.0/lib64:$LD_LIBRARY_PATH"


# Essentials: developer tools, build tools, OpenBLAS
RUN apt-get update && apt-get install -y --no-install-recommends \
    apt-utils git curl vim unzip openssh-client wget \
    build-essential cmake \
    libopenblas-dev

#
# Python 3.5
#
# For convenience, alias (but don't sym-link) python & pip to python3 & pip3 as recommended in:
# http://askubuntu.com/questions/351318/changing-symlink-python-to-python3-causes-problems
RUN apt-get install -y --no-install-recommends python3.5 python3.5-dev python3-pip python3-tk && \
    pip3 install --no-cache-dir --upgrade pip setuptools && \
    echo "alias python='python3'" >> /root/.bash_aliases && \
    echo "alias pip='pip3'" >> /root/.bash_aliases
# Pillow and it's dependencies
RUN apt-get install -y --no-install-recommends libjpeg-dev zlib1g-dev && \
    pip3 --no-cache-dir install Pillow
# Science libraries and other common packages
RUN pip3 --no-cache-dir install \
    numpy scipy sklearn scikit-image pandas matplotlib Cython requests

#
# Java
#
# Install JDK (Java Development Kit), which includes JRE (Java Runtime
# Environment). Or, if you just want to run Java apps, you can install
# JRE only using: apt install default-jre
RUN apt-get install -y --no-install-recommends default-jdk

#
# Jupyter Notebook
#
# Allow access from outside the container, and skip trying to open a browser.
# NOTE: disable authentication token for convenience. DON'T DO THIS ON A PUBLIC SERVER.
RUN pip3 --no-cache-dir install jupyter && \
    mkdir /root/.jupyter && \
    echo "c.NotebookApp.ip = '*'" \
         "\nc.NotebookApp.open_browser = False" \
         "\nc.NotebookApp.token = ''" \
         > /root/.jupyter/jupyter_notebook_config.py
EXPOSE 8888

#
# OpenCV 3.4.1
#
# Dependencies
RUN apt-get install -y --no-install-recommends \
    libjpeg8-dev libtiff5-dev libjasper-dev libpng12-dev \
    libavcodec-dev libavformat-dev libswscale-dev libv4l-dev libgtk2.0-dev \
    liblapacke-dev checkinstall
# Get source from github
# RUN git clone -b 3.4.1 --depth 1 https://github.com/opencv/opencv.git /usr/local/src/opencv
# Compile
# RUN cd /usr/local/src/opencv && mkdir build && cd build && \
#     cmake -D CMAKE_INSTALL_PREFIX=/usr/local \
#           -D BUILD_TESTS=OFF \
#           -D BUILD_PERF_TESTS=OFF \
#           -D PYTHON_DEFAULT_EXECUTABLE=$(which python3) \
#           .. && \
#     make -j6 2>/dev/null && \
#     make -j6 install 2>/dev/null

RUN apt-get update && \
        apt-get install -y \
        yasm \
        pkg-config \
        libswscale-dev \
        libtbb2 \
        libtbb-dev \
        libtiff-dev \
        libjasper-dev \
        libavformat-dev \
        libpq-dev

WORKDIR /

ENV OPENCV_VERSION="3.4.1"

RUN wget https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip \
&& unzip ${OPENCV_VERSION}.zip 

# RUN mkdir /opencv-${OPENCV_VERSION}/cmake_binary \
# && cd /opencv-${OPENCV_VERSION}/cmake_binary \
# && cmake -j6 2>/dev/null -DBUILD_TIFF=ON \
#   -DBUILD_opencv_java=ON \
#   -DWITH_CUDA=ON\
#   -DENABLE_AVX=ON \
#   -DWITH_OPENGL=ON \
#   -DWITH_OPENCL=ON \
#   -DWITH_IPP=ON \
#   -DWITH_TBB=ON \
#   -DWITH_EIGEN=ON \
#   -DWITH_V4L=ON \
#   -DBUILD_TESTS=OFF \
#   -DBUILD_PERF_TESTS=OFF \
#   -DCMAKE_BUILD_TYPE=RELEASE \
#   -DCMAKE_INSTALL_PREFIX=$(python3 -c "import sys; print(sys.prefix)") \
#   -DPYTHON_EXECUTABLE=$(which python3) \
#   -DPYTHON_INCLUDE_DIR=$(python3 -c "from distutils.sysconfig import get_python_inc; print(get_python_inc())") \
#   -DPYTHON_PACKAGES_PATH=$(python3 -c "from distutils.sysconfig import get_python_lib; print(get_python_lib())") .. \
# && make -j6 2>/dev/null install \
# RUN  rm /${OPENCV_VERSION}.zip \
# && rm -r /opencv-${OPENCV_VERSION}

# When installing opencv/version
# Set runtime path of "/usr/bin/opencv_version" to "/usr/lib/x86_64-linux-gnu:/usr/local/cuda/lib64"
# returned with nonzero value: 2

#
# Caffe
#
# Dependencies
RUN apt-get install -y --no-install-recommends \
    libhdf5-serial-dev protobuf-compiler liblmdb-dev libgoogle-glog-dev \
    libboost-all-dev liblapack-dev libatlas-base-dev libgflags-dev \
    libprotobuf-dev libleveldb-dev libsnappy-dev libopencv-dev 
# Get source. Use master branch with edited config file.
RUN git clone -b master https://github.com/TagineerDai/caffe.git /usr/local/src/caffe
# Python dependencies
RUN pip3 --no-cache-dir install lmdb
RUN pip3 --no-cache-dir install -r /usr/local/src/caffe/python/requirements.txt

# Compile
# ERROR REF https://blog.csdn.net/w5688414/article/details/78563398
RUN apt-get install python-numpy -y 

RUN cd /usr/local/src/caffe && \
    make -j"$(nproc)" all
 
RUN cd /usr/local/src/caffe && \
    make -j"$(nproc)" test

RUN cd /usr/local/src/caffe && \
    make -j"$(nproc)" pycaffe && \
    make runtest

#
# Tensorflow 1.6.0
#
RUN pip3 install --no-cache-dir --upgrade tensorflow-gpu

# Expose port for TensorBoard
EXPOSE 6006

#
# Keras 2.2.0
#
RUN pip3 install --no-cache-dir --upgrade h5py pydot_ng keras

#
# PyTorch 0.4.0
#
RUN pip3 install --no-cache-dir --upgrade torch torchvision

#
# MXNet 1.2.0
#
RUN pip3 install --no-cache-dir --upgrade mxnet-cu90 --pre

RUN pip3 uninstall python-dateutil -y 
RUN pip3 install --upgrade python-dateutil
 
# Environment variables
ENV PYTHONPATH=/usr/local/src/caffe/python:$PYTHONPATH \
	PATH=/usr/local/src/caffe/build/tools:$PATH

WORKDIR "/root"
CMD ["/bin/bash"]
