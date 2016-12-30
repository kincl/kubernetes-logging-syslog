# Kubernetes Container Log Syslog Forwarder

This container is designed to run as a DaemonSet and forwards pod logs to a syslog
listener for all pods running on a node. Log forwarding is implemented with 
[RSYSLOG](http://www.rsyslog.com/) and uses [omfwd](http://www.rsyslog.com/doc/v8-stable/configuration/modules/omfwd.html) module.

## Configuration Options
Configuration can be done with environment variables:

* **RSYSLOG_TARGET** - Remote syslog listener
* **RSYSLOG_PORT** - Remote syslog listener port
* **RSYSLOG_PROTOCOL** - Remote syslog listener protocol (udp/tcp)

