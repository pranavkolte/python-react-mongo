# Scale down the backend deployment to stop running pods
helm install my-release signoz/k8s-infra -f .\kubernetes-config\config\override-values.yaml

kubectl scale deployment backend-deployment --replicas=0

# Build the new Docker image for the backend
docker build -t backend-fast-api-app:latest ./backend

# Scale up the backend deployment to restart with the new image
kubectl scale deployment backend-deployment --replicas=3
