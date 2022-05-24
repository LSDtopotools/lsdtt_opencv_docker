# This is the lsdtopotools opencv docker container
# It includes packages needed to run the valley metrics code in lsdtopotools
# lsdtt command line tools, conda and opencv are installed

# Pull base image. We start from the miniconda image
FROM continuumio/miniconda3
MAINTAINER Fiona Clubb (fiona.j.clubb@durham.ac.uk) and Simon Mudd (simon.m.mudd@ed.ac.uk)

# Need this to shortcut the stupid tzdata noninteractive thing
#ARG DEBIAN_FRONTEND=noninteractive

# We need some stuff to get lsdtopotools to install
RUN apt-get --allow-releaseinfo-change update && apt-get -qq install -y --no-install-recommends \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    yasm \
    pkg-config \
    libswscale-dev \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libopenjp2-7-dev \
    libavformat-dev \
    libpq-dev \
    libfftw3-dev \
    libgl1-mesa-glx \
&& rm -rf /var/lib/apt/lists/*

# Update conda
RUN conda install -y -c conda-forge conda

# Add the conda forge
RUN conda config --add channels conda-forge

# Set the channel
RUN conda config --set channel_priority strict

# Add git and python
RUN conda install -y git python

# Install opencv - conda
#RUN conda install -y opencv
# Install opencv from source as conda doesn't work
RUN wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip \
&& unzip opencv.zip \
# Create build directory
&& mkdir -p build && cd build \
# Configure
&& cmake  ../opencv-master \
# Build
&& cmake --build . \
&& make install

# Add gdal
RUN conda install -y gdal

# Set the working directory
WORKDIR /LSDTopoTools

# Clone LSDTopoTools2
RUN git clone https://github.com/LSDtopotools/LSDTopoTools2.git
# Switch to the OpenCV branch
RUN cd LSDTopoTools2/ && git checkout -b opencv && git pull origin opencv && cd src/ && bash build.sh \
# Copy the binaries to the path
&& cp lsdtt-basic-metrics /usr/local/bin/ \
&& cp lsdtt-channel-extraction /usr/local/bin/ \
&& cp lsdtt-chi-mapping /usr/local/bin/ \
&& cp lsdtt-hillslope-channel-coupling /usr/local/bin/ \
&& cp lsdtt-valley-metrics /usr/local/bin/

# make executable
RUN chmod +x /usr/local/bin/lsdtt-basic-metrics && chmod +x /usr/local/bin/lsdtt-channel-extraction \
&& chmod +x /usr/local/bin/lsdtt-chi-mapping && chmod +x /usr/local/bin/lsdtt-hillslope-channel-coupling \
&& chmod +x /usr/local/bin/lsdtt-valley-metrics
