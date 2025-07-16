```shell
helm install gin-quasar-frontend quasar
```

```shell
docker compose up -d --build --force-recreate
```

```shell
#获取访问 Token
kubectl -n kubernetes-dashboard create token admin-user --duration=24h
```
```shell
kubectl proxy
echo http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/
```

```shell
bash build_and_load.sh 0.0.1
```

```shell
helm upgrade gin-quasar-frontend quasar
```

```shell
kubectl port-forward svc/gin-quasar-frontend 9001:80
```
