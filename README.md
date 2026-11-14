# Despliegue de Grafana en Kubernetes (Minikube) con Deployment y ReplicaSet

Tarea individual – Configuración de cluster (Docker Swarm / Kubernetes).

## Contenido
- `grafana-deployment.yml`: Deployment con 3 réplicas (crea automáticamente un ReplicaSet).
- `grafana-service.yml`: Service NodePort que expone Grafana (puerto 3000).
- `demo.ps1`: ejecuta toda la demostración (despliegue, autorreparación, escalado, rolling update, rollback).
- `capturas/`: evidencias (pantallazos).

## Ejecución
```powershell
minikube start --driver=docker
kubectl apply -f grafana-deployment.yml
kubectl apply -f grafana-service.yml
kubectl get deployments,replicaset,pods
minikube service grafana-service
```
Acceso: usuario `admin` / clave `admin`.

## Usos
- **Deployment**: actualizaciones sin caída, rollback, escalado, despliegue declarativo para CI/CD.
- **ReplicaSet**: mantiene N réplicas, autorreparación y balanceo de carga entre pods.
