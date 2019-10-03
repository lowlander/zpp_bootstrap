
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

export ZEPHYR_TOOLCHAIN_VARIANT=zephyr

if [ -d /opt/zephyr-sdk-0.10.3/ ] ; then
	export ZEPHYR_SDK_INSTALL_DIR=/opt/zephyr-sdk-0.10.3/
else
	echo "Toolchain /opt/zephyr-sdk-0.10.3/ not found"
	exit
fi

if [ -f ./zephyrproject/zephyr/zephyr-env.sh ] ; then
	source ./zephyrproject/zephyr/zephyr-env.sh
else
	echo "Zephyr zephyr-env.sh not found"
	exit
fi
