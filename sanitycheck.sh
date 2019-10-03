#!/bin/bash

source env_setup.sh

pushd ./zephyrproject/

./zephyr/scripts/sanitycheck -N -i -v --testcase-root zpp

popd

