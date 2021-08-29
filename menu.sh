#!/bin/bash

source ./env_setup.sh

pushd ./build/

ninja menuconfig

popd
