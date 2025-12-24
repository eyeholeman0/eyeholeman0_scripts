$serviceName = "ExpressVPN App Service"

$service = Get-Service -Name $serviceName -ErrorAction SilentlyContinue

if ($null -eq $service) {
    Write-Error "Service '$serviceName' not found."
    exit 1
}

if ($service.Status -ne "Stopped") {
    Stop-Service -Name $serviceName -Force
    Start-Sleep -Seconds 1
}

Start-Service -Name $serviceName
Write-Output "'$serviceName' restarted successfully."

Start-Sleep -Seconds 1
Start-Process -FilePath "C:\Program Files (x86)\ExpressVPN\expressvpn-ui\ExpressVPN.exe"