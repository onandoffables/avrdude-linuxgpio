#!/bin/bash

# Copyright 2015 onandoffables <on@onandoffables.com>

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

deb=avrdude_6.2-2_armhf.deb

if [ ! -f ${deb} ]; then
	./make_deb.sh
fi

if [ -f ${deb} ]; then
	sudo dpkg -i ${deb}
	sudo apt-get install -f
fi

# so we don't need sudo
sudo chmod 4755 /usr/bin/avrdude
