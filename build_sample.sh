#!/bin/bash

if [ -z $ZPP_BOARD ] ; then
	ZPP_BOARD=olimex_stm32_p405
fi

if [ -z $ZPP_SAMPLE ] ; then
	ZPP_SAMPLE=thread/
fi

echo "board: ${ZPP_BOARD}"
echo "sample: ${ZPP_SAMPLE}"

source env_setup.sh

pushd zephyrproject

west build -b  ${ZPP_BOARD}  zpp/samples/${ZPP_SAMPLE}

popd
