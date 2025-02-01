# Stop minikube if running
Write-Host "Stopping Minikube..."
minikube stop

# Start fresh minikube
Write-Host "Starting Minikube..."
minikube start
minikube addons enable ingress

# Set docker env to minikube's docker daemon
Write-Host "Setting Docker environment..."
& minikube -p minikube docker-env --shell powershell | Invoke-Expression

# Build Docker images
Write-Host "Building Docker images..."
docker build -t backend-fast-api-app:latest ./backend
docker build -t frontend:latest ./frontend

# Delete existing K8s resources
Write-Host "Cleaning up existing resources..."
kubectl delete all --all
kubectl delete ingress --all
kubectl delete configmap --all
kubectl delete secret --all

# Apply K8s configurations
Write-Host "Applying Kubernetes configurations..."
kubectl apply -f kubernetes-config/config/
kubectl apply -f kubernetes-config/deployments/
kubectl apply -f kubernetes-config/services/
kubectl apply -f kubernetes-config/ingress/

# Wait for pods to be ready
Write-Host "Waiting for pods to be ready..."
kubectl wait --for=condition=ready pod --all --timeout=150s

# Set up port forwarding
Write-Host "Setting up port forwarding..."
Start-Process powershell {kubectl port-forward svc/frontend-service 3000:80}
Start-Process powershell {kubectl port-forward svc/backend-service 8000:8000}
Start-Process powershell {kubectl port-forward svc/prometheus-service 9090:9090}

# Display service URLs
Write-Host "`nServices are available at:"
Write-Host "Frontend: http://localhost:3000"
Write-Host "Backend: http://localhost:8000"
Write-Host "Prometheus: http://localhost:9090"

# Display pod status
kubectl get pods