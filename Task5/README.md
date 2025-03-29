# Задание 5. Управление трафиком внутри кластера Kubertnetes

В этом задании вам нужно разграничить трафик между сервисами, которые развёрнуты в кластере Kubernetes:

- Вам необходимо добавить новый сервис. В терминах Kubernetes это под (pod). При этом нужно запретить другим подам с ним
  взаимодействовать.
- Необходимо изолировать трафик к новому сервису от других подов.

# Решение

- Создание сервисов с метками - [сreate_services.sh](%D1%81reate_services.sh)
- Создание Network Policy для изоляции сервисов - [network-policies.yaml](network-policies.yaml)
- Создание сетевых политик - [non-admin-api-allow.yaml](non-admin-api-allow.yaml)
- Проверка доступа - [check.sh](check.sh)

- Применение Network Policy :
```
kubectl apply -f network-policies.yaml
```