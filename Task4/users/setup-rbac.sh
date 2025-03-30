#!/bin/bash

# Проверяем, запущен ли Minikube
if ! minikube status >/dev/null 2>&1; then
  echo "Minikube не запущен. Запускаю..."
  minikube start
fi

# Список пользователей и их групп
declare -A users=(
  ["admin-user"]="system:masters"
  ["devops-user"]="devops-group"
  ["security-user"]="security-group"
  ["viewer-user"]="viewer-group"
  ["editor-user"]="editor-group"
)

# Создаем пользователей
for user in "${!users[@]}"; do
  group=${users[$user]}

  echo "Создаю пользователя: $user (группа: $group)"

  # Генерация ключа и CSR
  openssl genrsa -out "$user.key" 2048
  openssl req -new -key "$user.key" -out "$user.csr" -subj "/CN=$user/O=$group"

  # Подпись CSR с помощью CA Minikube
  openssl x509 -req -in "$user.csr" -CA ~/.minikube/ca.crt -CAkey ~/.minikube/ca.key -CAcreateserial -out "$user.crt" -days 365

  # Добавление в kubeconfig
  kubectl config set-credentials "$user" --client-certificate="$user.crt" --client-key="$user.key"
  kubectl config set-context "$user" --cluster=minikube --user="$user"

  # Очистка временных файлов
  rm "$user.csr"

  echo "Пользователь $user создан и добавлен в kubeconfig"
done

echo -e "\nГотово! Созданы пользователи:"
printf "• %s\n" "${!users[@]}"

echo -e "\nДля переключения между пользователями используйте:"
echo "kubectl config use-context <имя_пользователя>"