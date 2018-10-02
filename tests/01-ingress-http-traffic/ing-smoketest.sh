#!/bin/bash

kubectl create namespace ingress-smoketest

sleep 3

kubectl -n ingress-smoketest apply -f ./ingress-smoketest.yaml

sleep 3

#set -e
curl -f -s -o /dev/null https://iingress-smoketest-app.apps.cloud-platform-test-1.k8s.integration.dsd.io 
echo $?

use $?

if [ $? -eq 0 ]; 
then
    echo "Ingress Test Successfull"
    kubectl delete namespace ingress-smoketest
    exit 0
else
    echo "Ingress Test Failed!"
    exit 1
fi;

