#!/bin/bash

if [ -f /opt/rh/devtoolset-8/enable ] ; then
	source /opt/rh/devtoolset-8/enable
fi

if [ -f /opt/rh/rh-python36/enable ] ; then
	source /opt/rh/rh-python36/enable
fi

CMAKE_VERSION=3.15.4
CMAKE_FILE=cmake-${CMAKE_VERSION}.tar.gz
CMAKE_URL=https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz

NINJA_VERSION=1.9.0
NINJA_FILE=ninja-${NINJA_VERSION}.tar.gz
NINJA_URL=https://github.com/ninja-build/ninja/archive/v${NINJA_VERSION}.tar.gz


mkdir -p ./downloads/

DOWNLOAD_DIR=$(readlink -f ./downloads)

#
# Download needed source code
#
pushd $DOWNLOAD_DIR

  if [ ! -f $CMAKE_FILE ] ; then
    echo "Downloading cmake ${CMAKE_VERSION}"
    curl -Lk -o $CMAKE_FILE $CMAKE_URL || exit
  fi

  if [ ! -f $NINJA_FILE ] ; then
    echo "Downloading ninja ${NINJA_VERSION}"
    curl -Lk -o $NINJA_FILE $NINJA_URL || exit
  fi

popd

#
# Build host tools
#

rm -rf ./build_env/
mkdir -p ./build_env/install/

BUILD_ENV_DIR=$(readlink -f ./build_env)
INSTALL_DIR=${BUILD_ENV_DIR}/install

pushd $BUILD_ENV_DIR

  tar -xf ${DOWNLOAD_DIR}/${NINJA_FILE}

  pushd ninja-${NINJA_VERSION}

    ./configure.py --bootstrap --verbose
    mkdir -p ${INSTALL_DIR}/bin/
    cp ninja ${INSTALL_DIR}/bin/

  popd

  tar -xf ${DOWNLOAD_DIR}/${CMAKE_FILE}

  pushd cmake-${CMAKE_VERSION}

    ./bootstrap --prefix=${INSTALL_DIR}
    make -j
    make install

  popd

popd

VENV_DIR=${BUILD_ENV_DIR}/zephyr_venv/

rm -rf $VENV_DIR
mkdir -p $VENV_DIR

virtualenv $VENV_DIR

source $VENV_DIR/bin/activate

pip install --upgrade pip
pip install --upgrade setuptools
pip install --upgrade west
