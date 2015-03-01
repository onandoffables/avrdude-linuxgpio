#!/bin/bash

#sudo apt-get install libusb-1.0-0-dev libftdi-dev autoconf bison flex

target=avrdude-6.1

tgz=${target}.tar.gz
patch=patches/${target}.patch
url=http://download.savannah.gnu.org/releases/avrdude/${tgz}

# delete old directory
if [ -d ${target} ]; then
	echo "Found old ${target}: deleting..."
	rm -rf ${target}
fi

# get tar.gz if necessary
if [ ! -f ${tgz} ]; then
	echo "${tgz} not found. Getting it..."
	wget ${url} || { echo "Error getting "${tgz}; exit 1; }
fi

# extract
if [ -f ${tgz} ]; then
	echo "Found ${tgz}: extracting..."
	tar -xzvf ${tgz} || { echo "Error extracting "${tgz}; exit 1; }
fi

# patch avrdude.conf.in
patch -p1 -d ${target} < ${patch} || { echo "Error patching "${target}; exit 1; }

# bootstrap, compile, install
cd ${target}
./bootstrap
./configure --enable-linuxgpio=yes --prefix=/usr --sysconfdir=/etc
make
cd ..
