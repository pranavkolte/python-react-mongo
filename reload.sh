#!/bin/bash

# Stop minikube if running
echo "Stopping Minikube..."
minikube stop

# Start fresh minikube
echo "Starting Minikube..."
minikube start
minikube addons enable ingress

# Set docker env to minikube's docker daemon
echo "Setting Docker environment..."
eval $(minikube -p minikube docker-env)

# Build Docker images
echo "Building Docker images..."
docker build -t backend-fast-api-app:latest ./backend
docker build -t frontend:latest ./frontend

# Delete existing K8s resources
echo "Cleaning up existing resources..."
kubectl delete all --all
kubectl delete ingress --all
kubectl delete configmap --all
kubectl delete secret --all

# Apply K8s configurations
echo "Applying Kubernetes configurations..."
kubectl apply -f kubernetes-config/config/
kubectl apply -f kubernetes-config/deployments/
kubectl apply -f kubernetes-config/services/
kubectl apply -f kubernetes-config/ingress/

# Wait for pods to be ready
echo "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=300s

# Set up port forwarding
echo "Setting up port forwarding..."
kubectl port-forward svc/frontend-service 3000:80 &
kubectl port-forward svc/backend-service 8000:8000 &
kubectl port-forward svc/prometheus-service 9090:9090 &

# Display service URLs
echo -e "\nServices are available at:"
echo "Frontend: http://localhost:3000"
echo "Backend: http://localhost:8000"
echo "Prometheus: http://localhost:9090"

# Display pod status
kubectl get pods