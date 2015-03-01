#!/bin/bash

deb=avrdude_6.1-2_armhf.deb

if [ ! -f ${deb} ]; then
	./make_deb.sh
fi

if [ -f ${deb} ]; then
	sudo dpkg -i ${deb}
	sudo apt-get install -f
fi

# so we don't need sudo
sudo chmod 4755 /usr/bin/avrdude
