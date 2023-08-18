#!/bin/sh

\cp -r /root/.bashrc /root/.bashrc.bak

tee -a /root/.bashrc <<EOF

# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

export PERL_LOCAL_LIB_ROOT="$PERL_LOCAL_LIB_ROOT:/root/perl5";
export PERL_MB_OPT="--install_base /root/perl5";
export PERL_MM_OPT="INSTALL_BASE=/root/perl5";
export PERL5LIB="/root/perl5/lib/perl5:$PERL5LIB";
export PATH="/root/perl5/bin:$PATH";

EOF

\cp -r /etc/motd /etc/motd.bak
\cp -r /usr/src/motd /etc/motd

cat /etc/ssh/sshd_config | grep "#PrintMotd yes"
cat /etc/ssh/sshd_config | grep "PrintMotd yes"

sed -i "s|#PrintMotd yes|PrintMotd yes|g" /etc/ssh/sshd_config
#sed -i "s|PrintMotd yes|#PrintMotd yes|g" /etc/ssh/sshd_config

rm -rf ~/.hushlogin
#touch ~/.hushlogin

#echo "ip route get 1 | sed -n 's/^.*src \([0-9.]*\) .*$/\1/p'" >> ~/.bashrc


