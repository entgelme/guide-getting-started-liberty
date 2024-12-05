#!/bin/bash 

export LIBERTYPORT=9080
export LIBERTYIMG=liberty-on-container

oc apply -f guide-getting-started-liberty-deployment.yml
oc expose deployment/$LIBERTYIMG --port LIBERTYPORT --target-port LIBERTYPORT
oc expose svc/$LIBERTYIMG
