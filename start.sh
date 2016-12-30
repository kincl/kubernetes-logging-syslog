#!/bin/bash

envsubst < /etc/rsyslog.conf.template > /etc/rsyslog.conf

exec /sbin/rsyslogd -n
