if (-not (Test-Path Env:AZP_URL)) {
  Write-Error "error: missing AZP_URL environment variable"
  exit 1
}

if (-not (Test-Path Env:AZP_TOKEN_FILE)) {
  if (-not (Test-Path Env:AZP_TOKEN)) {
    Write-Error "error: missing AZP_TOKEN environment variable"
    exit 1
  }

  $Env:AZP_TOKEN_FILE = "\azp\.token"
  $Env:AZP_TOKEN | Out-File -FilePath $Env:AZP_TOKEN_FILE
}

# Set PureComponents license if present
if ((Test-Path Env:PURE_COMPONENTS_LICENSE)) {
  Write-Host "info: PURE_COMPONENTS_LICENSE environmental variable found. Activating license..." -ForegroundColor Cyan

  $Env:PURE_COMPONENTS_LICENSE | Out-File -FilePath "C:\Users\ContainerAdministrator\Documents\PureComponents.EntrySet.2011-01.lic"

  Write-Host "info: PURE_COMPONENTS_LICENSE activated." -ForegroundColor Green
}
else {
  Write-Warning "The PURE_COMPONENTS_LICENSE environmental variable was not found."
}

Set-DnsClientServerAddress -InterfaceIndex 4 -ServerAddresses ("8.8.8.8","8.8.4.4")

# Set AdvancedInstaller license if present
if ((Test-Path Env:ADVANCED_INSTALLER_LICENSE)) {
  Write-Host "info: ADVANCED_INSTALLER_LICENCE environmental variable found. Activating license..." -ForegroundColor Cyan

  & $Env:AdvancedInstaller /register $Env:ADVANCED_INSTALLER_LICENSE

  if ($LastExitCode -ne 0) {
    Write-Error("Activating license failed. Last exit code was not equal to 0. Last exit code {0}" -f $LastExitCode)
    exit 1
  }

  Write-Host "info: ADVANCED_INSTALLER_LICENCE activated." -ForegroundColor Green
}
else {
  Write-Warning "The ADVANCED_INSTALLER_LICENCE environmental variable was not found."
}

Remove-Item Env:AZP_TOKEN

if ((Test-Path Env:AZP_WORK) -and -not (Test-Path $Env:AZP_WORK)) {
  New-Item $Env:AZP_WORK -ItemType directory | Out-Null
}

New-Item "\azp\agent" -ItemType directory | Out-Null
Set-Location azp

# Let the agent ignore the token env variables
$Env:VSO_AGENT_IGNORE = "AZP_TOKEN,AZP_TOKEN_FILE,PURE_COMPONENTS_LICENCE,ADVANCED_INSTALLER_LICENCE"

Set-Location agent

Write-Host "1. Determining matching Azure Pipelines agent..." -ForegroundColor Cyan

[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072

$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(":$(Get-Content ${Env:AZP_TOKEN_FILE})"))
$package = Invoke-RestMethod -Headers @{Authorization=("Basic $base64AuthInfo")} "$(${Env:AZP_URL})/_apis/distributedtask/packages/agent?platform=win-x64&`$top=1"
$packageUrl = $package[0].Value.downloadUrl

Write-Host $packageUrl

Write-Host "2. Downloading and installing Azure Pipelines agent..." -ForegroundColor Cyan

$wc = New-Object System.Net.WebClient
$wc.DownloadFile($packageUrl, "$(Get-Location)\agent.zip")

Expand-Archive -Path "agent.zip" -DestinationPath "\azp\agent"

try
{
  Write-Host "3. Configuring Azure Pipelines agent..." -ForegroundColor Cyan

  .\config.cmd --unattended `
    --agent "$(if (Test-Path Env:AZP_AGENT_NAME) { ${Env:AZP_AGENT_NAME} } else { ${Env:computername} })" `
    --url "$(${Env:AZP_URL})" `
    --auth PAT `
    --sslskipcertvalidation `
    --token "$(Get-Content ${Env:AZP_TOKEN_FILE})" `
    --pool "$(if (Test-Path Env:AZP_POOL) { ${Env:AZP_POOL} } else { 'Default' })" `
    --work "$(if (Test-Path Env:AZP_WORK) { ${Env:AZP_WORK} } else { '_work' })" `
    --replace

  Write-Host "4. Running Azure Pipelines agent..." -ForegroundColor Cyan

  .\run.cmd
}
finally
{
  Write-Host "Cleanup. Removing Azure Pipelines agent..." -ForegroundColor Cyan

  .\config.cmd remove --unattended `
    --auth PAT `
    --token "$(Get-Content ${Env:AZP_TOKEN_FILE})"
}