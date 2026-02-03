# WireGuard Client Config Generator for Windows
# Save as: New-WireGuardClient.ps1

param(
    [string]$ClientName = "wg-FZN",
    [int]$Count = 50,
    [string]$ServerConfigPath = "wg-server.conf",
    [string]$ServerPublicKey = "P0PB5z34D6xxgSDRy8esu/XK42fbJdpPM7pSqe1brCU=",
    [string]$ServerEndpoint = "80.210.44.205:51820",
    [string]$OutputDir = "batch_created"
)

# Validate count
if ($Count -lt 1) {
    Write-Error "Count must be at least 1"
    exit 1
}

# Create output directory if it doesn't exist
New-Item -ItemType Directory -Force -Path $OutputDir | Out-Null

# Read current server config to find next available IP
$serverConfig = Get-Content $ServerConfigPath -Raw
$usedIPs = [regex]::Matches($serverConfig, '10\.10\.10\.(\d+)/32') | 
           ForEach-Object { [int]$_.Groups[1].Value }

$nextIP = 2
if ($usedIPs) {
    $nextIP = ($usedIPs | Measure-Object -Maximum).Maximum + 1
}

# Check if we have enough IPs available
if (($nextIP + $Count - 1) -gt 254) {
    Write-Error "Not enough IPs available! Requested: $Count, Available: $(255 - $nextIP)"
    exit 1
}

# Array to store all peer blocks before writing to server config
$allPeerBlocks = @()

# Array to store client summaries
$clientSummaries = @()

# Create clients
for ($i = 0; $i -lt $Count; $i++) {
    $currentIP = $nextIP + $i
    $clientIP = "10.10.10.$currentIP"
    
    # Generate unique client name for batch creation
    if ($Count -gt 1) {
        $currentClientName = "$ClientName-$($i + 1)"
    } else {
        $currentClientName = $ClientName
    }
    
    # Generate client keys
    $privateKey = & wg genkey
    $publicKey = $privateKey | & wg pubkey
    
    # Create client config
    $clientConfig = @"
[Interface]
PrivateKey = $privateKey
Address = $clientIP/32
DNS = 192.168.100.1

[Peer]
PublicKey = $ServerPublicKey
AllowedIPs = 0.0.0.0/0, ::/0
Endpoint = $ServerEndpoint
PersistentKeepalive = 25
"@
    
    # Save client config
    $clientConfigPath = Join-Path $OutputDir "$currentClientName.conf"
    $clientConfig | Out-File -FilePath $clientConfigPath -Encoding ASCII -NoNewline
    # Add final newline
    "`n" | Out-File -FilePath $clientConfigPath -Encoding ASCII -Append -NoNewline
    
    # Create peer block for server config
    $peerBlock = @"

[Peer]
PublicKey = $publicKey
AllowedIPs = $clientIP/32
"@
    
    $allPeerBlocks += $peerBlock
    
    # Store summary
    $clientSummaries += [PSCustomObject]@{
        Name = $currentClientName
        IP = "$clientIP/32"
        PublicKey = $publicKey
        ConfigPath = $clientConfigPath
    }
    
    Write-Host "[$($i + 1)/$Count] Created: $currentClientName ($clientIP)" -ForegroundColor Cyan
}

# Add all peer blocks to server config at once
$allPeerBlocks -join "" | Add-Content -Path $ServerConfigPath

# Display summary
Write-Host "`n========================================" -ForegroundColor Green
Write-Host "Batch Creation Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host "Total clients created: $Count"
Write-Host "IP range used: 10.10.10.$nextIP - 10.10.10.$($nextIP + $Count - 1)"
Write-Host "`nClient Details:" -ForegroundColor Yellow

$clientSummaries | Format-Table -AutoSize

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "1. Restart WireGuard service to apply changes:"
Write-Host "   net stop WireGuardTunnel`$wg0 && net start WireGuardTunnel`$wg0" -ForegroundColor White
Write-Host "`n2. Distribute config files from: $OutputDir" -ForegroundColor White

# Display QR code option
if ($Count -eq 1) {
    Write-Host "`n3. Generate QR code for mobile client:" -ForegroundColor White
    Write-Host "   qrencode -t ansiutf8 < `"$($clientSummaries[0].ConfigPath)`"" -ForegroundColor White
} else {
    Write-Host "`n3. Generate QR codes for mobile clients:" -ForegroundColor White
    Write-Host "   Get-ChildItem `"$OutputDir\$ClientName-*.conf`" | ForEach-Object { qrencode -t ansiutf8 < `$_.FullName }" -ForegroundColor White
}

# Optional: Export summary to CSV
$summaryPath = Join-Path $OutputDir "batch-summary-$(Get-Date -Format 'yyyyMMdd-HHmmss').csv"
$clientSummaries | Export-Csv -Path $summaryPath -NoTypeInformation
Write-Host "`nSummary exported to: $summaryPath" -ForegroundColor Gray