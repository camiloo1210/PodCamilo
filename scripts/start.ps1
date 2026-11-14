param([switch]$OpenSite)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$cluster = 'podcamilo'
$namespace = 'podcamilo'

if (-not (Get-Command k3d -ErrorAction SilentlyContinue)) {
    throw 'k3d v5.9.0 is required. Install it first, then run this script again.'
}

$existing = k3d cluster list --no-headers | Select-String -SimpleMatch $cluster
if (-not $existing) {
    k3d cluster create --config "$root/deploy/k3d-config.yaml"
}

kubectl --context "k3d-$cluster" -n $namespace delete deployment/podcamilo-web service/podcamilo-web --ignore-not-found
kubectl --context "k3d-$cluster" apply -f "$root/deploy/redis.yaml"
kubectl --context "k3d-$cluster" -n $namespace rollout status deployment/redis-cache --timeout=120s
kubectl --context "k3d-$cluster" -n $namespace get deployment,replicaset,pods,service

if ($OpenSite) {
    kubectl --context "k3d-$cluster" -n $namespace port-forward service/redis-cache 16379:6379
} else {
    Write-Host 'Ready. Run ./scripts/start.ps1 -OpenSite to expose Redis at localhost:16379.'
}
