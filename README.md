# Ezseed rtorrent shell bindings

## Requirements

Web server, `nginx` prefered. PHP5 is installed through [apt-get among with other dependencies](https://github.com/ezseed/rtorrent/blob/master/install.sh#L36)

Todo: Add a skip option to this

### Debian squeeze

To make php5-fpm work on debian squeeze you'll need some [dotdeb sources](http://soyuka.me/install-php5-php5-fpm-and-nginx-on-debian-5-squeeze/)

## API:
  - `install.sh` - installs rtorrent and libtorrent
  - `useradd.sh username password` - creates a rtorrent user, system user should exists
  - `userdel.sh username` - deletes rtorrent user, don't delete user system
  - `daemon.sh start|stop|restart username` - daemonize user rtorrent
  - `passwd.sh username password` - updates the user password

For a more powerful usage see [ezseed](https://github.com/ezseed/ezseed)

##Vhost

### Nginx example

```
server {
	listen 80;
	server_name localhost;

  location /rutorrent {
		
		/var/www;
    index index.php index.html index.htm;
    server_tokens off;
    auth_basic "Merci de vous identifier";
    auth_basic_user_file "/usr/local/opt/ezseed/rutorrent_passwd";
  }

  location ~ \.php$ {
    root "/var/www";
    fastcgi_pass unix:/etc/phpcgi/php-cgi-ezseed.socket;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    include fastcgi_params;
  }

```

[More examples (https, apache)](https://github.com/ezseed/ezseed/tree/master/scripts/vhost)

## Nodejs

This module is there to be used without [ezseed](https://github.com/ezseed/ezseed) whole package. If you need to require this in a module:

```javascript
var i = require('ezseed-rtorrent')('install')

console.log(i)

//will output
// /path/to/the/node_modules/ezseed-rtorrent/install.sh
```
