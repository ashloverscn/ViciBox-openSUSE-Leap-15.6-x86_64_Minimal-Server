#!/bin/sh

cd /usr/src
## remove all repos and add our requirment repo set for vicibox
zypper rr --all
## set openSUSE-Leap release version of os  
releasever=$(grep -oP '(?<=^VERSION_ID=).+' /etc/os-release | tr -d '"')
## important update and dirtribution repo
zypper ar http://mirrorcache-us.opensuse.org/update/leap/$releasever/sle/ openSUSE-Leap-15.6-SLE-15-Update
zypper ar http://mirrorcache-us.opensuse.org/update/leap/$releasever/backports/ openSUSE-Leap-15.6-Backports-Update
zypper ar http://mirrorcache-us.opensuse.org/update/leap/$releasever/oss/ openSUSE-Leap-15.6-Oss-Update
zypper ar http://mirrorcache-us.opensuse.org/update/leap/$releasever/non-oss/ openSUSE-Leap-15.6-Non-Oss-Update
zypper ar http://mirrorcache-us.opensuse.org/distribution/leap/$releasever/repo/oss/ openSUSE-Leap-15.6-Oss
zypper ar http://mirrorcache-us.opensuse.org/distribution/leap/$releasever/repo/non-oss/ openSUSE-Leap-15.6-Non-Oss
## vicibox vicidial and support repo
#zypper ar http://mirrorcache-us.opensuse.org/repositories/devel:/languages:/perl/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-PERL
zypper ar http://mirrorcache-us.opensuse.org/repositories/devel:/languages:/perl/15.6/ openSUSE-Leap-15.6-PERL
zypper ar http://mirrorcache-us.opensuse.org/repositories/home:/vicidial/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-ViciDial
zypper ar http://mirrorcache-us.opensuse.org/repositories/home:/vicidial:/asterisk-18/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-ViciDial-Ast18
#zypper ar http://mirrorcache-us.opensuse.org/repositories/home:/vicidial:/asterisk-16/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-ViciDial-Ast16
zypper ar http://mirrorcache-us.opensuse.org/repositories/home:/vicidial:/vicibox/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-ViciDial-ViciBox
zypper ar http://mirrorcache-us.opensuse.org/repositories/devel:/languages:/php/openSUSE_Leap_15.6/ openSUSE-Leap-15.6-PHP-Applications
zypper ar http://mirrorcache-us.opensuse.org/repositories/home:/zippy:/jx:/packages-ready/openSUSE_Leap_15.6/ openSUSE_Leap_15.6-zippy-jx
## refresh and trust repo keys and update
zypper --gpg-auto-import-keys ref
#zypper up -y
#reboot


