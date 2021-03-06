#!/bin/bash
############
#Gaaa - LND#
############
#DEL SCIRPT#
############
###############################################################################
######################    DECLARATION DES VARIABLES    ########################
###############################################################################
USER=$1
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="/usr/local/opt/ezseed"

###############################################################################
###############################    SCRIPT    ##################################
###############################################################################
#Vérification du root
if [ "$(id -u)" != "0" ]; then
        echo "This bash script needs a root account" 1>&2
        exit 1
fi

if [ -z "$1" ]; then
exit 1
fi

# Arret de rtorrrent
$DIR/daemon.sh stop $USER

# On tue tout ce que possede l'user
killall -9 -u $USER

#On supprime tout de l'user
rm -rf /var/www/rutorrent/conf/users/$USER
rm -rf /var/www/rutorrent/share/users/$USER
rm -rf /var/run/screen/S-$USER

#On supprime l'accès à rutorrent
sed -i "/`echo $USER`:/d" $CONFIG_DIR/rutorrent_passwd

exit 0
