[![](https://codeship.io/projects/0d586220-c9fe-0131-eedd-762fd394af47/status)](https://www.codeship.io/projects/22499)
# SmartPanel Node
This is the software that runs on the SmartPanel devices. Currently this is a Raspberry Pi (Model B, Rev 2) running Raspbian Jan 2015 (Debian Wheezy).

To bootstrap your Raspberry Pi first install Raspbian via NOOBS (generally comes on the SD card) and run the following command:
```shell
bash <(curl -fsSL https://raw.github.com/brightbit/smartpanel-node/master/bootstrap.sh)
```

This should install everything needed to setup a Pi from scratch. It will check this repo out into `/etc/smartpanel`. Development of this script is just beginning.

####TODO: Document headlessly flashing/setting up Pi

