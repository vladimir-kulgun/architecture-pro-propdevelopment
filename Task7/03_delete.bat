cls
kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
kubectl delete -f src\kuberneties\namespaces.yaml
kubectl delete -f insecure-manifests
kubectl delete -f secure-manifests