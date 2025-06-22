# Step 2: Ensure Clean Chrome Process
$port = 9222
Write-Host "Raw netstat output for port ${port}:"
netstat -ano | Select-String ":${port}" | Write-Host # Add this line to print raw output
$pid_ask = (netstat -ano | Select-String ":${port}" | ForEach-Object { ($_ -split '\s+')[-1] } | Select-Object -Unique)
if ($pid_ask) {
    return;
    # foreach ($pid_ask_single in $pid_ask) {
    #    Write-Host "Process listening on port $port found with PID: $pid_ask_single. Terminating..."
    #    taskkill /PID $pid_ask_single /F
    # }
} else {
    Write-Host "No process found listening on port $port."
}

# Clear annoying Chrome "Restore Pages" nag
$preferencesPath = "C:\Users\admin\Documents\Cline\MCP\temp_chrome_profile\Default\Preferences"
if (Test-Path $preferencesPath) {
    Write-Host "Modifying Chrome Preferences file to clear 'Restore Pages' nag..."
    (Get-Content $preferencesPath) -replace '"exit_type":"Crashed"', '"exit_type":"Normal"' | Set-Content $preferencesPath
} else {
    Write-Host "Chrome Preferences file not found at $preferencesPath. Skipping modification."
}

# Step 3: Open AI Studio (Launch Chrome)
Write-Host "Launching Chrome with remote debugging enabled on port $port..."
Start-Process -FilePath "C:\Program Files\Google\Chrome\Application\chrome.exe" -ArgumentList "--remote-debugging-port=$port", "--user-data-dir=C:\Users\admin\Documents\Cline\MCP\temp_chrome_profile"
