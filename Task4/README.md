# Задание 4. Защита доступа к кластеру Kubernetes

В этом задании вы поработаете над решением технической задачи. Вам необходимо организовать ролевой доступ к Kubernetes
для пользователей кластера.

Вот контекст и факты о ролевой модели:

- Большинство бизнес-сервисов разворачивается в среде Kubernetes. Необходимо ограничить доступ к управлению кластером
  для различных групп пользователей.
- Необходимо защитить кластер с помощью предоставления привилегированных действий (например, просмотра секретов) для
  определённых групп пользователей.
- Кроме привилегированных групп пользователей, необходимо выделить ещё минимум две группы пользователей. У первой группы
  есть право только на просмотр ресурсов кластера. Вторая другая группа пользователей может настраивать кластер.
- Необходимо разграничить доступ к ресурсам кластера, исходя из организационной структуры компании.

# Решение

### Таблица ролей и полномочий

| Роль            | Полномочия                                                                | Группы пользователей        
|-----------------|---------------------------------------------------------------------------|-----------------------------
| cluster-admin   | Полный доступ ко всем ресурсам (get, list, create, delete, update, patch) | Администраторы кластера     
| namespace-admin | Полный доступ в рамках одного namespace (кроме Secrets)                   | DevOps-инженеры             
| secret-viewer   | Только чтение Secrets в определённых namespace                            | Специалисты по безопасности 
| viewer          | Только просмотр ресурсов (get, list, watch)                               | Аналитики, менеджеры        
| editor          | Создание и изменение ресурсов (кроме Secrets и RBAC)                      | Разработчики                

- Скрипт для создания пользователей - [create_yser.bash](users/create_yser.bash)
- Скрипты, чтобы создать роли:
    - [editor-role.yaml](roles/editor-role.yaml)
    - [namespace-admin-role.yaml](roles/namespace-admin-role.yaml)
    - [secret-viewer-role.yaml](roles/secret-viewer-role.yaml)
    - [viewer-role.yaml](roles/viewer-role.yaml)
    - *cluster-admin* уже есть в Kubernetes
- Скрипты, чтобы связать пользователей с ролями:
    - [ editor-binding.yaml](bindings/%20editor-binding.yaml)
    - [ security-binding.yaml](bindings/%20security-binding.yaml)
    - [admin-binding.yaml](bindings/admin-binding.yaml)
    - [devops-binding.yaml](bindings/devops-binding.yaml)
    - [viewer-binding.yaml](bindings/viewer-binding.yaml)
- Скрипт для проверки прав ролей: [checker.sh](checker.sh)

Команды для создания ролей:

```
kubectl apply -f editor-role.yaml
kubectl apply -f namespace-admin-role.yaml
kubectl apply -f secret-viewer-role.yaml
kubectl apply -f viewer-role.yaml
```

Команды для привязки ролей:

```
kubectl apply -f admin-binding.yaml
kubectl apply -f devops-binding.yaml
kubectl apply -f security-binding.yaml
kubectl apply -f viewer-binding.yaml
kubectl apply -f editor-binding.yaml
```
