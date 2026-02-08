cls
@echo off
@echo "1 Создайте namespace audit-zone с уровнем PodSecurity restricted"
kubectl apply -f 01-create-namespace.yaml

@echo "Разверните три манифеста с нарушениями в insecure-manifests/:"
kubectl apply -f insecure-manifests/01-privileged-pod.yaml
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml
kubectl apply -f insecure-manifests/03-root-user-pod.yaml

rem kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
rem kubectl get pods -n gatekeeper-system 
rem @pause
rem kubectl get pods -n gatekeeper-system 
