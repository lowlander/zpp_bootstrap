#!/bin/bash

if [ -z $ZPP_BOARD ] ; then
	ZPP_BOARD=olimex_stm32_p405
fi

if [ -z $ZPP_SAMPLE ] ; then
	ZPP_SAMPLE=hello_world
fi

echo "board: ${ZPP_BOARD}"
echo "sample: ${ZPP_SAMPLE}"

source env_setup.sh

west build --pristine -b  ${ZPP_BOARD}  ./zephyrproject/modules/zpp/samples/${ZPP_SAMPLE}

