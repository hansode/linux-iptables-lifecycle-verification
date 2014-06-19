#!/bin/bash
#
# requires:
#  bash
#
set -e
set -o pipefail
set -x

# Do some changes ...

bash -x /etc/init.d/iptables restart 2>&1 | egrep ' modprobe | iptables'
service iptables status

bash -x /etc/init.d/iptables reload 2>&1 | egrep ' modprobe | iptables'
service iptables status
