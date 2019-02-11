#!/bin/bash


kubectl create namespace log-collection-test
kubectl run nginx --image wordpress -n log-collection-test

while true ; do 
    echo "Working..."
    result="$(kubectl describe pods -n log-collection-test | grep 'Pending')"
  if [[ -z $result ]] ; then 
    echo "Complete"
    break
  fi
done

sleep 60

pod_name="$(kubectl get pods -n log-collection-test | awk 'FNR == 2 {print $1}')"
date="$(date +%Y.%m.%d)"
curlresult="$(curl -s -XGET https://search-cloud-platform-live-7qrzc26xexgxtkt5qz72gt6cxa.eu-west-1.es.amazonaws.com/logstash-"$date"/_search -H 'Content-Type: application/json' -d '
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
}' | jq .hits.total)"

echo "$curlresult"

kubectl delete pod "$pod_name" -n log-collection-test
kubectl delete namespace log-collection-test

if [[ "$curlresult" -gt 0 ]];then
  echo "Test Passed"
  exit 0
else
  echo "Test Failed"
  exit 1
fi


