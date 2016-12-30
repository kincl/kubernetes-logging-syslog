#!/bin/bash

rm -f /etc/rsyslog.conf

envsubst < /etc/rsyslog.conf.template > /etc/rsyslog.conf

exec /sbin/rsyslogd -n
