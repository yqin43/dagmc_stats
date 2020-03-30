FROM  ubuntu:18.04

# set timezone
ENV HOME /root
ENV TZ=America/Chicago
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# ubuntu setup
RUN apt-get update
RUN apt-get install -y --fix-missing \
    software-properties-common \
    wget \
    build-essential \
    python-setuptools \
    python-numpy \
    python-pip \
    python-tables \
    python-matplotlib \
    git \
    cmake \
    vim \
    emacs \
    nano \
    gfortran \
    autoconf \
    libtool \
    cpio \
    libblas-dev \
    liblapack-dev \
    libhdf5-dev

RUN pip install Cython pytest

# build MOAB
RUN cd $HOME \
    && mkdir opt \
    && cd opt \
    && mkdir moab \
    && cd moab \
    && git clone https://bitbucket.org/fathomteam/moab \
    && cd moab \
    && git checkout -b Version5.1.0 origin/Version5.1.0 \
    && autoreconf -fi \
    && cd .. \
    && mkdir build \
    && cd build \
    && ../moab/configure --enable-shared --enable-optimize --enable-pymoab --disable-debug --with-hdf5=/usr/lib/x86_64-linux-gnu/hdf5/serial --prefix=$HOME/opt/moab \
    && make \
    && make install \
    && cd .. \
    && rm -rf build moab

# set environment variables
ENV PATH $HOME/opt/moab/bin/:$PATH
ENV LD_LIBRARY_PATH $HOME/opt/moab/lib:$LD_LIBRARY_PATH
ENV PYTHONPATH $HOME/opt/moab/lib/python2.7/site-packages/:$PYTHONPATH
