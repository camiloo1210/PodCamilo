# Pod Camilo

Laboratorio local e independiente de Kubernetes: un clúster **k3d/K3s** que despliega Redis.

## Qué se crea

```text
k3d podcamilo
└── namespace podcamilo
    ├── Deployment redis-cache (2 pods Redis)
    ├── ReplicaSet redis-cache-…
    └── Service redis-cache
```

No usa Kivi ni Argo CD. La configuración está en `deploy/redis.yaml` y el informe de entrega en `INFORME.md`.

## Requisitos

- Docker Desktop iniciado (modo Linux).
- `kubectl` disponible.
- `k3d` v5.9.0 disponible en el `PATH`.

## Iniciar

```powershell
./scripts/start.ps1
./scripts/start.ps1 -OpenSite
```

El segundo comando expone Redis en `localhost:16379` mientras la terminal permanezca abierta.

## Verificar y detener

```powershell
kubectl --context k3d-podcamilo -n podcamilo get deployment,replicaset,pods,service
k3d cluster stop podcamilo
```

Para volver a iniciarlo: `k3d cluster start podcamilo`.
