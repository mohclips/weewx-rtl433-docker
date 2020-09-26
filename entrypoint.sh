#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail
set -x

# setup syslog to write to docker logs
echo "*.*  /proc/1/fd/1" > /etc/syslog.conf
/usr/sbin/syslogd -n -S &

/usr/share/weewx/weewxd --exit --config=/etc/weewx/weewx.conf 2>&1 > /proc/1/fd/1
