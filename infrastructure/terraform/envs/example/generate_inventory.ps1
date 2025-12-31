# generate_inventory.ps1
# PowerShell script to read `terraform output -json` and write Ansible inventory
param()
$ErrorActionPreference = 'Stop'
$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = (Resolve-Path "$here\..\..").Path
$outputFile = Join-Path $repoRoot 'infrastructure\ansible\inventory\hosts'

Set-Location $here
$json = terraform output -json | ConvertFrom-Json
# Prefer npm_ip, otherwise any property that ends with _ip or ip
$ip = $null
if ($json.PSObject.Properties.Name -contains 'npm_ip') {
  $ip = $json.npm_ip
} else {
  foreach ($name in $json.PSObject.Properties.Name) {
    if ($name -match '(_ip$|ip$)') {
      $ip = $json.$name
      break
    }
  }
}

if (-not $ip) {
  Write-Error "No ip-like terraform outputs found. Available outputs: $($json.PSObject.Properties.Name -join ', ')"
  exit 1
}

$dir = Split-Path $outputFile -Parent
if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir | Out-Null }
"[nginx-proxy]" | Out-File -FilePath $outputFile -Encoding utf8
"npm ansible_host=$ip ansible_user=infrauser" | Out-File -FilePath $outputFile -Append -Encoding utf8
Write-Host "Wrote inventory to $outputFile"