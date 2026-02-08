#!/bin/sh

NAMESPACE="pro-development-smart-home"

# Тестируем Pod внутри кластера
POD=$(kubectl run np-test --rm -i --tty --image=curlimages/curl -n $NAMESPACE -- /bin/sh -c "sleep 3600" &)
sleep 2

function test_connection() {
  FROM=$1
  TO=$2
  PORT=$3
  RESULT=$(kubectl exec -n $NAMESPACE $FROM -- curl -s -o /dev/null -w "%{http_code}" http://$TO:$PORT || echo "BLOCKED")
  if [ "$RESULT" = "200" ]; then
    echo "$FROM → $TO:$PORT  ✅ ALLOWED"
  else
    echo "$FROM → $TO:$PORT  ❌ BLOCKED"
  fi
}

# Список Pod'ов (подставьте ваши имена Pod'ов)
FRONT_END_POD=$(kubectl get pods -n $NAMESPACE -l role=front-end -o jsonpath='{.items[0].metadata.name}')
ADMIN_FRONT_END_POD=$(kubectl get pods -n $NAMESPACE -l role=admin-front-end -o jsonpath='{.items[0].metadata.name}')

BACK_END_SVC="back-end-api-app"
ADMIN_BACK_END_SVC="admin-back-end-api-app"
PORT=80

echo "=== Checking allowed connections ==="
test_connection $FRONT_END_POD $BACK_END_SVC $PORT
test_connection $ADMIN_FRONT_END_POD $ADMIN_BACK_END_SVC $PORT

echo "=== Checking blocked connections ==="
test_connection $FRONT_END_POD $ADMIN_BACK_END_SVC $PORT
test_connection $ADMIN_FRONT_END_POD $BACK_END_SVC $PORT
