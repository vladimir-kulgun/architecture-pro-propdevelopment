cls
@echo off
@echo "1. Создайте namespace audit-zone с уровнем PodSecurity restricted"
kubectl apply -f 01-create-namespace.yaml

@echo "2. Разверните три манифеста с нарушениями в insecure-manifests/:"
kubectl apply -f insecure-manifests/01-privileged-pod.yaml
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml
kubectl apply -f insecure-manifests/03-root-user-pod.yaml

@echo "3. Убедитесь, что манифесты НЕ проходят валидацию в audit-zone (если всё верно, admission controller их заблокирует)."
@pause

@echo "4. Исправьте манифесты, чтобы они соответствовали политике, сохраните в secure-manifests/."
kubectl apply -f secure-manifests/01-pod.yaml
kubectl apply -f secure-manifests/02-pod.yaml
kubectl apply -f secure-manifests/03-pod.yaml

rem kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
rem kubectl get pods -n gatekeeper-system 
rem @pause
rem kubectl get pods -n gatekeeper-system 
