#!/bin/bash

# File locations in case you want to modify things
FIREWALLCMD_BIN="/usr/bin/firewall-cmd"
SERVICE_BIN="/sbin/service"
ASTERISK_BIN="/usr/sbin/asterisk"
ACME_BIN="acme.sh"
ACME_DIR="/root/.acme.sh/"
LOG_FILE="/var/log/acme-renew.log"

# Some defaults
VERBOSE=false
LOG=true # By default log to file
DOFW=true # Handle Firewalld

# Check if we're trying to be verbose or get help
if [[ $# -ge 1 ]]; then
    for cliarg in "$@"; do
        case $cliarg in
            -nl|--nolog)
                LOG=false;;
            -v|--verbose)
                VERBOSE=true
                LOG=false;; # If we're outputting to the console then no need to log to file
            -h|--help)
                showhelp;;
            -nf|--nofirewall)
                DOFW=false;;
        esac
    done
fi

# Log output to the right place
function outputlog {
    if [[ $VERBOSE ]]; then
        echo $1
    elif [[ $LOG_FILE ]]; then
        echo $1 >> $LOG_FILE
    fi 
}

# Show help
function showhelp {
echo "
  ===== ViciBox Acme Renewal Wrapper =====
   Log file location: $LOG_FILE

   allowed run time options:
     [-v|--verbose] = Be verbose to console instead of log
     [-nf|--nofirewall] = Skip firewalld checks
     [-nl|--nolog] = Don't log output to log file
     [-h|--help] = This help screen

This script will renew the LetEncrypt free SSL certs using acme.sh. It will
also load the new certificate into Apache and Asterisk if they are running.

"
exit 1
}

# File Checks
if [[ ! -x $ACME_DIR/$ACME_BIN ]]; then
    outputlog "acme.sh not installed at $ACME_DIR! exiting."
    exit 1
fi

# Begin our normal run
outputlog " ===== ViciBox Acme SSL Renewal Wrapper ====="
outputlog " - Starting at `date`"

# Determine firewall state and act accordingly
if [[ -x $FIREWALLCMD_BIN ]]; then
    if [[ $DOFW && `$FIREWALLCMD_BIN --state` == 'running' ]]; then
        # firewall checks are enabled and firewall is running
        DOFW=true 
    else
        # Although firewall checks enable, firewall is not running
        DOFW=false
    fi
else
    outputlog "$FIREWALLCMD_BIN not found! skipping..."
    DOFW=false
fi

# Now do actual firewall checks if flagged
if  $DOFW; then
    outputlog " - Disabling Firewall"
    $SERVICE_BIN firewalld stop
fi

outputlog " - Running acme.sh..."
$ACME_DIR/$ACME_BIN --renew-all >$LOG_FILE 2>&1

if $DOFW; then
    outputlog " - Enabling Firewall"
    $SERVICE_BIN firewalld start
fi

if [[ -x $SERVICE_BIN ]]; then
    outputlog " - Restart apache if running"
    $SERVICE_BIN apache2 reload
fi

if [[ -x $ASTERISK_BIN ]]; then
    outputlog " - Restart asterisk if running"
    $ASTERISK_BIN -rx "core restart now"
fi
outputlog " - Finished at `date`"

