cls
kubectl apply -f src\kuberneties\namespaces.yaml
kubectl apply -f src\kuberneties\admin.yaml
kubectl apply -f src\kuberneties\app.yaml
kubectl apply -f src\kuberneties\non-admin-api-allow.yaml
