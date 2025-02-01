#!/bin/bash

# Forward frontend service
kubectl port-forward service/frontend-service 3000:80

# Forward backend service
kubectl port-forward service/backend-service 8000:8000 &

# Forward MongoDB service
kubectl port-forward service/mongodb-service 27017:27017 &

# Forward Prometheus service
kubectl port-forward service/prometheus 9090:9090 &

# Wait for all background processes to finish
wait