#!/bin/bash

source env_setup.sh

pushd zephyrproject

west update

popd

pip install -r ./zephyrproject/zephyr/scripts/requirements.txt

