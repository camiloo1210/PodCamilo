# Pod Camilo

Laboratorio local e independiente de Kubernetes: un clúster **k3d/K3s** y un pod web básico.

## Qué se crea

```text
k3d podcamilo
└── namespace podcamilo
    ├── Deployment podcamilo-web (1 pod Nginx)
    └── Service podcamilo-web
```

No usa Kivi ni Argo CD. El contenido de la página está en `deploy/web.yaml` para que sea fácil ver la relación entre manifiesto y pod.

## Requisitos

- Docker Desktop iniciado (modo Linux).
- `kubectl` disponible.
- `k3d` v5.9.0 disponible en el `PATH`.

## Iniciar

```powershell
./scripts/start.ps1
./scripts/start.ps1 -OpenSite
```

El segundo comando muestra la página en `http://localhost:18081` mientras la terminal permanezca abierta.

## Verificar y detener

```powershell
kubectl --context k3d-podcamilo -n podcamilo get all
k3d cluster stop podcamilo
```

Para volver a iniciarlo: `k3d cluster start podcamilo`.
