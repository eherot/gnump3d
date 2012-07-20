#!/usr/bin/perl -w # -*- cperl -*- # 
#
#  en.pm - Spanish language resources for GNUMP3d
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
#  $Id: es.pm,v 1.1 2005/11/15 12:02:53 skx Exp $
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
GNUMP3d v\$RELEASE (Perl v$]) - Servidor MP3/OGG/HTTP de streaming.
   - Visite http://www.gnump3d.org para obtener mas detalles.

Modo de uso: gnump3d [opciones]

 --background            Desligar de la consola tras el arranque. Enviar a segundo plano.
 --config filename       Leer opciones de configuracion desde el fichero especificado.
 --debug                 Volcar el log de error a la consola, no al fichero de log.
 --dump-plugins          Mostrar todos los plugins que han sido encontrados.
 --fast                  Iniciar rapido, sin indexar primero los ficheros audio. 
 --help                  Mostrar esta informacion de ayuda. 
 --lang XX               Cargar cadenas de texto desde el fichero de lenguaje especificado.
 --plugin-dir directory  Cargar plugins desde el directorio especificado.
 --port number           Escuchar y servir a traves del puerto especificado.
 --quiet                 No mostrar el banner de arranque.
 --root directory        Servir musica desde el directorio especificado.
 --test                  Permitir las variables de configuracion venir desde las del entorno.
 --theme-dir directory   Cargar los ficheros de tema desde el directorio especificado.
 --version               Mostrar la version de este software.

 Informar sobre los fallos a: Steve Kemp <steve\@steve.org.uk>

E_O_HELP




$TEXT{ VERSION_TEXT } = <<E_O_VERSION;
gnump3d v\$RELEASE [CVS Info: \$VERSION] sobre Perl v$]
E_O_VERSION




$TEXT{ STARTUP_BANNER } =<<E_O_BANNER;
GNUMP3d v\$RELEASE por Steve Kemp
http://www.gnump3d.org/

GNUMP3d es software libre, bajo la GNU General Public License,
y usted puede cambiar y/o distribuir copias de el respetando
ciertas condiciones.

Para obtener todos los detalles, por favor visite la URL COPYING mas abajo:

  Detalles de copia:
    http://\$host/COPYING

  GNUMP3d sirviendo bajo:
    http://\$host/

  Sitio web de GNUMP3d:
    http://www.gnump3d.org/
E_O_BANNER





$TEXT{ ERROR_BIND } =<<E_O_BIND;
  No se puede crear el socket de escucha para recibir peticiones 
 en

  \¿Esta ya quiza el puerto \$PORT en uso?
  
  Este es el mensaje de error que el sistema a devuelto:

     \$!

E_O_BIND





$TEXT{ ROOT_MISSING } =<<E_O_NO_ROOT;
  El directorio raiz del servidor que has espeficicado, \$ROOT,
 no se encuentra.
  
  Por favor actualiza tu fichero de configuracion para especi-
 ficar el directorio raiz desde el que quieres servir ficheros.

  Puedes corregir este error cambiando la linea que dice:

   root = \$ROOT

E_O_NO_ROOT




$TEXT{ THEME_DIR_MISSING } =<<E_O_NO_THEME_DIR;
  El directorio de temas que has elegido \$theme_dir no existe.
  
  Por favor actualiza tu fichero de configuracion para especi-
 ficar el directorio de temas que quieres utilizar.
  
  Puedes corregir este error cambiando la linea que dice:

    theme_dir = \$theme_dir

E_O_NO_THEME_DIR




$TEXT{ PLUGIN_DIR_MISSING } =<<E_O_NO_PLUGIN_DIR;
  El directorio de plugins \$plugin_dir que has elegido, no existe.

  Por favor actualiza tu fichero de configuracion para especificar
 el directorio de plugins que quieres utilizar.

  Puedes corregir este error cambiando la linea que dice:

    plugin_directory = \$plugin_dir

E_O_NO_PLUGIN_DIR




$TEXT{ NO_PLUGINS } =<<E_O_NO_PLUGINS_FOUND;
   No se han encontrado plugins en el directorio de plugins \$plugin_dir

   Abortando.

E_O_NO_PLUGINS_FOUND




$TEXT{ CONFIG_MISSING } =<<E_CONFIG_MISSING;
  El fichero de configuracion que he tratado de leer no existe:
 \$CONFIG_FILE
 
  Para corregir este error puedes especificar la ruta hasta dicho fichero
 con el argumento '--config'.

  Por defecto, los ficheros /etc/gnump3d/gnump3d.conf y ~/.gnump3drc se 
 leeran bajo sistemas Unix y GNU/Linux.

E_CONFIG_MISSING




$TEXT{ DEFAULT_THEME_MISSING } =<<E_O_NO_DEFAULT_THEME;
  El directorio de temas '\$theme_dir' no contiene el tema por defecto
'\$default_theme'  que has seleccionado.

  Puedes corregir este error cambiando una o ambas lineas que dicen:
  
    theme_directory = \$theme_directory
    theme           = \$default_theme

E_O_NO_DEFAULT_THEME




$TEXT{ MIME_MISSING } =<<E_O_NO_MIME;
  El fichero desde el que se obtienen los tipos MIME, parece no existir.

  Por favor, crea '\$mime_file' - o actualiza tu fichero de configuracion 
 para que apunte al fichero que deseas utilizar, actualizando la linea
 que dice:

    mime_file = \$mime_file

E_O_NO_MIME




$TEXT{ RO_ACCESS_LOG } =<<E_O_NO_WRITE;
  El fichero de log que has elegido para utilizar, '\$access_log' no posee
 permisos de escritura para ti.

  Puedes corregir este error modificando los permisos, o cambiando la
 ruta del fichero de log hasta uno que tu puedas modificar, en la linea
 que dice:

   logfile = \$access_log

E_O_NO_WRITE




$TEXT{ RO_NOW_SERVING } =<<E_O_NO_WRITE_SERVING;
  El directorio en el que guardaremos un registro de los ficheros
 que estan siendo servidos no es escribible por nosotros - \$NOW_PLAYING_PATH.

  Por favor, corrige este error cambiando los permisos en dicho direc-
 torio o especificando un directorio alternativo, cambiando la linea
 que dice:

    now_playing_path = \$NOW_PLAYING_PATH

E_O_NO_WRITE_SERVING





$TEXT{ RUNNING_INDEX } =<<E_RUNNING_INDEX;
 
 Indexando tu recopilacion musical, esto puede tardar un poco.

 (Ejecuta con '--fast' si no quieres que esta accion se tome en el arranque.)
 
E_RUNNING_INDEX




$TEXT{ ERROR_FORK } = <<E_NO_FORK;
  Error fatal - cannot fork().

  El error del sistema ha sido \$!

E_NO_FORK




$TEXT{ ACCESS_DENIED } =<<E_ACCESS_DENIED;
  El acceso ha sido denegado a \$connected_address.

  Por favor contacta con el administrador del sistema si
 crees que este mensaje es incorrecto.

E_ACCESS_DENIED




$TEXT{ ERROR404 } =<<E_404_TEXT;

  El fichero solicitado <code>\$uri</code> no puede ser encontrado.
  Por favor, intenta volver al <a href="/">index</a>.

E_404_TEXT




$TEXT{ EMPTY_PLAYLIST } =<<E_EMPTY_PLAYLIST;

  El fichero de lista de reproduccion esta vacio.

  Por favor, intenta otra eleccion distinta, e informa de este
 error al administrador del servidor.

E_EMPTY_PLAYLIST




$TEXT{ INDEXING_COMPLETE } =<<E_INDEX_DONE;
  Indexado completado.

E_INDEX_DONE



$TEXT{ FAIL_TRUNCATE } =<<E_FAIL_TRUNCATE;
  Imposible truncar el fichero de log de accso '\$access_log'.

  El error del sistema ha sido:

      \$!

E_FAIL_TRUNCATE


$TEXT{ FAIL_OPEN_LOGFILE } =<<E_FAIL_LOGFILE;
  Fallo al intentar abrir el fichero de log, asi que abortamos.

  El fichero era '\$access_log', y el error del sistema:

      \$!

E_FAIL_LOGFILE




$TEXT{ FAILED_USER_SWITCH } =<<FAILED_USER_DETAILS;
  Fallo al buscar el ID y GID para el usuario \$username .
 Esto significa que no puedo cambiar de usuario, asi que no
 voy a arrancar.

  Este error puede ser corregido cambiando 'user = \$username'
 en el fichero de configuracion.

FAILED_USER_DETAILS





#
#  Module loaded correctly now.
#
1;
