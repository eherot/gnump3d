#!/usr/bin/perl -w # -*- cperl -*- # 
#
#  fr.pm - French language resources for GNUMP3d
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
#  $Id: fr.pm,v 1.1 2005/03/17 18:15:32 skx Exp $
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
GNUMP3d v\$VERSION (Perl v$]) - Un serveur de flux MP3/MP4/OGG/HTTP portable.
              - Voir http://www.gnump3d.org/ pour plus d'informations.

Usage: gnump3d [options]

 --background            Détacher de la console une fois lancé.
 --config filename       Lire les options depuis le fichier de configuration spécifié.
 --debug                 Afficher les messages d'erreur sur la console, pas dans les logs.
 --dump-plugins          Afficher tous les plugins trouvés.
 --fast                  Démarrer rapidement sans indexer les fichiers audio.
 --help                  Affiche ce message d'informations.
 --lang XX               Charge les chaînes depuis le fichier de langue spécifié.
 --plugin-dir directory  Charge les plugins depuis le dossier spécifié.
 --port number           Ecoute et sert sur le port spécifié.
 --quiet                 Ne pas afficher le message de démarrage.
 --root directory        Servir la musique depuis le répertoire spécifié.
 --test                  Permettre aux variables de configuration d'être environnementales.
 --theme-dir directory   Charger les thèmes depuis le répertoire spécifié.
 --version               Affiche la version de ce logiciel.

 Informez des bugs à : Steve Kemp <steve\@steve.org.uk>

E_O_HELP




$TEXT{ VERSION_TEXT } = <<E_O_VERSION;
gnump3d v\$VERSION [CVS Info: \$VERSION] on Perl v$]
E_O_VERSION




$TEXT{ STARTUP_BANNER } =<<E_O_BANNER;
GNUMP3d v\$VERSION par Steve Kemp
http://www.gnump3d.org/

GNUMP3d est un logiciel libre, couvert par la GNU General Public License,
et vous êtes autorisés à la changer et/ou à le distribuer selon certaines
conditions.

Pour plus de détails référez vous à l\'adresse COPYING donnée ci-dessous :

  Détails sur la copie :
    http://\$host/COPYING

  GNUMP3d en service sur :
    http://\$host/

  Site de GNUMP3d :
    http://www.gnump3d.org/
E_O_BANNER





$TEXT{ ERROR_BIND } =<<E_O_BIND;
  Impossible de créer l\'interface d\'écoute pour recevoir les requêtes

  Peut-être le port \$PORT est-il déjà utilisé ?

  Voici le message d\'erreur que le système a retourné :

     \$!

E_O_BIND





$TEXT{ ROOT_MISSING } =<<E_O_NO_ROOT;
  Le répertoire racine du serveur que vous avez spécifié, \$ROOT, n\'existe pas.

  Veuillez mettre à jour le fichier de configuration afin de spécifier le
 répertoire racine depuis lequel vous voulez diffuser.

  Vous pouvez régler ce problème en changeant la ligne qui ressemble à :

   root = \$ROOT

E_O_NO_ROOT




$TEXT{ THEME_DIR_MISSING } =<<E_O_NO_THEME_DIR;
  Le répertoire de thèmes que vous avez choisi, \$theme_dir, n\'existe pas.

  Veuillez mettre à jour le fichier de configuration afin de spécifier le
 répertoire que vous voulez utiliser.

  Vous pouvez régler ce problème en changeant la ligne qui ressemble à :

    theme_dir = \$theme_dir

E_O_NO_THEME_DIR




$TEXT{ PLUGIN_DIR_MISSING } =<<E_O_NO_PLUGIN_DIR;
  Le répertoire de plugins que vous avez choisi, \$plugin_dir, n\'existe pas.

  Veuillez mettre à jour le fichier de configuration afin de spécifier le
  répertoire que vous voulez utiliser.

  Vous pouvez régler ce problème en changeant la ligne qui ressemble à :

    plugin_directory = \$plugin_dir

E_O_NO_PLUGIN_DIR




$TEXT{ NO_PLUGINS } =<<E_O_NO_PLUGINS_FOUND;
   Aucun plugin n\'a été trouvé dans le dossier \$plugin_dir 

   Arrêt.

E_O_NO_PLUGINS_FOUND




$TEXT{ CONFIG_MISSING } =<<E_CONFIG_MISSING;
  Le fichier de configuration que j\'ai essayé de lire n\'existe pas
 \$CONFIG_FILE
 
  Pour régler ce problème vous pouvez spécifier l\'adresse du fichier
  de configuration avec l'option '--config'

  Par défauut les fichiers /etc/gnump3d/gnump3d.conf et ~/.gnump3drc seront
 lus sur un système Unix ou GNU/Linux.

E_CONFIG_MISSING




$TEXT{ DEFAULT_THEME_MISSING } =<<E_O_NO_DEFAULT_THEME;
  Le répertoire de thèmes '\$theme_dir' ne contient pas le thème 
'\$default_theme' que vous avez décidé d\'utiliser.

  Vous pouvez régler ce problème en changeant la ou les lignes qui
  ressemblent à :
  
    theme_directory = \$theme_directory
    theme           = \$default_theme

E_O_NO_DEFAULT_THEME




$TEXT{ MIME_MISSING } =<<E_O_NO_MIME;
  Le fichier à partir duquel je veux lire les types MIME n\'a pas l\'air
  d\'exister.

  Veuillez créer le fichier '\$mime_file' - ou mettre à jour votre fichier
  de configuration qui indique actuellement :

    mime_file = \$mime_file

E_O_NO_MIME




$TEXT{ RO_ACCESS_LOG } =<<E_O_NO_WRITE;
  Vous n\'avez pas le droit d\'écrire dans le fichier de journal '\$access_log'

  Vous pouvez régler ce problème en changeant les permissions, ou en changeant
  le chemin du fichier en modifiant la ligne qui ressemble à :

   logfile = \$access_log

E_O_NO_WRITE




$TEXT{ RO_NOW_SERVING } =<<E_O_NO_WRITE_SERVING;
  Je n\'ai pas le droit d\'écrire dans le répertoire dans lequel je
  vais noter un enregistrement des fichiers servis - \$NOW_PLAYING_PATH.

  Vous pouvez régler ce problème soit en changeant les permissions soit en
 ou choisir un autre répertoire en changeant la ligne :

    now_playing_path = \$NOW_PLAYING_PATH

E_O_NO_WRITE_SERVING





$TEXT{ RUNNING_INDEX } =<<E_RUNNING_INDEX;

 J'indexe votre collection musicale, cela peut prendre quelque temps.

 (Utilisez l'option '--fast' si vous voulez éviter cette étape au démarrage).

E_RUNNING_INDEX




$TEXT{ ERROR_FORK } = <<E_NO_FORK;
  Erreur fatale - fork() impossible.

  L\'erreur système est \$!

E_NO_FORK




$TEXT{ ACCESS_DENIED } =<<E_ACCESS_DENIED;
  L\'accès à \$connected_address a été interdit.

  Contactez l`'administrateur système si vous pensez que ce message est un
  erreur.

E_ACCESS_DENIED




$TEXT{ ERROR404 } =<<E_404_TEXT;

  Le fichier demandé <code>\$uri</code> n\'a pas été trouvé.

  Essayez de revenir à l\'<a href="/">index</a>.

E_404_TEXT




$TEXT{ EMPTY_PLAYLIST } =<<E_EMPTY_PLAYLIST;

  La liste de lecture séléctionnée est vide.

  Essayez en une autre, et rapportez cette erreur au gérant du serveur.

E_EMPTY_PLAYLIST




$TEXT{ INDEXING_COMPLETE } =<<E_INDEX_DONE;
  Fini d'indexer.

E_INDEX_DONE



$TEXT{ FAIL_TRUNCATE } =<<E_FAIL_TRUNCATE;
  Impossible de tronquer le fichier journal '\$access_log'.

  L\'erreur système est :

      \$!

E_FAIL_TRUNCATE


$TEXT{ FAIL_OPEN_LOGFILE } =<<E_FAIL_LOGFILE;
  Je n\'ai pas réussi à ouvrir le fichier journal, je me suis donc arrêté.

  Le fichier est '\$access_log', et l'erreur système :

      \$!

E_FAIL_LOGFILE




$TEXT{ FAILED_USER_SWITCH } =<<FAILED_USER_DETAILS;
  Impossible de trouver l\'ID et le GID pour l\'utilisateur \$username
 this means I can't switch user - so I'm not going to start!

  Ce problème peut être réglé en changeant la ligne 'user = \$username'
 dans le fichier gnump3d.conf

FAILED_USER_DETAILS





#
#  Module loaded correctly now.
#
1;
