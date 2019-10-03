#!/bin/bash

source env_setup.sh

pushd zephyrproject

west $@

popd

