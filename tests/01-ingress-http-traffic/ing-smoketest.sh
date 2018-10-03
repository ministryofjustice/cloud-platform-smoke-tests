#!/bin/bash

kubectl create namespace ingress-smoketest

sleep 3

kubectl -n ingress-smoketest apply -f ./ingress-smoketest.yaml

sleep 3

output=$(curl -s -o /dev/null -w "%{http_code}" https://ingress-smoketest-app.apps.cloud-platform-test-1.k8s.integration.dsd.io)

echo $output

if [ "$output" -eq 200 ]; 
then
    echo "Ingress Test Successfull!"
    kubectl delete namespace ingress-smoketest
    exit 0
else
    echo "Ingress Test Failed!"
    exit 1
fi;

