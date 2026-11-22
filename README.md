# PodCamilo · Redis en Kubernetes

Práctica de Deployment y ReplicaSet con Redis 7.4 en k3d. El Deployment `redis-cache` declara dos pods y Kubernetes crea el ReplicaSet que los mantiene. El Service ClusterIP ofrece `redis-cache:6379` dentro del clúster.

- [Repositorio público en GitHub](https://github.com/camiloo1210/PodCamilo)
- [Informe editable con configuración y evidencias](entregables/Informe%20editable%20-%20Camilo%20Brazales%20-%20Redis.docx)
- [Manifiesto de Kubernetes](deploy/redis.yaml)

## Ejecutar la práctica

Con Docker Desktop en modo Linux, k3d v5.9.0 y kubectl disponibles, ejecuta desde la raíz del repositorio:

```powershell
./scripts/start.ps1
kubectl --context k3d-podcamilo -n podcamilo get deployment,replicaset,pods,service
```

Puedes indicar el ejecutable de k3d con `-K3dPath`. Para exponer Redis, ejecuta `./scripts/start.ps1 -OpenSite` y deja esa terminal abierta. En otra terminal, si tienes `redis-cli`:

```powershell
redis-cli -h 127.0.0.1 -p 16379 PING
```

La respuesta esperada es `PONG`. Redis usa TCP. La exposición local termina al cerrar el port-forward. Detén el laboratorio con `k3d cluster stop podcamilo`.

## Usos de Redis

Caché de consultas, sesiones temporales, contadores o colas sencillas. En esta práctica los dos pods ejecutan instancias independientes con almacenamiento temporal. El ReplicaSet mantiene el número de pods de Kubernetes.
