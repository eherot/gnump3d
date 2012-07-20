#!/usr/bin/perl -w # -*- cperl -*- #
#
#  de.pm - German language resources for GNUMP3d
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
#  $Id: de.pm,v 1.4 2005/11/15 12:01:54 skx Exp $
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
GNUMP3d v\$RELEASE (Perl v$])  - Ein portabler MP3/OGG/HTTP-Streamingserver.
              - Siehe http://www.gnump3d.org/ für mehr Details.

Syntax: gnump3d [optionen]

 --background              Programm von Konsole abkoppeln und im Hintergrund laufen lassen.
 --config filename         Optionen aus angegebener Konfigurationsdatei einlesen.
 --debug                   Debugging-Nachrichten nicht ins Errorlog, sondern auf Standard-Out schreiben.
 --dump-plugins            Alle gefundenen Plugins auflisten.
 --fast                    Schnellstart ohne vorheriges Indizieren der Audiodateien.
 --help                    Diese Benutzerinformation.
 --lang XX                 Lade die Texte aus der angegebenen Sprachdatei.
 --plugin-verz Verzeichnis Lade die Plugins aus dem angegebenen Verzeichnis.
 --port Nummer             Dienst auf dieser Port-Nummer betreiben.
 --quiet                   Beim Starten das Banner nicht zeigen.
 --root Verzeichnis        Wurzelverzeichnis des Musikarchives.
 --test                    Erlaubt das einlesen von Umgebungsvariablen.
 --themen-verz Verzeichnis Lade die Themes aus dem angegebenen Verzeichnis.
 --version                 Gibt die Version dieser Software aus.

 Fehlermeldungen an : Steve Kemp <steve\@steve.org.uk>

E_O_HELP




$TEXT{ VERSION_TEXT } = <<E_O_VERSION;
gnump3d v\$RELEASE [CVS Info: \$VERSION] (Perl v$])
E_O_VERSION




$TEXT{ STARTUP_BANNER } =<<E_O_BANNER;
GNUMP3d v\$RELEASE von Steve Kemp
http://www.gnump3d.org/

GNUMP3d is Freie Software, die durch die GNU General Public License geschützt ist.
Es ist erlaubt, unter Beachtung und Weitergabe derselben Bedingungen diese Software zu ändern und/oder zu kopieren.

Für weitere Details siehe COPYING:

  Details zum Kopieren:
    http://\$host/COPYING

  GNUMP3d läuft gerade auf:
    http://\$host/

  GNUMP3d-Website:
    http://www.gnump3d.org/
E_O_BANNER





$TEXT{ ERROR_BIND } =<<E_O_BIND;
  Konnte den Socket, auf dem gehört werden sollte, nicht öffnen.

  Ist Port \$PORT evtl. bereits in Benutzung?

  Die Systemfehlermeldung war:

     \$!

E_O_BIND





$TEXT{ ROOT_MISSING } =<<E_O_NO_ROOT;
  Das angegebene Wurzelverzeichnis des Musik-Archives, \$ROOT,
 ist nicht vorhanden.

  Bitte aktualisieren Sie Ihre Konfigurationsdatei mit dem korrekten Wurzelverzeichnis,
 in dem sich das Musikarchiv befindet.

  Der Fehler kann behoben werden, wenn die Zeile korrigiert wird, die momentan
 folgenden Inhalt hat:

   root = \$ROOT

E_O_NO_ROOT




$TEXT{ THEME_DIR_MISSING } =<<E_O_NO_THEME_DIR;
  Das angegebene Themes-Verzeichnis \$theme_dir existiert nicht.

  Bitte geben Sie in der Konfigurationsdatei das korrekte Themes-Verzeichnis an.

  Der Fehler kann behoben werden, wenn die Zeile korrigiert wird, die momentan
 folgenden Inhalt hat:

    theme_dir = \$theme_dir

E_O_NO_THEME_DIR




$TEXT{ PLUGIN_DIR_MISSING } =<<E_O_NO_PLUGIN_DIR;
  Das gewählte Pluginverzeichnis \$plugin_dir existiert nicht.

  Bitte geben Sie in der Konfigurationsdatei das korrekte Pluginverzeichnis an.

  Der Fehler kann behoben werden, wenn die Zeile korrigiert wird, die momentan
 folgenden Inhalt hat:

    plugin_directory = \$plugin_dir

E_O_NO_PLUGIN_DIR




$TEXT{ NO_PLUGINS } =<<E_O_NO_PLUGINS_FOUND;
   Im Verzeichnis \$plugin_dir wurde kein Plugin gefunden.

   Abbruch.

E_O_NO_PLUGINS_FOUND




$TEXT{ CONFIG_MISSING } =<<E_CONFIG_MISSING;
  Die Konfigurationsdatei \$CONFIG_FILE existiert nicht.

  Mit  '--config' kann der Pfad zur Konfigurationsdatei angegeben werden.

  Voreingestellt sind /etc/gnump3d/gnump3d.conf und ~/.gnump3drc, wenn
 es sich um ein Unix- oder GNU/Linux-System handelt.

E_CONFIG_MISSING




$TEXT{ DEFAULT_THEME_MISSING } =<<E_O_NO_DEFAULT_THEME;
  Das Themes-Verzeichnis \$theme_dir enthält nicht das Default-Theme
 \$default_theme welches verwendet werden soll.

  Der Fehler kann behoben werden, wenn eine oder beide Zeilen korrigiert werden, die momentan
 folgenden Inhalt haben:

    theme_directory = \$theme_directory
    theme           = \$default_theme

E_O_NO_DEFAULT_THEME




$TEXT{ MIME_MISSING } =<<E_O_NO_MIME;
  Die Datei, welche die MIME-Typen enthält, existiert nicht.

  Bitte erzeugen Sie die Datei '\$mime_file' - oder korrigieren Sie in der Konfigurationsdatei die Zeile,
 die momentan folgenden Inhalt hat:

    mime_file = \$mime_file

E_O_NO_MIME




$TEXT{ RO_ACCESS_LOG } =<<E_O_NO_WRITE;
  Das angegebene Logfile '\$access_log' ist nicht schreibbar.

  Der Fehler kann behoben werden, wenn die Dateiberechtigungen angepasst werden oder
 die Zeile korrigiert wird, die momentan folgenden Inhalt hat:

   logfile = \$access_log

E_O_NO_WRITE




$TEXT{ RO_NOW_SERVING } =<<E_O_NO_WRITE_SERVING;
  Das Verzeichnis \$NOW_PLAYING_PATH für die Angabe des gerade gespielten Titels
 ist nicht schreibbar.

  Der Fehler kann behoben werden, wenn die Verzeichnis-Berechtigungen angepasst werden, oder
 wenn die Zeile korrigiert wird, die momentan folgenden Inhalt hat:

    now_playing_path = \$NOW_PLAYING_PATH

E_O_NO_WRITE_SERVING





$TEXT{ RUNNING_INDEX } =<<E_RUNNING_INDEX;
  Das indizieren des Musikarchives läuft... und kann etwas dauern.

  Starten Sie mit '--fast', wenn die Indexerstellung beim Start übersprungen werden soll.

E_RUNNING_INDEX




$TEXT{ ERROR_FORK } = <<E_NO_FORK;
  Fataler Fehler, kann Prozess nicht aufspalten \'fork()\'.

  Die Systemfehlermeldung war:

     \$!

E_NO_FORK




$TEXT{ ACCESS_DENIED } =<<E_ACCESS_DENIED;
  Der Zugriff auf \$connected_address wurde abgelehnt.

  Benachrichtigen Sie den Systemadministrator, wenn Sie an einen Fehler glauben.

E_ACCESS_DENIED




$TEXT{ ERROR404 } =<<E_404_TEXT;
  Die angeforderte Datei <code>\$uri</code> wurde nicht gefunden.

  Bitte versuchen Sie, direkt nach <a href="/">index</a> zurückzukehren.

E_404_TEXT




$TEXT{ EMPTY_PLAYLIST } =<<E_EMPTY_PLAYLIST;
  Die ausgewählte Playliste ist leer.

  Bitte treffen Sie eine andere Wahl und melden den Fehler dem Servereigentümer.

E_EMPTY_PLAYLIST




$TEXT{ INDEXING_COMPLETE } =<<E_INDEX_DONE;
  Indizierung fertig.

E_INDEX_DONE



$TEXT{ FAIL_TRUNCATE } =<<E_FAIL_TRUNCATE;
  Das Zugriffs-Logfile '\$access_log' konnte nicht gekürzt werden.

  Die Systemfehlermeldung war:

     \$!

E_FAIL_TRUNCATE


$TEXT{ FAIL_OPEN_LOGFILE } =<<E_FAIL_LOGFILE;
  Das Zugriffs-Logfile '\$access_log' konnte nicht geöffnet werden. Abbruch.

  Die Systemfehlermeldung war:

     \$!

E_FAIL_LOGFILE




$TEXT{ FAILED_USER_SWITCH } =<<FAILED_USER_DETAILS;
  ID und GID für User \$username konnten nicht gefunden
 und der User deshalb nicht gewechselt werden. Abbruch!

  Der Fehler kann behoben werden, wenn der Eintrag 'user = \$username' in der
 Konfigurationsdatei gnump3d.conf angepasst wird.

FAILED_USER_DETAILS





#
#  Module loaded correctly now.
#
1;
