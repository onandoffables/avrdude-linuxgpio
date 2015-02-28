#!/bin/bash

build=avrdude-6.1
target=avrdude_6.1-2_armhf

if [ ! -d ${build} ]; then
	echo "No ${build} directory found. Compiling avrdude..."
	./compile_avrdude.sh
fi

# delete old directory
if [ -d ${target} ]; then
	echo "Found old ${target}: deleting..."
	rm -rf ${target}
fi
# delete old .deb
if [ -f ${target}.deb ]; then
	echo "Found old ${target}.deb: deleting..."
	rm ${target}.deb
fi

echo "Creating directories..."
# DEBIAN
mkdir -p ${target}/DEBIAN

echo "Adding files..."
# DEBIAN/conffiles
echo "/etc/avrdude.conf" >> ${target}/DEBIAN/conffiles

# DEBIAN/control
echo "Package: avrdude
Version: 6.1-2
Architecture: armhf
Maintainer: Michael Biebl <biebl@debian.org>
Installed-Size: INSTALLED_SIZE
Depends: libc6 (>= 2.13-28), libelf1 (>= 0.142), libftdi1 (>= 0.20), libncurses5 (>= 5.5-5~), libreadline6 (>= 6.0), libtinfo5, libusb-0.1-4 (>= 2:0.1.12), libusb-1.0-0 (>= 2:1.0.8)
Suggests: avrdude-doc
Section: electronics
Priority: extra
Homepage: http://savannah.nongnu.org/projects/avrdude/
Description: software for programming Atmel AVR microcontrollers
 AVRDUDE is an open source utility to download/upload/manipulate the
 ROM and EEPROM contents of AVR microcontrollers using the in-system
 programming technique (ISP)." >> ${target}/DEBIAN/control

echo "Copying files..."
# etc/avrdude.conf
mkdir -p ${target}/etc
cp ${build}/avrdude.conf ${target}/etc

# usr/bin/avrdude
mkdir -p ${target}/usr/bin
cp ${build}/avrdude ${target}/usr/bin

echo "gzipping..."
# usr/share/man/man1/avrdude.1.gz
mkdir -p ${target}/usr/share/man/man1
gzip -c ${build}/avrdude.1 > ${target}/usr/share/man/man1/avrdude.1.gz

# changelogs and readme
mkdir -p ${target}/usr/share/doc/avrdude
gzfiles="ChangeLog
ChangeLog-2001
ChangeLog-2002
ChangeLog-2003
ChangeLog-2004-2006
ChangeLog-2007
ChangeLog-2008
ChangeLog-2009
ChangeLog-2010
ChangeLog-2011
ChangeLog-2012
ChangeLog-2013
NEWS"
for item in ${gzfiles}; do
	gzip -c ${build}/${item} > ${target}/usr/share/doc/avrdude/${item}.gz
done

cpfiles="AUTHORS
COPYING
README"
for item in ${cpfiles}; do
	cp ${build}/${item} ${target}/usr/share/doc/avrdude
done

# md5sums
echo "Creating md5sums..."
cd ${target}
md5sum `find . -type f | grep -v '^[.]/DEBIAN/'` | sed "s/.\///" >DEBIAN/md5sums
cd ..

# installed size
echo "Calculate installed size..."
cd ${target}
size=`du -s | awk '{print $1;}'`
sed -i -e "s/INSTALLED_SIZE/${size}/" DEBIAN/control
cd ..

# build
echo "Building .deb package..."
dpkg-deb --build ${target}
