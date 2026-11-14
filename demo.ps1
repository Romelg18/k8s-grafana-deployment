# Demo Deployment + ReplicaSet con Grafana en Minikube (con pausas para capturas)
# Ejecutar desde esta carpeta:  powershell -ExecutionPolicy Bypass -File .\demo.ps1
# En cada pausa: toma la captura (Win+Shift+S), guardala en capturas\ y presiona Enter.
Set-Location $PSScriptRoot
function Paso($t) { Write-Host "`n===== $t =====" -ForegroundColor Cyan }
function Pausa($m) { Write-Host "`n>>> CAPTURA: $m" -ForegroundColor Yellow; Read-Host "Presiona Enter para continuar" | Out-Null }

Paso "0. Iniciar Minikube"
minikube start --driver=docker
kubectl get nodes

Paso "1. Crear Deployment y Service (3 replicas)"
kubectl apply -f grafana-deployment.yml
kubectl apply -f grafana-service.yml
kubectl rollout status deployment/grafana-deployment --timeout=300s
kubectl get deployments
kubectl get replicaset
kubectl get pods -o wide
kubectl get svc grafana-service
Pausa "01 - Deployment, ReplicaSet, Pods y Service"

Paso "2. Autorreparacion: borrar un pod"
$pod = (kubectl get pods -l app=grafana -o jsonpath="{.items[0].metadata.name}")
kubectl delete pod $pod
Start-Sleep -Seconds 3
kubectl get pods
Pausa "02 - Pod nuevo creado por el ReplicaSet (AGE de segundos)"

Paso "3. Escalado a 5"
kubectl scale deployment grafana-deployment --replicas=5
Start-Sleep -Seconds 8
kubectl get pods
kubectl get replicaset
Pausa "03 - Escalado a 5 replicas"

Paso "3b. Escalado a 3"
kubectl scale deployment grafana-deployment --replicas=3
Start-Sleep -Seconds 8
kubectl get pods
Pausa "03b - Reduccion a 3 replicas"

Paso "4. Rolling update a Grafana 11.0.0"
kubectl set image deployment/grafana-deployment grafana=grafana/grafana:11.0.0
kubectl rollout status deployment/grafana-deployment --timeout=300s
kubectl get replicaset
kubectl get pods
Pausa "04 - Dos ReplicaSets: el viejo en 0 y el nuevo activo"

Paso "5. Historial y rollback"
kubectl rollout history deployment/grafana-deployment
kubectl rollout undo deployment/grafana-deployment
kubectl rollout status deployment/grafana-deployment --timeout=300s
kubectl get replicaset
Pausa "05 - Rollback a la version anterior"

Paso "6. Descripcion del Deployment"
kubectl describe deployment grafana-deployment
Pausa "06 - describe deployment"

Paso "7. Exponer Grafana"
Write-Host "Abre una ventana de INCOGNITO en http://localhost:3000  (admin / admin)" -ForegroundColor Green
Write-Host "Captura el login y el dashboard. Cierra con Ctrl+C cuando termines."
kubectl port-forward deployment/grafana-deployment 3000:3000
