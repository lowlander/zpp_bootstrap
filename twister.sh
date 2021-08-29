#!/bin/bash

source env_setup.sh

./zephyrproject/zephyr/scripts/twister -T ./zephyrproject/modules/zpp $@

