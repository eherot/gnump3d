#!/usr/bin/perl -w # -*- cperl -*- # 
#
#  ba.pm - Basque language resources for GNUMP3d
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
#  $Id: ba.pm,v 1.2 2005/12/03 17:59:51 skx Exp $
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
GNUMP3d v\$RELEASE (Perl v$]) - MP3/OGG/HTTP streaming serbidorea
   - Ikusi http://www.gnump3d.org informazio zehatzagoa eskuratzeko.

Nola erabili: gnump3d [aukerak]

 --background            Atzeko planora bidali.
 --config filename       Aukera guztiak, fitxero honetatik jaso.
 --debug                 Erroreak kontsolan azaldu, ez log fitxeroan.
 --dump-plugins          Azaldu aurkitu diren plugin guztiak.
 --fast                  Hasi azkar, audio fitxeroen zerrenda egin barik. 
 --help                  Laguntza informazioa bistaratu.
 --lang XX               Testu kateak, zehaztutako hizkuntza fitxerotik jaso.
 --plugin-dir directory  Pluginak, zehaztutako direktoriotik jaso.
 --port number           Entzun eta serbitzua emon, zehaztutako portuaren bidez.
 --quiet                 Hasierako bannerra ez erakutsi.
 --root directory        Musika serbitzatu zehaztutako direktoriotik.
 --test                  Ingurugiroko bariableen baloreak, kofiguraziokoak izan daitezen utzi.
 --theme-dir directory   Gaien fitxeroak zehaztutako direktoriotik jaso.
 --version               Software honen bertsioa azaldu.

 Akatzak helbide honetara bidali: Steve Kemp <steve\@steve.org.uk>

E_O_HELP




$TEXT{ VERSION_TEXT } = <<E_O_VERSION;
gnump3d v\$RELEASE [CVS Info: \$VERSION] sobre Perl v$]
E_O_VERSION




$TEXT{ STARTUP_BANNER } =<<E_O_BANNER;
GNUMP3d v\$RELEASE Steve Kemp_ek egina
http://www.gnump3d.org/

GNUMP3d software librea da, GNU General Public Licensepean,
eta zu honen kopiak aldatu edo/eta banatu ditzkezu, balditza
batzuk errepetatuz.

Honen zehaztazun guztietaz irajurtzeko, mesedez behean dagoen URL COPYING bisitatu:

  Kopiaren zehaztaunak:
    http://\$host/COPYING

  GNUMP3d serbitzatzen:
    http://\$host/

  GNUMP3d_en webgunea:
    http://www.gnump3d.org/
E_O_BANNER





$TEXT{ ERROR_BIND } =<<E_O_BIND;
  Ezin da entzute socketa sortu, eskakizunak jasotzeko

  Baliteke \$PORT portua jada erabilita izatea?
  
  Sistema errore mezu hau bueltatu du:

     \$!

E_O_BIND





$TEXT{ ROOT_MISSING } =<<E_O_NO_ROOT;
  Serbidorearen zehaztu duzun fitxero direktorioa, \$ROOT,
 ezin da topatu.
  
  Mesedez berriztu zure konfigurazio fitxeroa, bertan nondik 
 serbitzatu nahi duzun fitxeroan azaltzeko.

  Errorea zuzendu dezakezu, lerro honen bidez:

   root = \$ROOT

E_O_NO_ROOT




$TEXT{ THEME_DIR_MISSING } =<<E_O_NO_THEME_DIR;
  Serbidorearen zehaztu duzun gaien direktorioa, \$ROOT,
 ezin da topatu.
  
  Mesedez berriztu zure konfigurazio fitxeroa, bertan nondik 
 hartu behar diren gaiak azaltzeko.
  
  Errorea zuzendu dezakezu, lerro honen bidez:

    theme_dir = \$theme_dir

E_O_NO_THEME_DIR




$TEXT{ PLUGIN_DIR_MISSING } =<<E_O_NO_PLUGIN_DIR;
  Serbidorearen zehaztu duzun pluginen direktorioa, \$ROOT,
 ezin da topatu.

  Mesedez berriztu zure konfigurazio fitxeroa, bertan pluginak non 
 dauden azaltzeko.

  Errorea zuzendu dezakezu, lerro honen bidez:

    plugin_directory = \$plugin_dir

E_O_NO_PLUGIN_DIR




$TEXT{ NO_PLUGINS } =<<E_O_NO_PLUGINS_FOUND;
   Zehaztutako direktorioan ez daude pluginak.

   Amaitzen.

E_O_NO_PLUGINS_FOUND




$TEXT{ CONFIG_MISSING } =<<E_CONFIG_MISSING;
  Saiatu nahiz konfigurazio fitxeroa irakurtzen baina ezin izan dut:
 \$CONFIG_FILE
 
  Errore hau zuzentzeko, fitxerorainoko bidea argumentu honen bidez azaldu
 dezakezu: '--config'.

  Aipatu ezean, /etc/gnump3d/gnump3d.conf eta ~/.gnump3drc fitxeroak,
 Unix eta GNU/Linux sistemetan irakurriak izango dira.

E_CONFIG_MISSING




$TEXT{ DEFAULT_THEME_MISSING } =<<E_O_NO_DEFAULT_THEME;
  Temak gordeta dauden direktorioan, '\$theme_dir' ez dauka aukeratu
duzun '\$default_theme'  tema.

  Akats hau zuzentzeko aukera hauetako bat edo biak batera aldatu ditzakezu:
  
    theme_directory = \$theme_directory
    theme           = \$default_theme

E_O_NO_DEFAULT_THEME




$TEXT{ MIME_MISSING } =<<E_O_NO_MIME;
  MIME tipoak lortzeko fitxeroa ez dagao, antza.

  Mesedez, '\$mime_file' - sortu edo konfigurazio fitxeroa berriztatu, erabili
nahi duzun fitxeroa agertu dadin, lerro hau aldatuz:

    mime_file = \$mime_file

E_O_NO_MIME




$TEXT{ RO_ACCESS_LOG } =<<E_O_NO_WRITE;
  Aukeratu duzun log fitxategian, '\$access_log' ezin duzu idatzi. Ez
dituzu baimen nahikorik.

  Akats hau zuzentzeko baimenak aldatu ditzakezu, edo log fitxategiaren helbidea
aldatu dezakezu, honako lerro honetan:

   logfile = \$access_log

E_O_NO_WRITE




$TEXT{ RO_NOW_SERVING } =<<E_O_NO_WRITE_SERVING;
  Serbitzatuak izaten ari diren fitxategiak, gordeta dauden direktorian, ezin 
dugu idatzi - \$NOW_PLAYING_PATH.

  Mesedez, akats hau zuzentzeko baimenak aldatu direktorio horretan, edo
beste direktorio bat azaldu, lerro hau aldatuz:

    now_playing_path = \$NOW_PLAYING_PATH

E_O_NO_WRITE_SERVING





$TEXT{ RUNNING_INDEX } =<<E_RUNNING_INDEX;
 
 Zure musika multzoa batzen ari naiz. Hauxe denbora luzea izan daiteke...

 ('--fast' erabili, hasieran egitea nahi ez baduzu.)
 
E_RUNNING_INDEX




$TEXT{ ERROR_FORK } = <<E_NO_FORK;
  Itzeleko akatsa - cannot fork().

  Sistemaren akatsa hauxe izan da: \$!

E_NO_FORK




$TEXT{ ACCESS_DENIED } =<<E_ACCESS_DENIED;
  Sarrera debekatua izan da: \$connected_address.

  Mezu hau okerrra dela uste baduzu, administradorearekin konkatuan jarri.

E_ACCESS_DENIED




$TEXT{ ERROR404 } =<<E_404_TEXT;

  <code>\$uri</code> fitxeroa ezin da topatu.
  Mesedez, saiatu <a href="/">index_era</a> itzultzen.

E_404_TEXT




$TEXT{ EMPTY_PLAYLIST } =<<E_EMPTY_PLAYLIST;

  Entzute zerrenda fitxeroa utzik dago.

  Mesedez saiatu beste aukera batekin, eta abisatu serbitzari honetako
 administradoreari.

E_EMPTY_PLAYLIST




$TEXT{ INDEXING_COMPLETE } =<<E_INDEX_DONE;
  Zerrenda osotze prozesua egina.

E_INDEX_DONE



$TEXT{ FAIL_TRUNCATE } =<<E_FAIL_TRUNCATE;
  Log fitxeroa mozte prozesua huts egindu: '\$access_log'.

  Sistemaren errorea hauxe izan da:

      \$!

E_FAIL_TRUNCATE


$TEXT{ FAIL_OPEN_LOGFILE } =<<E_FAIL_LOGFILE;
  Log fitxeroa irekitxerakoan huts egin du, beraz kitto.

  Fitxeroa hauxe zen: '\$access_log', sistemaren errorea:

      \$!

E_FAIL_LOGFILE




$TEXT{ FAILED_USER_SWITCH } =<<FAILED_USER_DETAILS;
  Akatsa ID eta GID topatzerakoan, \$username erabiltzailearena.
 Hauxe erabiltzailetaz ezin dudala aldatu esan nahi du, beraz ez naiz
 martxan jarriko.

  Akats hau zuzentzeko, konfigurazio fitxeroan 'user = \$username'
 aldatu.

FAILED_USER_DETAILS


#
#  Module loaded correctly now.
#
1;


