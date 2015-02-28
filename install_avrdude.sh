#!/bin/bash

#sudo apt-get install libusb-1.0-0-dev libusb-dev libftdi-dev libftdi1 libelf-dev autoconf bison flex

AVRDUDE_NAME=avrdude-6.1

AVRDUDE_TGZ=${AVRDUDE_NAME}.tar.gz
AVRDUDE_PATCH=patches/${AVRDUDE_NAME}.patch
AVRDUDE_URL=http://download.savannah.gnu.org/releases/avrdude/${AVRDUDE_TGZ}

# delete old directory
if [ -d ${AVRDUDE_NAME} ]; then
	echo "Found old ${AVRDUDE_NAME}: deleting..."
	rm -rf ${AVRDUDE_NAME}
fi

# get tar.gz if necessary
if [ ! -f ${AVRDUDE_TGZ} ]; then
	echo "${AVRDUDE_TGZ} not found. Getting it..."
	wget ${AVRDUDE_URL} || { echo "Error getting "${AVRDUDE_TGZ}; exit 1; }
fi

# extract
if [ -f ${AVRDUDE_TGZ} ]; then
	echo "Found ${AVRDUDE_TGZ}: extracting..."
	tar -xzvf ${AVRDUDE_TGZ} || { echo "Error extracting "${AVRDUDE_TGZ}; exit 1; }
fi

# patch avrdude.conf.in
patch -p1 -d ${AVRDUDE_NAME} < ${AVRDUDE_PATCH} || { echo "Error patching "${AVRDUDE_NAME}; exit 1; }

# bootstrap, compile, install
cd ${AVRDUDE_NAME}
./bootstrap
./configure --enable-linuxgpio=yes --prefix=/usr --sysconfdir=/etc
make
#sudo make install
cd ..

# so we don't need sudo
#sudo chmod 4755 /usr/bin/avrdude
