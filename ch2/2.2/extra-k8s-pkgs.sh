#!/usr/bin/env bash

# helm env add (move to parent vagrantfile)
# PATH=$PATH:/usr/local/bin

# main scripfiles dir 
SCRIPTSDIR=$HOME/_Lecture_prometheus_learning.kit/ch2/2.2/extra-k8s-pkgs

# helm 3.9.1 installer
sh $SCRIPTSDIR/get-helm-3.9.1.sh

# repo edu add 
sh $SCRIPTSDIR/helm-repo-add.sh 

# metallb v0.13.3
kubectl apply -f $SCRIPTSDIR/metallb-native-v0.13.3.yaml

# split metallb CRD due to it cannot apply at once. 
# it looks like Operator limitation
# QA: 
# - 240sec cannot deploy on intel MAC. So change Seconds 
# - 300sec can deploy but safety range is from 540 - 600 

# config metallb layer2 mode 
(sleep 540 && kubectl apply -f $SCRIPTSDIR/metallb-l2mode.yaml)&
# config metallb ip range and it cannot deploy now due to CRD cannot create yet 
(sleep 600 && kubectl apply -f $SCRIPTSDIR/metallb-iprange.yaml)&

# metrics server v0.6.1 - insecure mode 
kubectl apply -f  $SCRIPTSDIR/metrics-server-0.6.1.yaml

# NFS dir configuration
sh $SCRIPTSDIR/nfs-exporter.sh dynamic-vol

# nfs-provsioner installer 
kubectl apply -f  $SCRIPTSDIR/nfs-provisioner.yaml

# storageclass installer & set default storageclass
kubectl apply -f $SCRIPTSDIR/storageclass.yaml 

# setup default storage class due to no mention later on
kubectl annotate storageclass managed-nfs-storage storageclass.kubernetes.io/is-default-class=true

