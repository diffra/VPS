# ------------------------------------------------------------ #
# VPS Management : Email hosting
# ------------------------------------------------------------ #

iredmail() {
apt_install 'bzip2'
wget -O /tmp/iredmail.tar.bz2 https://bitbucket.org/zhb/iredmail/downloads/iRedMail-0.8.5.tar.bz2  
cd /tmp
tar xjvf iredmail.tar.bz2
bash iRedMail-0.8.5/iRedMail.sh
}

addModule "iredmail (Full mail solution)"

