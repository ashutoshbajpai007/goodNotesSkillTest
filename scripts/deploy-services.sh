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
  --set controller.service.type=ClusterIP

# Wait for ingress-nginx controller to be ready before proceeding
kubectl wait --namespace ingress-nginx --for=condition=ready pod --selector=app.kubernetes.io/component=controller --timeout=300s

# Start port-forward to expose ingress on localhost:80
kubectl port-forward -n ingress-nginx svc/ingress-nginx-controller 80:80 &

# Wait for port-forward to establish
sleep 5

# Install echo-app via Helm (now safe, as webhook is ready)
helm install echo-app $HELM_CHART_PATH

# Log the Ingress configuration for verification
echo "Ingress configuration:"
kubectl get ingress -o yaml