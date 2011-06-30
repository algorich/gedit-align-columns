# Align columns - Gedit plugin

This is a Gedit plugin for align text blocks into columns separated by
pipe ( | ).

## Usage

Let's say you're using Cucumber (or some Cucumber like) to write the functional
tests of your project and you are using *Scenario Outline* with *Examples* on
your features.

Write the examples are boring if you manually align the example columns, because
you should put the spaces and when you edit or write new examples, the spaces
may change. Sometimes the columns become a mess like this:

    | name  | email|phone|
    | Hugo Maia Vieira | hugomaiavieira@gmail.com |(22) 2727-2727|
    | Gabriel L. Oliveira | ciberglo@gmail.com |(22) 2525-2525            |
    | Rodrigo Manhães | rmanhaes@gmail.com |      (22) 2626-2626|

Whit this plugin you just need to select the examples text block, press
**Ctrl+Shift+a** and the result should be:

    | name                | email                    | phone          |
    | Hugo Maia Vieira    | hugomaiavieira@gmail.com | (22) 2727-2727 |
    | Gabriel L. Oliveira | ciberglo@gmail.com       | (22) 2525-2525 |
    | Rodrigo Manhães     | rmanhaes@gmail.com       | (22) 2626-2626 |

**You should select the entirely block from the first to the last `|`.** If you
write or select lines with different number of columns, a warning dialog will
shows up.

## Install

Download the file *gedit-align-columns-version.tar.gz* and extract the package
into the *~/.gnome2/gedit/plugins* directory, or - for a system-wide deployment
- into */usr/lib/gedit-2/plugins* (the path may be different, depending on your
distribution).

Then activate and configure the plugin through Edit -> Preferences -> Plugins.

## Development

It proved helpful for development to check out the git-repository to your
favorite location and create symlinks in your personal plugins directory to
the necessary files and directories. There is a make target, that accomplishes
this:

    $ make install-dev

## License

Copyright (c) 2011 Hugo Henriques Maia Vieira

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

