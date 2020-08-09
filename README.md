# ZPP bootstrap scripts

These scripts can be used to build and test the Zephyr zpp C++ library. They
are currently only testet on Centos8 so you might run into problems on other
distrubutions.

After cloning these scripts the first thing to do is to build the needed
host tools with the following command;

```
./host_tools_setup.sh
```

After the tools are build the other repositories can be cloned with the
following command;

```
./west.sh update
```

To build the sanity checks the following command can be used;

```
./sanitycheck.sh
```

To build the sample projects the following command can be used;

```
./build_sample.sh
```

By default `build_sample.sh` will build the `hello_world` example for the
`olimex_stm32_p405` board. This can be overridden by setting the `ZPP_BOARD`
and/or `ZPP_SAMPLE` environment variables.


Finally other `west` commands can be executed by using the following script;

```
./west.sh
```

