# Start port-forwarding for each service
Start-Process powershell {kubectl port-forward svc/frontend-service 3000:80}
Start-Process powershell {kubectl port-forward svc/backend-service 8000:8000}
Start-Process powershell {kubectl port-forward svc/prometheus-service 9090:9090}