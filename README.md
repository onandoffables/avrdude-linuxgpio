avrdude-linuxgpio
=================

This script downloads, patches, compiles, and installs a plain, vanilla [avrdude-6.2](http://download.savannah.gnu.org/releases/avrdude/avrdude-6.2.tar.gz) as you can get it from [download.savannah.gnu.org](http://download.savannah.gnu.org/releases/avrdude/).

The install script and patch enable avrdude to bitbang GPIO pins (such as on the Raspberry Pi GPIO) using the 'linuxgpio' (sysfsgpio) interface that's standard available in avrdude-6.2.

The patch assumes that you want to program an AVR from the Raspberry Pi with the following connections. The numbers are Raspberry Pi BCM pin numbers, and are compatible with "Gordon's avrdude" on the Pi.

	RESET   =  8
	SCK     =  11
	MOSI    =  10
	MISO    =  9

Make sure you're up to date:

	sudo apt-get update
	sudo apt-get upgrade

You need to install some packages to be able to build avrdude from source:

	sudo apt-get install libusb-1.0-0-dev libftdi-dev autoconf bison flex bc libtool

To include libelf, also install libelf-dev. Note that you then also need to add 'libelf1 (>= 0.142)' as an extra dependency in the deb package (add in make_deb.sh).

Then get this repository from github and run 'install_avrdude.sh':

	git clone https://github.com/onandoffables/avrdude-linuxgpio
	cd avrdude-linuxgpio
	./install_avrdude.sh

avrdude usage example:

	avrdude -c linuxgpio -p atmega328p -U flash:w:blinky.hex
