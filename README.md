# PodCamilo · Redis en Kubernetes

La práctica despliega Redis 7.4 en un clúster local de Kubernetes. Redis se usa para guardar datos de acceso rápido, como resultados en caché, sesiones temporales y contadores.

## Cómo se cumple la práctica

- **Deployment:** declara dos pods de Redis con la misma configuración.
- **ReplicaSet:** Kubernetes lo crea a partir del Deployment para mantener dos pods. Durante la prueba se eliminó uno y el mismo ReplicaSet lo repuso.
- **Exposición:** un Service da acceso a Redis dentro del clúster. El reenvío de puertos permite conectarse desde el equipo en `127.0.0.1:16379`. Se comprobó que Redis respondió `PONG`.

Los dos pods ejecutan instancias independientes con datos temporales. El ReplicaSet mantiene la cantidad de pods.

## Qué contiene el repositorio

- **deploy/** contiene `k3d-config.yaml`, que define el clúster local, y `redis.yaml`, que define el namespace, el Deployment y el Service.
