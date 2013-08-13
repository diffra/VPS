# ------------------------------------------------------------ #
# VPS Management : Setup
#  - hostname
#  - timezone
#  - aliases & prompt
#  - apt sources
# ------------------------------------------------------------ #

basics() {
  HOSTNAME=`cat /etc/hostname`
  if ! confirm "Confirm or input new hostname (If installing a mail server, use a FQDN e.g. server.example.com)" $HOSTNAME; then
    echo $REPLY > /etc/hostname
    #add to /etc/hosts
    echo "127.0.0.2    $REPLY" > /etc/hosts
    hostname -F /etc/hostname
  fi

#  TIMEZONE=`cat /etc/timezone`
  TIMEZONE=`tail -1 /etc/timezone`
  if ! confirm "Confirm or input new timezone" $TIMEZONE; then
    echo $REPLY > /etc/timezone
    dpkg-reconfigure -f noninteractive tzdata
  fi

  if ! grep -q "^# Tiger's Way" ~/.profile; then
    cat >> ~/.profile <<EOF

# Tiger's Way
alias ls='ls --color=auto'
PS1='\e[33m[\A]\u@\h:\w\\$\e[m '

EOF
  fi

  if ! grep -q "^# Tiger's Way" /etc/apt/sources.list; then

    case $PROVIDER in
      buyvm)
        cat > /etc/apt/sources.list <<EOF
# Tiger's Way
deb http://mirrors.buyvm.net/debian/ wheezy main contrib non-free
deb http://mirrors.buyvm.net/debian/ wheezy-updates main contrib non-free
deb http://security.debian.org/ wheezy/updates main
EOF
        ;;
      *)
        if confirm 'Confirm or input new country mirror' 'us'; then
          REPLY='us'
        fi
        cat > /etc/apt/sources.list <<EOF
# Tiger's Way
deb http://ftp.$REPLY.debian.org/debian/ wheezy main contrib non-free
deb http://ftp.$REPLY.debian.org/debian/ wheezy-updates main contrib non-free
deb http://security.debian.org/ wheezy/updates main
EOF
    esac
  fi

#ensure aptitude is installed

apt-get -y update
apt-get -y install aptitude

#ensure locales are set up
LCL=`grep LANG /etc/default/locale`
if [ -z $LCL ]
  LCL='en_US.UTF8'

apt_install 'locales'
locale-gen en_US.UTF8
localedef -i en_US -c -f UTF-8 en_US.UTF8
update-locale LANG=en_US.UTF8

  apt_update
}
