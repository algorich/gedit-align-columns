# Align columns - gedit plugin
#
# Copyright (c) 2011 Hugo Henriques Maia Vieira
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# This Makefile was based on the Zoom plugin Makefile from Christian Luginbühl

# Version of the program (to be updated when creating new packages)
VERSION=0.1.0

# Name of the program
APPLICATION=gedit-align-columns

# Short name of the application
SHORT_NAME=align-columns

# Original author
AUTHOR="Hugo Maia Vieira"
AUTHOR_EMAIL="hugomaiavieira@gmail.com"

# Name of the translations files (without extension)
DOMAIN=messages

# Dummy target, that intercepts the call to 'make' (without explicit target)
dummy:
	echo "Possible targets are: dist, tgz, zip, update-locales, create-locale LOCALE={ll[_CC]}, clean, mrproper, install, install-dev, uninstall\n"

# Creates the .zip and .tar.gz packages
dist: tgz zip

# Packs everything needed to be deployed as a plugin into a gzipped tar
tgz: _create-distdir compile-locales
	tar czf dist/$(APPLICATION)-$(VERSION).tar.gz \
	        $(SHORT_NAME).gedit-plugin \
	        $(SHORT_NAME)/ \
	        --exclude *.po \
	        --exclude *.pyc

# Packs everything needed to be deployed as a plugin into a zip
zip: _create-distdir compile-locales
	zip -qr dist/$(APPLICATION)-$(VERSION).zip \
	        $(SHORT_NAME).gedit-plugin \
	        $(SHORT_NAME)/ \
	        -x *.po *.pyc

# Creates a new locale provided in the LOCALE-variable with a new .po-file
create-locale: _generate-pot _create_localedir
	if [ -n "$(LOCALE)" ] ; then \
		if [ ! -e "$(SHORT_NAME)/locale/$(LOCALE)/LC_MESSAGES/$(DOMAIN).po" ] ; then \
			msginit --locale=$(LOCALE) \
				    --input=$(DOMAIN).pot \
				    --output="$(SHORT_NAME)/locale/$(LOCALE)/LC_MESSAGES/$(DOMAIN).po" ; \
		    sed -i 's/PACKAGE/$(APPLICATION)/g' $(SHORT_NAME)/locale/$(LOCALE)/LC_MESSAGES/$(DOMAIN).po ; \
			echo "Make sure to also update '$(SHORT_NAME).gedit-plugin'" ; \
		fi \
	else \
		echo "Usage is: make create-locale LOCALE={ll[_CC]}\n" ; \
	fi

# Merges all locales with a new generated .pot-template
update-locales: _generate-pot
	find $(SHORT_NAME)/locale/ \
	     -name $(DOMAIN).po \
	     -exec msgmerge --update \
	                    --backup=none \
	                    {} $(DOMAIN).pot \;

# Generates the binary l10n .mo-files for all known languages
compile-locales:
	find $(SHORT_NAME)/locale/*/LC_MESSAGES \
	     -type d \
	     -exec msgfmt {}/$(DOMAIN).po -o {}/$(DOMAIN).mo \;

# Cleans up the directory structure
clean:
	rm -rf dist/
	rm -f $(DOMAIN).pot

# Cleans more thoroughly (including .mo-files and .pyc that are not needed for git updates)
mrproper: clean
	find . -name "*.pyc" -exec rm {} \;
	find $(SHORT_NAME)/locale -name "*.mo" -exec rm {} \;

# Installs the plugin in ~/.gnome2/gedit/plugins
install: uninstall
	tar zxfv dist/$(APPLICATION)-$(VERSION).tar.gz -C ~/.gnome2/gedit/plugins
	rm ~/.gnome2/gedit/plugins/README.md

# Symlinks the development version of the plugin in ~/.gnome2/gedit/plugins
install-dev: uninstall
	ln -s `pwd`/$(SHORT_NAME).gedit-plugin \
	      `pwd`/$(SHORT_NAME)/ \
	      ~/.gnome2/gedit/plugins/

uninstall:
	rm -rf ~/.gnome2/gedit/plugins/$(SHORT_NAME)*

# Creates a dist/ directory where packages are saved (private)
_create-distdir:
	mkdir -p dist

# Creates a directory structure for a new locale if set (private)
_create_localedir:
	if [ -n "$(LOCALE)" ] ; then \
		mkdir -p $(SHORT_NAME)/locale/$(LOCALE)/LC_MESSAGES ; \
	fi

# Generates a l10n .po-template by searching through source files (private)
_generate-pot:
	xgettext --language=Python \
	         --copyright-holder=$(AUTHOR) \
	         --package-name=$(APPLICATION) \
	         --package-version=$(VERSION) \
	         --msgid-bugs-address=$(AUTHOR_EMAIL) \
	         --output=$(DOMAIN).pot \
	         $(SHORT_NAME)/*.py

