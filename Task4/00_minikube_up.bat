cls
choco install openssl
docker desktop start
minikube start --driver=docker
minikube addons enable metrics-server
minikube dashboard