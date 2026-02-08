@echo off
cls
echo ===============================================
echo 1. Create namespace "audit-zone" with PodSecurity restricted
kubectl apply -f 01-create-namespace.yaml
echo.

echo ===============================================
echo 2. Deploy three non-compliant manifests from insecure-manifests/
kubectl apply -f insecure-manifests/01-privileged-pod.yaml
kubectl apply -f insecure-manifests/02-hostpath-pod.yaml
kubectl apply -f insecure-manifests/03-root-user-pod.yaml
echo.

echo ===============================================
echo 3. Verify that the manifests are blocked by admission controller
echo (Pods should NOT be created if PodSecurity/restricted is enforced)
pause

echo ===============================================
echo 4. Apply corrected manifests from secure-manifests/
kubectl apply -f secure-manifests/01-pod.yaml
kubectl apply -f secure-manifests/02-pod.yaml
kubectl apply -f secure-manifests/03-pod.yaml
echo.

echo ===============================================
echo 5. Deploy OPA Gatekeeper and apply policies
kubectl apply -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
echo Waiting for Gatekeeper pods to start...
kubectl get pods -n gatekeeper-system 
timeout /t 30
kubectl get pods -n gatekeeper-system 
pause

echo Applying ConstraintTemplate and Constraint
kubectl apply -f gatekeeper/constraint-templates/pod-security-template.yaml
kubectl apply -f gatekeeper/constraints/pod-security-constraint.yaml
echo.

echo ===============================================
echo 6. Test Gatekeeper enforcement
call verify\verify-admission.bat
call verify\validate-security.bat
echo.

echo All steps completed.
pause
