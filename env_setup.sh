#!/bin/bash


if [ -f /opt/rh/gcc-toolset-11/enable ] ; then
	source /opt/rh/gcc-toolset-11/enable
fi

DOWNLOAD_DIR=$(readlink -f ./upstream/downloads/)
BUILD_DIR=$(readlink -f ./upstream/build/)
INSTALL_DIR=$(readlink -f ./install/)

PATH=${INSTALL_DIR}/bin:$PATH
LD_LIBRARY_PATH=${INSTALL_DIR}/lib:$LD_LIBRARY_PATH
PKG_CONFIG_PATH=${INSTALL_DIR}/lib/pkgconfig:${PKG_CONFIG_PATH}

CMAKE=${INSTALL_DIR}/bin/cmake
NINJA=${INSTALL_DIR}/bin/ninja

export ZEPHYR_TOOLCHAIN_VARIANT=zephyr

if [ -d /data/opt/zephyr-sdk-0.14.2/ ] ; then
	export ZEPHYR_SDK_INSTALL_DIR=/data/opt/zephyr-sdk-0.14.2/
else
	export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk/
fi

source ${ZEPHYR_SDK_INSTALL_DIR}/environment-setup-x86_64-pokysdk-linux

# export WEST_DIR=$(readlink -f ./zephyrproject/.west/west/)

VENV_DIR=${INSTALL_DIR}/zephyr_venv/

source $VENV_DIR/bin/activate

source ./zephyrproject/zephyr/zephyr-env.sh

