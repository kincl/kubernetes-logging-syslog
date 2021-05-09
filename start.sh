#!/bin/sh

rm -f /etc/rsyslog.conf

envsubst < /etc/rsyslog.conf.template > /var/lib/rsyslog/rsyslog.conf

exec /usr/sbin/rsyslogd -n
