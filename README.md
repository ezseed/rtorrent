# Ezseed rtorrent shell bindings

## API:
  - `install.sh` - installs rtorrent and libtorrent
  - `useradd.sh username password` - creates a rtorrent user, system user should exists
  - `userdel.sh username` - deletes rtorrent user, don't delete user system
  - `daemon.sh start|stop|restart username` - daemonize user rtorrent
  - `passwd.sh username password` - updates the user password

For a more powerful usage see [ezseed](https://github.com/ezseed/ezseed)

## Nodejs

This module is there to be used without [ezseed](https://github.com/ezseed/ezseed) whole package. If you need to require this in a module:

```javascript
var i = require('ezseed-rtorrent')('install')

console.log(i)

//will output
// /path/to/the/node_modules/ezseed-rtorrent/install.sh
```
