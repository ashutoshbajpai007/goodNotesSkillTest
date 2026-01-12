#!/bin/bash
# filepath: scripts/create-kind-cluster.sh
# Reusable script to create a KinD cluster.
# Usage: ./create-kind-cluster.sh <cluster-name> <config-file>

CLUSTER_NAME=${1:-ci-cluster}
CONFIG_FILE=${2:-kind-config.yaml}

cat <<EOF > $CONFIG_FILE
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
  kubeadmConfigPatches:
  - |
    kind: InitConfiguration
    nodeRegistration:
      kubeletExtraArgs:
        node-labels: "ingress-ready=true"
  extraPortMappings:
  - containerPort: 30080
    hostPort: 80
    protocol: TCP
  - containerPort: 443
    hostPort: 443
    protocol: TCP
- role: worker
EOF

kind create cluster --config $CONFIG_FILE --name $CLUSTER_NAME