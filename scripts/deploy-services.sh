#!/bin/bash
# filepath: scripts/deploy-services.sh
# Reusable script to deploy services via Helm.
# Usage: ./deploy-services.sh <helm-chart-path>

HELM_CHART_PATH=${1:-./helm/echo-chart}

# Add ingress-nginx Helm repo if not present
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install ingress-nginx via Helm in its own namespace
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --set-string controller.nodeSelector.ingress-ready=true \
  --set controller.tolerations[0].key=node-role.kubernetes.io/master \
  --set controller.tolerations[0].effect=NoSchedule \
  --set controller.tolerations[0].operator=Exists \
  --set controller.service.type=LoadBalancer

# Wait for ingress-nginx controller to be ready before proceeding
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=300s

# Install echo-app via Helm (now safe, as webhook is ready)
helm install echo-app $HELM_CHART_PATH