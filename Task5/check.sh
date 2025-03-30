# Создаем тестовый pod с меткой front-end
kubectl run tester --image=alpine --labels role=front-end --restart=Never -- sleep 3600

# Ждем пока pod поднимется
kubectl wait --for=condition=Ready pod/tester --timeout=60s

# Проверяем разрешенные соединения (front-end → back-end-api)
echo "Проверка разрешенного соединения front-end → back-end-api:"
kubectl exec tester -- sh -c 'wget -T 5 -qO- http://back-end-api-app && echo "✅ SUCCESS" || echo "❌ FAILED"'

# Проверяем запрещенные соединения (front-end → admin-back-end-api)
echo "Проверка запрещенного соединения front-end → admin-back-end-api:"
kubectl exec tester -- sh -c 'wget -T 3 -qO- http://admin-back-end-api-app && echo "❌ FAILED" || echo "✅ SUCCESS"'

# Удаляем тестовый pod
kubectl delete pod tester



# Создаем тестовый pod с меткой admin-front-end
kubectl run admin-tester --image=alpine --labels role=admin-front-end --restart=Never -- sleep 3600

# Ждем пока pod поднимется
kubectl wait --for=condition=Ready pod/admin-tester --timeout=60s

# Проверяем разрешенные соединения (admin-front-end → admin-back-end-api)
echo "Проверка разрешенного соединения admin-front-end → admin-back-end-api:"
kubectl exec admin-tester -- sh -c 'wget -T 5 -qO- http://admin-back-end-api-app && echo "✅ SUCCESS" || echo "❌ FAILED"'

# Проверяем запрещенные соединения (admin-front-end → back-end-api)
echo "Проверка запрещенного соединения admin-front-end → back-end-api:"
kubectl exec admin-tester -- sh -c 'wget -T 3 -qO- http://back-end-api-app && echo "❌ FAILED" || echo "✅ SUCCESS"'

# Удаляем тестовый pod
kubectl delete pod admin-tester