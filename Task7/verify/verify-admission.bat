@echo off
echo Testing Gatekeeper with non-compliant pod...

REM Create a temporary YAML file for a privileged pod
set POD_FILE=%TEMP%\test-privileged.yaml
echo apiVersion: v1> %POD_FILE%
echo kind: Pod>> %POD_FILE%
echo metadata:>> %POD_FILE%
echo   name: test-privileged>> %POD_FILE%
echo   namespace: audit-zone>> %POD_FILE%
echo spec:>> %POD_FILE%
echo   containers:>> %POD_FILE%
echo     - name: app>> %POD_FILE%
echo       image: nginx:alpine>> %POD_FILE%
echo       securityContext:>> %POD_FILE%
echo         privileged: true>> %POD_FILE%

REM Try to apply the pod
kubectl apply -f %POD_FILE% > %TEMP%\kubectl_output.txt 2>&1

REM Check if Gatekeeper blocked it
findstr /i "forbidden" %TEMP%\kubectl_output.txt >nul
if %ERRORLEVEL%==0 (
    echo PASS: Gatekeeper blocked non-compliant pod.
) else (
    echo FAIL: Non-compliant pod was created!
)

REM Clean up temporary file
del %POD_FILE%
del %TEMP%\kubectl_output.txt
