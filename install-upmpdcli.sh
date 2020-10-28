#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo
echo -n "Do you want to install UPnP upmpdcli (works only INSTEAD of gmrender-resurrect thus say no there...)? [y/N] "
read -r REPLY
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then exit 0; fi

# add signing keys
cp files/jf-at-dockes.org.pgp /etc/apt/trusted.gpg.d/.
cp files/deb.kaliko.me.gpg /etc/apt/trusted.gpg.d/.

# add packages sources
cp files/upmpdcli.list /etc/apt/sources.list.d/.

# update & install
apt update
apt install mpd/stable-backports
apt install upmpdcli

PRETTY_HOSTNAME=$(hostnamectl status --pretty)
PRETTY_HOSTNAME=${PRETTY_HOSTNAME:-$(hostname)}

# set UPnP-name to the hostname
sed -i "s/^#friendlyname = UpMpd/friendlyname = ${PRETTY_HOSTNAME}/g" upmpdcli.conf.dpkg-dist

systemctl enable --now mpd
systemctl enable --now upmpdcli
