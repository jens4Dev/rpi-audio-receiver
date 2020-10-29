#!/bin/bash -e

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

echo
echo -n "Do you want to install UPnP upmpdcli (works only INSTEAD of gmrender-resurrect thus say no there...)? [y/N] "
read -r REPLY
if [[ ! "$REPLY" =~ ^(yes|y|Y)$ ]]; then exit 0; fi

# add signing keys
cp files/jf-at-dockes.org.gpg /etc/apt/trusted.gpg.d/.
chown _apt.root /etc/apt/trusted.gpg.d/jf-at-dockes.org.gpg
cp files/deb.kaliko.me.gpg /etc/apt/trusted.gpg.d/.
chown _apt.root /etc/apt/trusted.gpg.d/deb.kaliko.me.gpg

# add packages sources
if [ ! -e /etc/apt/sources.list.d/upmpdcli.list ]; then 
    cp files/upmpdcli.list /etc/apt/sources.list.d/.
    apt update
fi

# update & install
apt install -y mpd/stable-backports
apt install -y upmpdcli

PRETTY_HOSTNAME=$(hostnamectl status --pretty)
PRETTY_HOSTNAME=${PRETTY_HOSTNAME:-$(hostname)}

# set UPnP-name to the hostname
sed -i "s/^#friendlyname = UpMpd/friendlyname = ${PRETTY_HOSTNAME}/g" /etc/upmpdcli.conf

systemctl enable --now mpd
systemctl enable --now upmpdcli
systemctl restart mpd
systemctl restart upmpdcli
