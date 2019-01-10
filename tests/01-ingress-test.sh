#!/bin/bash

echo Start Ingress Smoke Test....

kubectl create namespace ingress-smoketest

sleep 3

kubectl -n ingress-smoketest apply -f ./tests/resources/ingress-smoketest.yaml

sleep 15

output=$(curl -s -o /dev/null -w "%{http_code}" https://ingress-smoketest-app.apps.cloud-platform-live-0.k8s.integration.dsd.io)

echo $output

if [ "$output" -eq 200 ]; 
then
    echo "Ingress Test Successful!"
    kubectl delete namespace ingress-smoketest
    echo End of Ingress Smoke Test
    exit 0
else
    echo "Ingress Test Failed!"
    eoutput=$(curl -s -o -v /dev/null https://ingress-smoketest-app.apps.cloud-platform-test-1.k8s.integration.dsd.io)
    echo $eoutput
    echo End of Ingress Smoke Test
    exit 1
fi;

