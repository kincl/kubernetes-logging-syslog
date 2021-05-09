# Kubernetes Container Log Syslog Forwarder

This container is designed to run as a DaemonSet and forwards pod logs to a syslog listener for all
pods running on a node. Log forwarding is implemented with
[RSYSLOG](http://www.rsyslog.com/) and
uses [omfwd](http://www.rsyslog.com/doc/v8-stable/configuration/modules/omfwd.html) module.

## Configuration Options

Configuration can be done with environment variables:

* **RSYSLOG_TARGET** - Remote syslog listener
* **RSYSLOG_PORT** - Remote syslog listener port
* **RSYSLOG_PROTOCOL** - Remote syslog listener protocol (udp/tcp)

## DaemonSet

A working example of a deployment daemonset can be found in the [k8s](./k8s) directory, along with
an example ConfigMap. You will need to adjust the configmap to suit your system.

## Hacking

The `Makefile` included here is set up to assist development *and* testing of the system,
using [`k3d`](https://k3d.io/). It will fully set up a test cluster, install all necessary
components, and run a simple test.

Use `make test` to perform all of these

**NOTE:** there is currently an occasional timing issue where the test will fail right after the
cluster is up. If this happens, wait 30 seconds and attempt `make test` again.

Use `make help` to display information about available targets

