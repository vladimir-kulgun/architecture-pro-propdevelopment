@echo off

REM Usage: check_user.bat <username> <namespace>
REM Example: check_user.bat carol pro-development-accountant

IF "%1"=="" (
    echo Error: No username specified.
    echo Usage: %0 ^<username^> ^<namespace^>
    exit /b 1
)
IF "%2"=="" (
    echo Error: No namespace specified.
    echo Usage: %0 ^<username^> ^<namespace^>
    exit /b 1
)

set USER=%1
set NAMESPACE=%2

echo ============================
echo Checking permissions for user %USER% in namespace %NAMESPACE%
echo ============================

echo Checking if %USER% can GET pods:
kubectl auth can-i get pods --namespace=%NAMESPACE% --as=%USER%
echo.

echo Checking if %USER% can GET secrets:
kubectl auth can-i get secrets --namespace=%NAMESPACE% --as=%USER%
echo.

echo Checking if %USER% can LIST configmaps:
kubectl auth can-i list configmaps --namespace=%NAMESPACE% --as=%USER%
echo.

echo Checking if %USER% can CREATE deployments:
kubectl auth can-i create deployments --namespace=%NAMESPACE% --as=%USER%
echo.

echo ============================
echo Listing all allowed actions for %USER% in namespace %NAMESPACE%
echo ============================

kubectl auth can-i --list --namespace=%NAMESPACE% --as=%USER%
echo.

@pause