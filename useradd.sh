#!/bin/bash
############
#Ajout auto#
#Gaaa - LND#
#Mods by soyuka for ezssed2#
############
###############################################################################
######################    DECLARATION DES VARIABLES    ########################
###############################################################################
USER=$1
PW=$2
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
USER_HOME=$(su - $USER -c 'cd ~/ && echo $HOME')

###############################################################################
###############################    SCRIPT    ##################################
###############################################################################
# Vérification du root
if [ "$(id -u)" != "0" ]; then
        echo "This bash script needs a root account" 1>&2
        exit 1
fi

if [ ! -d "/usr/local/nginx"  ]; then
  mkdir -p /usr/local/nginx
fi

if [ ! -f "/usr/local/nginx/rutorrent_passwd" ]; then
  touch /usr/local/nginx/rutorrent_passwd
fi

# Création de l'utilisateur
python $DIR/htpasswd.py -b /usr/local/nginx/rutorrent_passwd $USER $PW

# Création des répertoires
# keep chroot rights by creating as root and chown'd them later
mkdir -p $USER_HOME/downloads $USER_HOME/uploads $USER_HOME/incomplete $USER_HOME/rtorrent $USER_HOME/rtorrent/session

# On met la conf rtorrent
if [ ! -f "$USER_HOME/.rtorrent.rc" ]; then
  touch $USER_HOME/.rtorrent.rc
fi

cat > $USER_HOME/.rtorrent.rc<< EOF
execute = {sh,-c,rm -f $USER_HOME/rtorrent/session/rpc.socket}
scgi_local = $USER_HOME/rtorrent/session/rpc.socket
execute = {sh,-c,chmod 0666 $USER_HOME/rtorrent/session/rpc.socket}
encoding_list = UTF-8
system.umask.set = 022
port_range = 45000-65000
port_random = yes
check_hash = no
directory = $USER_HOME/incomplete
session = $USER_HOME/rtorrent/session
encryption = allow_incoming, try_outgoing, enable_retry
trackers.enable = 1
use_udp_trackers = yes
EOF

# On fait la conf rutorrent
mkdir -p /var/www/rutorrent/conf/users/$USER
cat > /var/www/rutorrent/conf/users/$USER/config.php<< EOF
<?php
\$scgi_port = 0;
\$scgi_host = "unix://$USER_HOME/rtorrent/session/rpc.socket";
\$XMLRPCMountPoint = "/RPC00001";
\$pathToExternals = array(
    "php"   => '',
    "curl"  => '/usr/bin/curl',
    "gzip"  => '',
    "id"    => '',
    "stat"  => '/usr/bin/stat',
);
\$topDirectory = "$USER_HOME";
?>
EOF

chown -R $USER:$USER $USER_HOME/*

$DIR/daemon.sh start $USER

exit 0
