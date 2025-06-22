param(
    [Parameter(Mandatory=$true)]
    [string]$tname
)

$pidValue = $env:ConEmuServerPID
$envFilePath = "C:\Users\admin\Documents\Cline\MCP\open-terms.env"
$envDir = Split-Path $envFilePath

# Ensure the directory exists
if (-not (Test-Path $envDir)) {
    New-Item -ItemType Directory -Force -Path $envDir | Out-Null
}

# Read existing content as a single string
$fileContentRaw = Get-Content -Path $envFilePath -Raw -ErrorAction SilentlyContinue

# Initialize a hash table to store environment variables
$envVars = @{}

# Parse existing content into the hash table
if (-not [string]::IsNullOrEmpty($fileContentRaw)) {
    $pairs = $fileContentRaw.Split(';', [System.StringSplitOptions]::RemoveEmptyEntries)
    foreach ($pair in $pairs) {
        $parts = $pair.Split('=', 2) # Split only on the first '='
        if ($parts.Length -eq 2) {
            $key = $parts[0].Trim()
            $value = $parts[1].Trim()
            $envVars[$key] = $value
        }
    }
}

# Update or add the new PID for the given tname
$envVars[$tname] = $pidValue

# Reconstruct the semicolon-separated string
$newContentParts = @()
foreach ($key in $envVars.Keys) {
    $newContentParts += "$($key)=$($envVars[$key])"
}
$newFileContent = $newContentParts -join ";"

# Write the updated content back to the file
Set-Content -Path $envFilePath -Value $newFileContent

Write-Host "Updated $tname with PID $pidValue in $envFilePath"
