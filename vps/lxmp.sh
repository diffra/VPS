# ------------------------------------------------------------ #
# VPS Management : Apache/nginx, MySQL, PHP
# ------------------------------------------------------------ #

dotdeb() {
  if [ ! -e /etc/apt/sources.list.d/dotdeb.list ]; then
    cat > /etc/apt/sources.list.d/dotdeb.list <<EOF
deb http://packages.dotdeb.org/ wheezy all
EOF
    wget -q -O - http://www.dotdeb.org/dotdeb.gpg | apt-key add -

    apt_update
  fi
}

server_stop() {
  # Stop & disable web server if needed
  if ps -C $1 > /dev/null; then
    service $1 stop
    update-rc.d -f $1 remove
  fi
}

apache() {
  server_stop nginx

  if ! apt_installed apache2; then

    apt_install 'apache2 libapache2-mod-fastcgi'
    a2dissite default
    a2enmod actions rewrite

    cp /etc/apache2/conf.d/{security,security.bak}
    sed -i '/^#ServerTokens/d;s/^ServerTokens .*/ServerTokens Prod/' /etc/apache2/conf.d/security

	service apache2 restart
    ok 'apache installed and setup.\n'

  else
	update-rc.d apache2 defaults
	service apache2 start
  fi
}


nginx() {
  server_stop apache2

  if ! apt_installed nginx; then

    apt_install nginx

    cp /etc/nginx/{nginx.conf,nginx.conf.bak}
    sed -i 's/\#\s*server_tokens off;/server_tokens off;/' /etc/nginx/nginx.conf
    PR=$( awk '/cpu MHz/ {cores++} END {print cores+1}' /proc/cpuinfo )
    sed -i "s/worker_processes [0-9]*/worker_processes $PR/" /etc/nginx/nginx.conf
    sed -i 's/worker_connections [0-9]*/worker_connections 1024/' /etc/nginx/nginx.conf

    service nginx start
    ok 'nginx installed and setup.\n'

  else
    update-rc.d nginx defaults
    service nginx start
  fi
}

phpfpm() {
  if ! apt_installed php5-fpm; then

    apt_install 'php5-fpm php5-mysql php5-sqlite php5-apc php5-gd php5-mcrypt'

    sed -i 's/^pm.max_children.*/pm.max_children = 8/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/^pm.start_servers.*/pm.start_servers = 2/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/^pm.min_spare_servers.*/pm.min_spare_servers = 2/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/^pm.max_spare_servers.*/pm.max_spare_servers = 4/' /etc/php5/fpm/pool.d/www.conf
    sed -i 's/\;pm.max_requests.*/pm.max_requests = 1000/' /etc/php5/fpm/pool.d/www.conf

    cat > /etc/php5/conf.d/php.ini <<EOF
[PHP]
short_open_tag = On
EOF

    service php5-fpm restart
    ok 'php5-fpm installed and setup.\n'

  else
    service php5-fpm restart
  fi
}

mysql() {
  if ! apt_installed mysql-server; then

    cat > /usr/sbin/policy-rc.d <<EOF
#!/bin/sh
exit 101
EOF
    chmod +x /usr/sbin/policy-rc.d

    apt_install 'mysql-server'

    rm /usr/sbin/policy-rc.d
    cat > /etc/mysql/conf.d/$HOSTNAME.cnf <<EOF
[mysqld]
skip-innodb
default-storage-engine=MyISAM

key_buffer = 8M
query_cache_size = 0
EOF

    service mysql start
    ok 'MySQL installed and setup.\n'

  else
    service mysql start
  fi
}

lamp() {
  dotdeb
  apache
  mysql
  phpfpm
}

lemp() {
  dotdeb
  nginx
  mysql
  phpfpm
}

addModule "lamp (Apache + MySQL(MyISAM) + PHP5-FPM)"
addModule "lemp (nginx + MySQL(MyISAM) + PHP5-FPM)"
