#!/bin/bash

if [ -f /opt/rh/devtoolset-8/enable ] ; then
        source /opt/rh/devtoolset-8/enable
fi

if [ -f /opt/rh/rh-python36/enable ] ; then
        source /opt/rh/rh-python36/enable
fi

BUILD_ENV_DIR=$(readlink -f ./build_env/)

VENV_DIR=${BUILD_ENV_DIR}/zephyr_venv/

export PATH=${BUILD_ENV_DIR}/install/bin/:$PATH

source $VENV_DIR/bin/activate

mkdir -p zephyrproject

pushd zephyrproject

west init -m https://github.com/lowlander/zephyr.git --mr zpp_module

west update

popd

pip install -r ./zephyrproject/zephyr/scripts/requirements.txt

