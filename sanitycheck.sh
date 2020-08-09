#!/bin/bash

source env_setup.sh

./zephyrproject/zephyr/scripts/sanitycheck -T ./zephyrproject/modules/zpp $@

