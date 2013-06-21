# ------------------------------------------------------------ #
# VPS Management : Menu
#
# 0.5 03/04/2012
#  - bench
#    - detect OpenVZ
#  - lxmp
#    - separate DotDeb source
#  - vpn/pptp
#
# 0.4 16/03/2012
#  - setup
#    - squeeze-proposed-updates to squeeze-updates
#    - BuyVM's mirrors
#  - bench
#    - now shows guarantee/burst memory
#    - new echo style
#  - proxy
#    - tinyproxy deprecated
#    - polipo = new proxy with tunneling capabilities
#
# ------------------------------------------------------------ #
#!/bin/bash

echo -e "\e[1mVPS Management v1.0 Alpha 1\e[m";

# Sanity checks

if [ -f /etc/debian_version ]; then
  VERSION=`cat /etc/debian_version`
  if [ ${VERSION:0:1} -lt 5 ]; then
    die "Debian $VERSION is not supported anymore"
  fi
else
  die "Unknown distribution. Only Debian is supported."
fi

[ $(id -g) != "0" ] && die "Must be run by a root allowed user"


# Load `Modules`

mainOptions=(
  "minimal (Light Debian server + SSH)"
  "basics (hostname, timezone, APT sources)"
  "lowendbox (LEA style: syslogd, xinetd, dropbear)"
)
tools=()

addModule(){
  tools=("${tools[@]}" "$1")
}

for file in vps/*.sh
do
  source $file
done

# Check if any option or parameter and corresponding function...
PROVIDER=
if [ ! -z "$1" ]; then
  while [ ! -z "$1" ]; do
    case $1 in
      --provider|-p)
        shift
        PROVIDER=${1,,}
        shift
        ;;
    esac
    if [ `declare -F $1` ]; then
      SHIFT=1
      $@
      shift $SHIFT
    else
      die "Unknown command: $1"
    fi
  done

  exit
fi

# if not, show available options
echo 'Usage: '`basename $0`' [-p Provider] option [option...]'
echo 'Main options:'
for option in "${mainOptions[@]}"
do
  echo " - $option "
done
echo 'Other options/tools:'
for tool in "${tools[@]}"
do
  echo " - $tool "
done
echo
