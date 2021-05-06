#!/bin/sh

rm -f /etc/rsyslog.conf

envsubst < /etc/rsyslog.conf.template > /etc/rsyslog.conf

exec /usr/sbin/rsyslogd -n
