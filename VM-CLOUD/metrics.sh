#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# SSH Config
SSH_HOST="master.muestra.qzz.io"
SSH_KEY="$HOME/.ssh/muestra"

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  Kubernetes Cluster Metrics${NC}"
echo -e "${BLUE}================================${NC}\n"

# Cluster Info
echo -e "${YELLOW}CLUSTER INFO${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl cluster-info | grep 'Kubernetes master\|control plane'"
echo ""

# Nodes
echo -e "${YELLOW}NODES STATUS${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl get nodes -o wide"
echo ""

# Node Resources
echo -e "${YELLOW}NODE RESOURCES${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl top nodes 2>/dev/null || echo 'Metrics server not installed'"
echo ""

# Namespaces
echo -e "${YELLOW}NAMESPACES${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl get namespaces --no-headers | awk '{print \$1}'"
echo ""

# Production Metrics
echo -e "${YELLOW}PRODUCTION (muestra-prod)${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "
echo 'Pods:'
kubectl get pods -n muestra-prod --no-headers 2>/dev/null | wc -l
echo 'Deployments:'
kubectl get deployments -n muestra-prod -o wide 2>/dev/null
echo 'Pod Resources:'
kubectl top pods -n muestra-prod 2>/dev/null || echo 'Metrics not available'
"
echo ""

# Staging Metrics
echo -e "${YELLOW}STAGING (muestra-staging)${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "
echo 'Pods:'
kubectl get pods -n muestra-staging --no-headers 2>/dev/null | wc -l
echo 'Deployments:'
kubectl get deployments -n muestra-staging -o wide 2>/dev/null
echo 'Pod Resources:'
kubectl top pods -n muestra-staging 2>/dev/null || echo 'Metrics not available'
"
echo ""

# Development Metrics
echo -e "${YELLOW}DEVELOPMENT (muestra-dev)${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "
echo 'Pods:'
kubectl get pods -n muestra-dev --no-headers 2>/dev/null | wc -l
echo 'Deployments:'
kubectl get deployments -n muestra-dev -o wide 2>/dev/null
echo 'Pod Resources:'
kubectl top pods -n muestra-dev 2>/dev/null || echo 'Metrics not available'
"
echo ""

# HPA Status
echo -e "${YELLOW}HORIZONTAL POD AUTOSCALERS${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "
for ns in muestra-prod muestra-staging muestra-dev; do
  echo 'Namespace: '$ns
  kubectl get hpa -n \$ns 2>/dev/null || echo 'No HPA found'
  echo ''
done
"
echo ""

# Ingress
echo -e "${YELLOW}INGRESS${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl get ingress -A"
echo ""

# Services
echo -e "${YELLOW}SERVICES (Production)${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl get svc -n muestra-prod"
echo ""

# Storage
echo -e "${YELLOW}STORAGE${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl get pvc -A"
echo ""

# Events
echo -e "${YELLOW}RECENT EVENTS${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "kubectl get events -A --sort-by='.lastTimestamp' | tail -10"
echo ""

# Resource Summary
echo -e "${YELLOW}CLUSTER RESOURCE SUMMARY${NC}"
ssh -i "$SSH_KEY" "ubuntu@$SSH_HOST" "
echo 'Total CPU Available:'
kubectl describe nodes | grep 'cpu' | grep -E 'Allocatable|Allocated' | head -2
echo ''
echo 'Total Memory Available:'
kubectl describe nodes | grep 'memory' | grep -E 'Allocatable|Allocated' | head -2
"
echo ""

echo -e "${BLUE}================================${NC}"
echo -e "${BLUE}  End of Metrics Report${NC}"
echo -e "${BLUE}================================${NC}"