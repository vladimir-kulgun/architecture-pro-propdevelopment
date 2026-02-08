cls
kubectl delete -f gatekeeper
kubectl delete -f https://raw.githubusercontent.com/open-policy-agent/gatekeeper/master/deploy/gatekeeper.yaml
kubectl delete -f insecure-manifests
kubectl delete -f secure-manifests
kubectl delete -f 01-create-namespace.yaml