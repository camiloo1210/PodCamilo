param(
    [switch]$OpenSite,
    [string]$K3dPath = 'k3d'
)

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$cluster = 'podcamilo'
$context = "k3d-$cluster"

function Invoke-Checked {
    param([string]$Program, [string[]]$Arguments)
    & $Program @Arguments
    if ($LASTEXITCODE -ne 0) {
        throw "$Program terminó con código $LASTEXITCODE."
    }
}

if (-not (Get-Command $K3dPath -ErrorAction SilentlyContinue)) {
    throw 'Instala k3d v5.9.0 o indica el ejecutable con -K3dPath.'
}

$clusters = Invoke-Checked $K3dPath @('cluster', 'list', '-o', 'json') | ConvertFrom-Json
if ($clusters.name -contains $cluster) {
    Invoke-Checked $K3dPath @('cluster', 'start', $cluster)
} else {
    Invoke-Checked $K3dPath @('cluster', 'create', '--config', "$root/deploy/k3d-config.yaml")
}

Invoke-Checked kubectl @('--context', $context, 'apply', '-f', "$root/deploy/redis.yaml")
Invoke-Checked kubectl @('--context', $context, '-n', $cluster, 'rollout', 'status', 'deployment/redis-cache', '--timeout=180s')
Invoke-Checked kubectl @('--context', $context, '-n', $cluster, 'get', 'deployment,replicaset,pods,service')

if ($OpenSite) {
    Invoke-Checked kubectl @('--context', $context, '-n', $cluster, 'port-forward', '--address', '127.0.0.1',
        'service/redis-cache', '16379:6379')
}
