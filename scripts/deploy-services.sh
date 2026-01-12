#!/bin/bash
# filepath: scripts/deploy-services.sh
# Reusable script to deploy services via Helm.
# Usage: ./deploy-services.sh <helm-chart-path>

HELM_CHART_PATH=${1:-./helm/echo-chart}

# Add ingress-nginx Helm repo if not present
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update

# Install ingress-nginx via Helm
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --set controller.nodeSelector.ingress-ready="true" \
  --set controller.tolerations[0].key=node-role.kubernetes.io/master \
  --set controller.tolerations[0].effect=NoSchedule \
  --set controller.tolerations[0].operator=Exists \
  --set controller.service.type=LoadBalancer

# Install echo-app via Helm
helm install echo-app $HELM_CHART_PATH