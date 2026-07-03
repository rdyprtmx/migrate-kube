#!/bin/bash
# Deploy monitoring stack to k3s cluster
# Usage: ./deploy.sh

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NAMESPACE="monitoring"

echo "=== Deploying Monitoring Stack ==="

# Create namespace
echo "[1/5] Creating namespace..."
kubectl create namespace ${NAMESPACE} --dry-run=client -o yaml | kubectl apply -f -

# Deploy Prometheus
echo "[2/5] Deploying Prometheus..."
kubectl apply -f ${SCRIPT_DIR}/../prometheus/ -n ${NAMESPACE}

# Deploy Grafana
echo "[3/5] Deploying Grafana..."
kubectl apply -f ${SCRIPT_DIR}/../grafana/ -n ${NAMESPACE}

# Deploy Alertmanager
echo "[4/5] Deploying Alertmanager..."
kubectl apply -f ${SCRIPT_DIR}/../alertmanager/ -n ${NAMESPACE}

# Wait for pods
echo "[5/5] Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod -l app=prometheus -n ${NAMESPACE} --timeout=120s
kubectl wait --for=condition=ready pod -l app=grafana -n ${NAMESPACE} --timeout=120s

echo ""
echo "=== Deployment Complete ==="
echo ""
echo "Access Grafana:"
echo "  kubectl port-forward svc/grafana 3000:3000 -n ${NAMESPACE}"
echo ""
echo "Access Prometheus:"
echo "  kubectl port-forward svc/prometheus 9090:9090 -n ${NAMESPACE}"
