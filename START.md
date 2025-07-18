```shell
helm install gin-quasar-frontend quasar
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
docker compose up -d --build --force-recreate
```
```shell
docker compose up -d
```
```shell
docker logs -f gin-quasar-frontend-server-1
```

```shell
bash build_and_load.sh 0.0.4
```
```shell
helm upgrade gin-quasar-frontend quasar
```

```shell
kubectl port-forward svc/gin-quasar-backend 9901:80
```

```shell
kubectl port-forward svc/gin-quasar-frontend 9902:80
echo http://127.0.0.1:9902
```
