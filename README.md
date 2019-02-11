# cloud-platform-smoke-tests
Smokes tests for the new cloud-platform


1) Namespace Smoke Test: 
   
   a) Verify WebOps has access to kube-system namespace and pods
   b) Verify Developer Team does not have access to kube-system namespace and pods
   c) Verify Developer Team has access to their namespace and pods

2) Ingress-test:
   
   a) Verify iingress apply Host URL can be accessible.

3) log-collection-test:
   
   a) Verify Kubernetes logs can be accessible from elasticsearch.