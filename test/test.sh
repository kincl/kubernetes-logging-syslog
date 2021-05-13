#!/bin/bash

# purpose:  test the k8s cluster to see if a log message gets through

DATE=$(date +%y%m%d%H%M%S)
curl -s "http://localhost:8081/testing/${DATE}" > /dev/null

pod=$(kubectl get pods -l app=rsyslog | awk '!/NAME/{print $1}')
if kubectl exec "$pod" -- grep -q "testing/${DATE}" /var/log/messages
then
  echo "PASS"
else
  echo "FAIL"
  exit 1
fi
