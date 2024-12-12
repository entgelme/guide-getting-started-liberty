#!/bin/bash 

export LIBERTYPORT=9080
export LIBERTYIMG=liberty-on-container

# Create default route to local image registry
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
# Create trusted-ca ConfigMap, mirrored from the cluster wide one
oc apply -f cm-trusted-ca.yml

# Create the deployment for the app, which calls the remote service
oc apply -f guide-getting-started-liberty-deployment.yml
oc expose deployment/$LIBERTYIMG --port LIBERTYPORT --target-port LIBERTYPORT
oc expose svc/$LIBERTYIMG
