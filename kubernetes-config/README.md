# Kubernetes Configuration for Python-React-Mongo Application

This project contains Kubernetes manifests for deploying a Python backend, a React frontend, and a MongoDB database. The manifests include deployments, services, config maps, secrets, and ingress resources.

## Prerequisites

- Kubernetes cluster (Minikube or any other)
- kubectl command-line tool installed
- Minikube Ingress Controller enabled (if using Minikube)

## Directory Structure

```
kubernetes-config
├── deployments
│   ├── backend-deployment.yaml
│   ├── frontend-deployment.yaml
│   └── mongodb-deployment.yaml
├── services
│   ├── backend-service.yaml
│   ├── frontend-service.yaml
│   └── mongodb-service.yaml
├── config
│   ├── configmap.yaml
│   └── secret.yaml
├── ingress
│   └── ingress.yaml
└── README.md
```

## Applying the Manifests

To deploy the application, navigate to the `kubernetes-config` directory and run the following commands:

```bash
kubectl apply -f deployments/
kubectl apply -f services/
kubectl apply -f config/
kubectl apply -f ingress/
```

## Accessing the Application

After applying the manifests, you can access the frontend service via the Ingress resource. Make sure to check the Ingress rules defined in `ingress/ingress.yaml`.

## Notes

- Ensure that the MongoDB connection string in `config/secret.yaml` is correctly set up.
- Adjust the number of replicas in the deployment files as needed for your environment.