cls

mkdir "%USERPROFILE%\.minikube\files\etc\ssl\certs" 2>nul
copy /Y ".\audit-policy.yaml" "%USERPROFILE%\.minikube\files\etc\ssl\certs\audit-policy.yaml"

docker desktop start
minikube start --driver=docker \
  --extra-config=apiserver.audit-log-path=- \
  --extra-config=apiserver.audit-policy-file=/etc/ssl/certs/audit-policy.yaml

minikube addons enable metrics-server
minikube addons enable default-storageclass
minikube addons enable storage-provisioner

minikube status