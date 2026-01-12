#!/bin/bash
# filepath: scripts/wait-for-readiness.sh
# Reusable script to wait for readiness.
# Usage: ./wait-for-readiness.sh <timeout>

TIMEOUT=${1:-300s}

kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=$TIMEOUT
kubectl wait --for=condition=available --timeout=$TIMEOUT deployment/foo-deployment
kubectl wait --for=condition=available --timeout=$TIMEOUT deployment/bar-deployment
kubectl wait --for=condition=ready pod --selector=app=foo --timeout=$TIMEOUT
kubectl wait --for=condition=ready pod --selector=app=bar --timeout=$TIMEOUT