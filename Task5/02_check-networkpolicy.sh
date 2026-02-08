#!/bin/bash

NAMESPACE="pro-development-smart-home"
PORT=80

echo ""
echo "=== Pods ==="
kubectl get pods -n $NAMESPACE
echo ""
echo "=== Services ==="
kubectl get services -n $NAMESPACE
echo ""
echo "=== NetworkPolicies ==="
kubectl get networkpolicies -n $NAMESPACE

# Get service cluster IPs
FRONT_END_IP=$(kubectl get svc front-end-app -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')
BACK_END_IP=$(kubectl get svc back-end-api-app -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')
ADMIN_FRONT_IP=$(kubectl get svc admin-front-end-app -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')
ADMIN_BACK_IP=$(kubectl get svc admin-back-end-api-app -n $NAMESPACE -o jsonpath='{.spec.clusterIP}')

echo ""
echo "Service IPs:"
echo "front-end:       $FRONT_END_IP"
echo "back-end-api:    $BACK_END_IP"
echo "admin-front-end: $ADMIN_FRONT_IP"
echo "admin-back-end:  $ADMIN_BACK_IP"

# Get Pod names
FRONT_END_POD=$(kubectl get pods -n $NAMESPACE -l role=front-end -o jsonpath='{.items[0].metadata.name}')
ADMIN_FRONT_POD=$(kubectl get pods -n $NAMESPACE -l role=admin-front-end -o jsonpath='{.items[0].metadata.name}')

# Function to test connection
test_connection() {
    local SOURCE_POD=$1
    local TARGET_IP=$2
    local EXPECTED=$3

    RESULT=$(kubectl exec -n $NAMESPACE $SOURCE_POD -- curl -s --max-time 5 http://$TARGET_IP >/dev/null 2>&1 && echo "ALLOWED" || echo "BLOCKED")

    printf "%-35s | %-8s | %-8s\n" "$SOURCE_POD -> $TARGET_IP" "$EXPECTED" "$RESULT"
}

echo ""
echo "=== NetworkPolicy Test Results ==="
printf "%-35s | %-8s | %-8s\n" "Connection" "Expected" "Result"
printf "%-35s | %-8s | %-8s\n" "-----------------------------------" "--------" "--------"

# Allowed connections
test_connection $FRONT_END_POD $BACK_END_IP "ALLOWED"
test_connection $ADMIN_FRONT_POD $ADMIN_BACK_IP "ALLOWED"

# Blocked connections
test_connection $FRONT_END_POD $ADMIN_BACK_IP "BLOCKED"
test_connection $ADMIN_FRONT_POD $BACK_END_IP "BLOCKED"

echo ""
echo "=== NetworkPolicy check complete ==="
