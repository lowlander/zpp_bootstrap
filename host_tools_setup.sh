#!/bin/bash

if [ -f /opt/rh/gcc-toolset-11/enable ] ; then
        source /opt/rh/gcc-toolset-11/enable
fi

CMAKE_VERSION=3.23.2
RE2C_VERSION=3.0
NINJA_VERSION=1.11.0

rm -rf ./install/ || exit 1
rm -rf ./upstream/build/ || exit 1

mkdir -p ./install/ || exit 1
mkdir -p ./upstream/build/ || exit 1
mkdir -p ./upstream/downloads/ || exit 1

DOWNLOAD_DIR=$(readlink -f ./upstream/downloads/)
BUILD_DIR=$(readlink -f ./upstream/build/)
INSTALL_DIR=$(readlink -f ./install/)

mkdir -p ${INSTALL_DIR}/usr/ || exit 1
mkdir -p ${INSTALL_DIR}/lib/ || exit 1
mkdir -p ${INSTALL_DIR}/bin/ || exit 1
mkdir -p ${INSTALL_DIR}/include/ || exit 1
mkdir -p ${INSTALL_DIR}/share/ || exit 1

ln -s ${INSTALL_DIR}/lib ${INSTALL_DIR}/lib64 || exit 1
ln -s ${INSTALL_DIR}/lib ${INSTALL_DIR}/usr/lib || exit 1
ln -s ${INSTALL_DIR}/lib ${INSTALL_DIR}/usr/lib64 || exit 1

ln -s ${INSTALL_DIR}/bin ${INSTALL_DIR}/usr/bin || exit 1

ln -s ${INSTALL_DIR}/include ${INSTALL_DIR}/usr/include || exit 1

ln -s ${INSTALL_DIR}/share ${INSTALL_DIR}/usr/share || exit 1

PATH=${INSTALL_DIR}/bin:$PATH
LD_LIBRARY_PATH=${INSTALL_DIR}/lib:$LD_LIBRARY_PATH
PKG_CONFIG_PATH=${INSTALL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}

CMAKE=${INSTALL_DIR}/bin/cmake

pushd ./upstream/build/

rm -rf re2c-${RE2C_VERSION}/
if [ ! -f ${DOWNLOAD_DIR}/re2c-${RE2C_VERSION}.tar.xz ]
then
	curl -Lk -o \
		${DOWNLOAD_DIR}/re2c-${RE2C_VERSION}.tar.xz \
		https://github.com/skvadrik/re2c/releases/download/${RE2C_VERSION}/re2c-${RE2C_VERSION}.tar.xz
fi

tar -xf ${DOWNLOAD_DIR}/re2c-${RE2C_VERSION}.tar.xz  || exit 1

pushd re2c-${RE2C_VERSION}/

./configure \
	--prefix=${INSTALL_DIR}/ \
	|| exit 1

make || exit 1

make install || exit 1


popd # re2c-${RE2C_VERSION}/




rm -rf ninja-${NINJA_VERSION}/

if [ ! -f ${DOWNLOAD_DIR}/ninja-${NINJA_VERSION}.tar.gz ] 
then
	curl -Lk -o  \
		${DOWNLOAD_DIR}/ninja-${NINJA_VERSION}.tar.gz \
		https://github.com/ninja-build/ninja/archive/v${NINJA_VERSION}.tar.gz
fi 

tar -xf ${DOWNLOAD_DIR}/ninja-${NINJA_VERSION}.tar.gz || exit 1

pushd ninja-${NINJA_VERSION}/

./configure.py \
        --bootstrap || exit 1

mkdir -p ${INSTALL_DIR}/usr/bin/
cp ninja ${INSTALL_DIR}/usr/bin/

popd # ninja-${NINJA_VERSION}/


rm -rf cmake-${CMAKE_VERSION}/

if [ ! -f ${DOWNLOAD_DIR}/cmake-${CMAKE_VERSION}.tar.gz ]
then
	curl -Lk -o  \
		${DOWNLOAD_DIR}/cmake-${CMAKE_VERSION}.tar.gz \
		https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}.tar.gz
fi

tar -xf ${DOWNLOAD_DIR}/cmake-${CMAKE_VERSION}.tar.gz || exit 1

pushd cmake-${CMAKE_VERSION}

./bootstrap \
        --prefix=${INSTALL_DIR} \
        || exit 1

make -j
make install

popd # cmake-${CMAKE_VERSION}

popd # ./upstream/build/


VENV_DIR=${INSTALL_DIR}/zephyr_venv/

rm -rf $VENV_DIR
mkdir -p $VENV_DIR

virtualenv -p python3.9 $VENV_DIR  || exit 1

source $VENV_DIR/bin/activate 

pip3 install --upgrade pip || exit 1
pip3 install --upgrade setuptools || exit 1
pip3 install --upgrade west || exit 1

pip3 install -r ./zephyrproject/zephyr/scripts/requirements.txt || exit 1

