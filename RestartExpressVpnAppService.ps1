$serviceName = "ExpressVPN App Service"

$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($null -eq $service) {
    Write-Error "Service '$serviceName' not found."
    exit 1
}

if ($service.Status -ne "Stopped") {
    Stop-Service -Name $serviceName -Force
    Start-Sleep -Seconds 3
}

Start-Service -Name $serviceName
Write-Output "Service '$serviceName' restarted successfully."
