# Informe individual — Deployment y ReplicaSet con Redis

**Plataforma seleccionada:** Redis 7.4

**Repositorio público:** al publicar este repositorio, reemplazar con `https://github.com/<usuario>/podcamilo`
**Repositorio local:** `T:\\Kiroku\\podcamilo`

## Objetivo

Desplegar Redis en Kubernetes y comprobar cómo un **Deployment** mantiene la cantidad solicitada de pods por medio de un **ReplicaSet**.

Redis guarda datos en memoria y es muy rápido. Esta práctica usa datos temporales, porque su objetivo es aprender los recursos de Kubernetes.

## Configuración aplicada

El manifiesto está en [deploy/redis.yaml](deploy/redis.yaml).

```text
Deployment redis-cache
        │ crea y supervisa
ReplicaSet redis-cache-65c948c696
        │ mantiene 2 copias
2 Pods Redis
        │ reciben tráfico interno
Service redis-cache :6379
```

- El Deployment declara `replicas: 2`.
- Kubernetes creó un ReplicaSet con dos pods Redis listos.
- Si se elimina un pod, el ReplicaSet crea otro para volver a dos.
- El Service ofrece un nombre y puerto estables: `redis-cache:6379`.
- Cada pod tiene límites de 100m CPU y 64Mi de memoria. Los datos son temporales (`emptyDir`).

## Usos de Redis

- Caché de resultados para reducir consultas lentas.
- Sesiones temporales de usuarios.
- Contadores, límites de peticiones y rankings.
- Colas simples de tareas.

Dos pods Redis independientes no forman una solución de alta disponibilidad. Para producción se usaría Redis Sentinel o Redis Cluster. Aquí las dos réplicas permiten observar el trabajo del Deployment y ReplicaSet.

## Despliegue y exposición

```powershell
$env:Path = "T:\\Kiroku\\tools;$env:Path"
./scripts/start.ps1
kubectl --context k3d-podcamilo -n podcamilo port-forward service/redis-cache 16379:6379
```

Redis queda expuesto de forma local en `localhost:16379`. La validación se realiza con:

```powershell
kubectl --context k3d-podcamilo -n podcamilo exec deployment/redis-cache -- redis-cli ping
```

## Evidencia de ejecución

**Captura 1 — configuración y réplicas**

```text
deployment.apps/redis-cache   2/2   2   2
replicaset.apps/redis-cache-65c948c696   2   2   2
pod/redis-cache-65c948c696-7frtc   1/1   Running
pod/redis-cache-65c948c696-r7hzd   1/1   Running
service/redis-cache   ClusterIP   6379/TCP
```

**Captura 2 — plataforma expuesta y funcionando**

```text
redis-cli: PONG
Puerto local 127.0.0.1:16379: True
```

Estas salidas fueron obtenidas del clúster local. Para adjuntar las imágenes al aula, ejecutar los dos bloques y tomar una captura del terminal con `k3d-podcamilo`, los dos pods `Running` y `PONG` visibles.

## Conclusión

El Deployment expresa el estado deseado: dos Redis. El ReplicaSet se encarga de conservar esa cantidad. El Service evita depender del nombre cambiante de los pods y permite exponer Redis de forma controlada durante la práctica.
