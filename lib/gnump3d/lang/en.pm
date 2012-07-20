#!/usr/bin/perl -w # -*- cperl -*- # 
#
#  en.pm - English language resources for GNUMP3d
#
#  GNU MP3D - A portable(ish) MP3 server.
#
# Homepage:
#   http://www.gnump3d.org/
#
# Author:
#  Steve Kemp <steve@steve.org.uk>
#
# Version:
#  $Id: en.pm,v 1.10 2004/03/24 10:51:34 skx Exp $
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
#
#  Steve Kemp
#  ---
#  http://www.steve.org.uk/
#
#


#
##
#
#
#  This file may be copied and used as a basis of localisation for
# any other language.  Mail me your updated file and I'll happily
# include it within the distribution.
#
#
##
#


#
#  Hash that contains all our text.
#
our %TEXT ;




$TEXT{ HELP_TEXT } = <<E_O_HELP;
GNUMP3d v\$RELEASE (Perl v$]) - A portable(ish) MP3/OGG/HTTP streaming server.
              - See http://www.gnump3d.org/ for more details.

Usage: gnump3d [options]

 --background            Detatch from the console after starting.
 --config filename       Read options from the named configuration file.
 --debug                 Dump debug output to the console, not the error log.
 --dump-plugins          Display all plugins that have been found.
 --fast                  Start quickly without indexing the audio files first.
 --help                  Display this usage information.
 --lang XX               Load the strings from the given language file.
 --plugin-dir directory  Load the plugins from the given directory.
 --port number           Listen and serve upon the given port number.
 --quiet                 Do not display the startup banner.
 --root directory        Serve music from the given directory.
 --test                  Allow config variables to come from the environment.
 --theme-dir directory   Load the theme files from the given directory.
 --version               Displays the version of this software.

 Report bugs to : Steve Kemp <steve\@steve.org.uk>

E_O_HELP




$TEXT{ VERSION_TEXT } = <<E_O_VERSION;
gnump3d v\$RELEASE [CVS Info: \$VERSION] on Perl v$]
E_O_VERSION




$TEXT{ STARTUP_BANNER } =<<E_O_BANNER;
GNUMP3d v\$RELEASE by Steve Kemp
http://www.gnump3d.org/

GNUMP3d is free software, covered by the GNU General Public License,
and you are welcome to change it and/or distribute copies of it under
certain conditions.

For full details please visit the COPYING URL given below:

  Copying details:
    http://\$host/COPYING

  GNUMP3d now serving upon:
    http://\$host/

  GNUMP3d website:
    http://www.gnump3d.org/
E_O_BANNER





$TEXT{ ERROR_BIND } =<<E_O_BIND;
  Couldn\'t create the listening socket for receiving incoming
 requests upon

  Perhaps the port \$PORT is already in use?

  This is the error message the system returned:

     \$!

E_O_BIND





$TEXT{ ROOT_MISSING } =<<E_O_NO_ROOT;
  The server root directory you specified, \$ROOT, is missing.

  Please update your configuration file to specify the actual
 root directory you wish to serve media from.  

  You can fix this error by changing the line that currently
 reads:

   root = \$ROOT

E_O_NO_ROOT




$TEXT{ THEME_DIR_MISSING } =<<E_O_NO_THEME_DIR;
  The theme directory you\'ve chosen, \$theme_dir, doesn\'t exist.

  Please update your configuration file to specify the actual theme
 directory you wish to use.

  You can do this by changing the line which currently reads:

    theme_dir = \$theme_dir

E_O_NO_THEME_DIR




$TEXT{ PLUGIN_DIR_MISSING } =<<E_O_NO_PLUGIN_DIR;
  The plugin directory you\'ve chosen, \$plugin_dir, doesn\'t exist.

  Please update your configuration file to specify the actual plugin
 directory you wish to use.

  You can fix this problem by changing the line which currently
 reads:

    plugin_directory = \$plugin_dir

E_O_NO_PLUGIN_DIR




$TEXT{ NO_PLUGINS } =<<E_O_NO_PLUGINS_FOUND;
   There were no plugins found in the plugin directory \$plugin_dir 

   Aborting.

E_O_NO_PLUGINS_FOUND




$TEXT{ CONFIG_MISSING } =<<E_CONFIG_MISSING;
  The configuration file which I've tried to read doesn't exist:
 \$CONFIG_FILE
 
  To fix this you may specify the path to a configuration file with
 the '--config' argument.

  By default the files /etc/gnump3d/gnump3d.conf and ~/.gnump3drc will
 be read under Unix and GNU/Linux systesm.

E_CONFIG_MISSING




$TEXT{ DEFAULT_THEME_MISSING } =<<E_O_NO_DEFAULT_THEME;
  The theme directory '\$theme_dir' doesn\'t contain the default theme 
'\$default_theme'  which you have elected to use.

  You can fix this problem by changing one or both of the lines which
 currently read:
  
    theme_directory = \$theme_directory
    theme           = \$default_theme

E_O_NO_DEFAULT_THEME




$TEXT{ MIME_MISSING } =<<E_O_NO_MIME;
  The file we wish to lookup our MIME types from doesn\'t appear to
 exist.

  Please create '\$mime_file' - or update your configuration file to
 point to the file you wish to use by updating the line which currently
 reads:

    mime_file = \$mime_file

E_O_NO_MIME




$TEXT{ RO_ACCESS_LOG } =<<E_O_NO_WRITE;
  The logfile you\'ve chosen to use '\$access_log' isn\'t writable by you

  You can fix this problem by modifying the permissions, or changing the
 path of the file to one you can modify by changing the line which reads:

   logfile = \$access_log

E_O_NO_WRITE




$TEXT{ RO_NOW_SERVING } =<<E_O_NO_WRITE_SERVING;
  The directory which we will write a record of files being served
 isn\'t writable by us - \$NOW_PLAYING_PATH.

  Please fix this by either changing the permissions on that directory
 or setting an alternate directory by changing the following line:

    now_playing_path = \$NOW_PLAYING_PATH

E_O_NO_WRITE_SERVING





$TEXT{ RUNNING_INDEX } =<<E_RUNNING_INDEX;

 Indexing your music collection, this may take some time.

 (Run with '--fast' if you do not wish this to occur at startup).

E_RUNNING_INDEX




$TEXT{ ERROR_FORK } = <<E_NO_FORK;
  Fatal error - cannot fork().

  The system error was \$!

E_NO_FORK




$TEXT{ ACCESS_DENIED } =<<E_ACCESS_DENIED;
  Access has been denied to \$connected_address.

  Please contact the system administrator if you believe this
 message is in error.

E_ACCESS_DENIED




$TEXT{ ERROR404 } =<<E_404_TEXT;

  The requested file <code>\$uri</code> couldn't be found.

  Please try returning to the <a href="/">index</a>.

E_404_TEXT




$TEXT{ EMPTY_PLAYLIST } =<<E_EMPTY_PLAYLIST;

  The selected playlist file is empty.

  Please try a different choice, and report this error to the 
 server owner.

E_EMPTY_PLAYLIST




$TEXT{ INDEXING_COMPLETE } =<<E_INDEX_DONE;
  Indexing complete.

E_INDEX_DONE



$TEXT{ FAIL_TRUNCATE } =<<E_FAIL_TRUNCATE;
  Unable to truncate the access log file '\$access_log'.

  The system error was:

      \$!

E_FAIL_TRUNCATE


$TEXT{ FAIL_OPEN_LOGFILE } =<<E_FAIL_LOGFILE;
  We failed to open the access log, so we're aborting.

  The file was '\$access_log', and the system error was:

      \$!

E_FAIL_LOGFILE




$TEXT{ FAILED_USER_SWITCH } =<<FAILED_USER_DETAILS;
  Error failed to find ID and GID for user \$username
 this means I can't switch user - so I'm not going to start!

  This error can be fixed by changing the 'user = \$username'
 line in gnump3d.conf.

FAILED_USER_DETAILS





#
#  Module loaded correctly now.
#
1;
