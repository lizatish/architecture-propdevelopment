#!/bin/bash

# Функция для проверки прав
check_permissions() {
  local role_type=$1
  local role_name=$2
  local namespace=$3

  echo "Проверка $role_type '$role_name' в namespace '$namespace'"

  if [ "$role_type" == "ClusterRole" ]; then
    kubectl get "$role_type" "$role_name" -o yaml | grep -A 10 "rules:"
  else
    kubectl get "$role_type" "$role_name" -n "$namespace" -o yaml | grep -A 10 "rules:"
  fi

  echo ""
}

# Проверка ClusterRole и Role
echo "========== ПРОВЕРКА РОЛЕЙ =========="
check_permissions "ClusterRole" "namespace-admin"
check_permissions "Role" "editor" "default"
check_permissions "Role" "secret-viewer" "default"
check_permissions "Role" "viewer" "default"

# Проверка привязок ролей
echo "========== ПРОВЕРКА ПРИВЯЗОК РОЛЕЙ =========="
kubectl get clusterrolebindings admin-binding -o yaml | grep -A 5 -E "subjects:|roleRef:"
echo ""
kubectl get rolebindings -n default devops-binding -o yaml | grep -A 5 -E "subjects:|roleRef:"
echo ""
kubectl get rolebindings -n default editor-binding -o yaml | grep -A 5 -E "subjects:|roleRef:"
echo ""
kubectl get rolebindings -n default security-binding -o yaml | grep -A 5 -E "subjects:|roleRef:"
echo ""
kubectl get rolebindings -n default viewer-binding -o yaml | grep -A 5 -E "subjects:|roleRef:"