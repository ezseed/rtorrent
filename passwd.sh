#!/bin/bash

USER=$1
PW=$2
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
CONFIG_DIR="/usr/local/opt/ezseed"

## root check
if [ "$(id -u)" != "0" ]; then
  echo "This bash script needs a root account" 1>&2
  exit 1
fi

sed -i "/`echo $USER`:/d" $CONFIG_DIR/rutorrent_passwd

python $DIR/htpasswd.py -b /usr/local/nginx/rutorrent_passwd $USER $PW

exit 0
