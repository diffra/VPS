# ------------------------------------------------------------ #
# VPS Management : Email hosting
# ------------------------------------------------------------ #

iredmail() {
apt_install 'bzip2'
wget -O /tmp/iredmail.tar.bz2 https://bitbucket.org/zhb/iredmail/downloads/iRedMail-0.8.5.tar.bz2  
cd /tmp
tar xjvf iredmail.tar.bz2
#have to cd into directory for iredmail installer to work.
cd iRedMail-0.8.5
bash iRedMail.sh
#iredmail install script doesn't restart apache to load :443
service apache2 restart
}

addModule "iredmail (Full mail solution)"

