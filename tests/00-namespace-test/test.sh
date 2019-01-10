#!/bin/bash

echo "Starting Namespace Smoke Test"

sleep 3

echo "Testing WebOps group access to kube system"

sleep 3

if kubectl auth can-i get namespace --namespace kube-system --as test --as-group github:webops --as-group system:authenticated | grep -q "yes"  && 
   kubectl auth can-i get pods --namespace kube-system --as test --as-group github:webops --as-group system:authenticated | grep -q "yes"; then
   sleep 3
   echo "Passed >>> WebOps has access to kube-system namespace and pods"
else
   sleep 3
   echo "Failed >>> WebOps has no access to kube-system namespace and pods"
fi

sleep 3

echo "Testing Developer team access to Kube system namespace and pods"

if kubectl auth can-i get namespace --namespace kube-system --as test --as-group github:crime-billing-online --as-group system:authenticated | grep -q "no" &&
   kubectl auth can-i get pods --namespace kube-system --as test --as-group github:crime-billing-online --as-group system:authenticated | grep -q "no"; then
   sleep 3
   echo "Passed >>> Developer Team does not have access to kube-system namespace and pods"
else
   sleep 3
   echo "Failed >>> Developer Team has access to kube-system namespace and pods"
fi

sleep 3

echo "Testing Developer team access to their namespace and pods"

if kubectl auth can-i get namespace --namespace laa-apply-for-legalaid-staging --as test --as-group github:laa-apply-for-legal-aid --as-group system:authenticated | grep -q "yes" &&
   kubectl auth can-i get pods --namespace laa-apply-for-legalaid-staging --as test --as-group github:laa-apply-for-legal-aid --as-group system:authenticated | grep -q "yes"; then
   sleep 3
   echo "Passed >>> Developer Team has access to their namespace and pods"
else
   sleep 3
   echo "Failed >>> Developer Team has no access to their namespace and pods"
fi

sleep 3

echo "Namespace test over"

