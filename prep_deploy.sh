#!/bin/bash 

export LIBERTYPORT=9080
export LIBERTYIMG=liberty-on-container

# Create default route to local image registry
oc patch configs.imageregistry.operator.openshift.io/cluster --patch '{"spec":{"defaultRoute":true}}' --type=merge
# Login to the local image registry
export REGISTRY=`oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}'`
echo $REGISTRY
podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false $REGISTRY


# Create trusted-ca ConfigMap, mirrored from the cluster wide one
cd guide-getting-started-liberty
oc apply -f cm-trusted-ca.yml

oc create -f guide-getting-started-liberty/user-ca-bundle.yaml
echo "Please edit the cluster wide proxy: oc edit proxy/cluster"
echo -e "  insert\n          trustedCA:\n            name: user-ca-bundle"
read -p "---->  Continue?..."

oc apply -f cm-trusted-ca.yml


# Create the deployment for the app, which calls the remote service
oc apply -f guide-getting-started-liberty-deployment.yml
oc expose deployment/$LIBERTYIMG --port LIBERTYPORT --target-port LIBERTYPORT
oc expose svc/$LIBERTYIMG

# Login to the local image registry
export REGISTRY=`oc get route default-route -n openshift-image-registry --template='{{ .spec.host }}'`
echo $REGISTRY
podman login -u kubeadmin -p $(oc whoami -t) --tls-verify=false $REGISTRY
cd finish/

echo "You may now upload the app image ..."
