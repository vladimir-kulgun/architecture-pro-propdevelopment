@echo off
echo Testing Gatekeeper with compliant pod...

REM Create a temporary YAML file for a compliant pod
set POD_FILE=%TEMP%\test-compliant.yaml
echo apiVersion: v1> %POD_FILE%
echo kind: Pod>> %POD_FILE%
echo metadata:>> %POD_FILE%
echo   name: test-compliant>> %POD_FILE%
echo   namespace: audit-zone>> %POD_FILE%
echo spec:>> %POD_FILE%
echo   containers:>> %POD_FILE%
echo     - name: app>> %POD_FILE%
echo       image: nginx:alpine>> %POD_FILE%
echo       securityContext:>> %POD_FILE%
echo         allowPrivilegeEscalation: false>> %POD_FILE%
echo         runAsNonRoot: true>> %POD_FILE%
echo         readOnlyRootFilesystem: true>> %POD_FILE%
echo         capabilities:>> %POD_FILE%
echo           drop: [ "ALL" ]>> %POD_FILE%
echo         seccompProfile:>> %POD_FILE%
echo           type: RuntimeDefault>> %POD_FILE%

REM Try to apply the pod
kubectl apply -f %POD_FILE% > %TEMP%\kubectl_output.txt 2>&1

REM Check if pod was created
findstr /i "created" %TEMP%\kubectl_output.txt >nul
if %ERRORLEVEL%==0 (
    echo PASS: Compliant pod created successfully.
) else (
    echo FAIL: Compliant pod was blocked!
)

REM Clean up
kubectl delete pod test-compliant -n audit-zone >nul 2>&1
del %POD_FILE%
del %TEMP%\kubectl_output.txt
