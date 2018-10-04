#!/bin/bash

kubectl create namespace log-collection-test
kubectl run wordpress --image wordpress -n log-collection-test

while true ; do 
    echo "Working..."
    result=$(kubectl describe pods -n log-collection-test | grep 'Pending')
    echo "Result found is $result"
  if [[ -z $result ]] ; then 
    echo "Complete"
    break
  fi
done

sleep 60

export pod_name=`kubectl get pods -n log-collection-test | awk 'FNR == 2 {print $1}'`
export date=`date +%Y.%m.%d`
export curlresult=$(curl -s -XGET http://search-cloud-platform-test-o2m2taivvjpovbcl63mlytnpua.eu-west-1.es.amazonaws.com/logstash-$date/_search -H 'Content-Type: application/json' -d'
{
  "query": {
    "bool": {
      "must": [
        {
          "match": {
            "kubernetes.namespace_name": "log-collection-test"
          }
        },
        {
          "match": {
            "kubernetes.pod_name.keyword": "'"$pod_name"'" 
          }
        }
      ]
    }
  }
}' | jq .hits.total)

printenv curlresult

if [ $curlresult == 0 ] 
  then  
    echo "Test Failed"
    exit 1
  else
    echo "Test Passed"
    kubectl delete pod $pod_name -n log-collection-test
    kubectl delete namespace log-collection-test
    exit 0
fi