#!/bin/bash 

set -e 

export IP_ADDRESS=$(oc get svc knative-ingressgateway -n istio-system -o 'jsonpath={.status.loadBalancer.ingress[0].ip}')

export HOST_URL=$(oc get  routes.serving.knative.dev greeter -o jsonpath='{.status.domain}')

while true
do
  curl -H "Host: ${HOST_URL}" http://${IP_ADDRESS}
  echo ""
  sleep .2
done;
