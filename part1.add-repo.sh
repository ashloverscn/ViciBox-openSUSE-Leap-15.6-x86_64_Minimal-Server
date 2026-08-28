#!/bin/sh

cd /usr/src
## remove all repos and add our requirement repo set for vicibox
zypper rr --all

## set openSUSE-Leap release version of os  
releasever=$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')

## important update and distribution repos (matching active system)
zypper ar https://download.opensuse.org/update/leap/$releasever/sle/ openSUSE-SLE-15.6-Update
zypper ar https://download.opensuse.org/update/leap/$releasever/backports/ openSUSE-SLE-15.6-Backports
zypper ar https://download.opensuse.org/update/leap/$releasever/oss/ openSUSE-Leap-15.6-OSS
zypper ar https://download.opensuse.org/distribution/leap/$releasever/repo/oss/ openSUSE-Leap-15.6-OSS-Updates

## vicibox, telephony, and support repos
zypper ar https://download.opensuse.org/repositories/devel:/languages:/perl/15.6/ openSUSE-Leap-15.6-Devel-Lang-Perl
zypper ar https://download.opensuse.org/repositories/home:/vicidial/15.6/ openSUSE-Leap-15.6-ViciDial
zypper ar https://download.opensuse.org/repositories/home:/vicidial:/asterisk-18/15.6/ openSUSE-Leap-15.6-ViciDial-Ast18
zypper ar https://download.opensuse.org/repositories/home:/vicidial:/vicibox/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-ViciDial-ViciBox
zypper ar https://download.opensuse.org/repositories/network:/telephony/15.6/ openSUSE-Leap-15.6-network-telephony

## refresh and trust repo keys and update
zypper --gpg-auto-import-keys ref
#zypper up -y
#reboot
