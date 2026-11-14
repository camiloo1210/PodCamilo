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

kubectl --context "k3d-$cluster" apply -f "$root/deploy/web.yaml"
kubectl --context "k3d-$cluster" -n $namespace rollout status deployment/$cluster-web --timeout=120s
kubectl --context "k3d-$cluster" -n $namespace get deployment,pods,service

if ($OpenSite) {
    kubectl --context "k3d-$cluster" -n $namespace port-forward service/$cluster-web 18081:80
} else {
    Write-Host 'Ready. Run ./scripts/start.ps1 -OpenSite to open http://localhost:18081.'
}
