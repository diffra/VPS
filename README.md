# VPS scripts

## Overview

This should provide a set of simple shell scripts which may help setting your
Debian Squeeze VPS.

## Quick usage

1. Download: wget -q https://github.com/downloads/diffra/VPS/archive/master.zip --no-check-certificate -O - | tar xz
2. Run: bash vps.sh

There are 3 main options:

* basics (hostname, timezone, APT sources)
* lowendbox (LEA style: syslogd, xinetd, dropbear)
* setup - Runs basics, then LEB.

and a set of different commands:

* apache - use Apache for HTTP Service
* nginx - use nginx for HTTP service
* mysql - setup minimized mysql instance
* phpfpm - setup minimized PHP service
* lamp ((Apache + MySQL(MyISAM) + PHP5-FPM) - auto-installs apache/mysql/php
* lemp (nginx + MySQL(MyISAM) + PHP5-FPM) - auto installs nginx/mysql/php RECOMENDED
* domain <[subdomain.]domain.tld> - configure new domain for web hosting in apache/nginx

As a developer, I personally first run
`bash vps.sh setup` which gives me a light (~ 5M) box, then
`bash vps.sh lemp` to get a full hosting environment, then
`bash vps.sh domain sub.domain.tld` to add domains to the server.  If you want to switch to apache, it's as easy as:
`bash vps.sh apache` -- And switching back to nginx, you just run that command.

## History

### Alpha 1 2013-06-21
* Forked from tigersway scripts
 * updated to debian 7
 * configured to allow local access for use on home servers
 * streamlined setup command
 * Removed unnecessary/insecure options polipo, pptp - to be replaced with SSH proxy.
* **TODO:  **
 * multi-domain Mailserver setup
 * Auto-update packages
 * Status emails
 * Status monitoring?
 * 

### 0.5 03/04/2012
* bench
 * detect OpenVZ
* lxmp
 * separate DotDeb source
* vpn/pptp

### 0.4 16/03/2012
* setup
 * squeeze-proposed-updates to squeeze-updates
 * BuyVM's mirrors
* bench
 * now shows guarantee/burst memory.
 * new echo style
* proxy
 * tinyproxy deprecated
 * polipo = new proxy with tunneling capabilities

## Copyright and License

Copyright (c) 2013 James Bertelson / Diffras

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
