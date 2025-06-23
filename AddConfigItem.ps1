# AddConfigItem.ps1
# This script is designed to be called from the Windows Context Menu.
# It loads your PowerShell profile and then executes the 'config add' function.

$userProfilePath = "$env:USERPROFILE\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
$logFile = "$HOME\AddConfigItem_log.txt" # Log file for silent operation

function Write-ScriptLog {
    param (
        [string]$Message,
        [string]$Level = "INFO"
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    "$timestamp [$Level] $Message" | Add-Content -Path $logFile
}

# Clear log file if it gets too big (optional, for debugging only)
# if ((Test-Path $logFile) -and ((Get-Item $logFile).Length -gt 1MB)) { Clear-Content $logFile }


Write-ScriptLog -Message "Script started for path: $($args[0])"

# Check if the profile exists and source it
if (Test-Path $userProfilePath) {
    . $userProfilePath # The dot-sourcing operator loads the script into the current scope.
    Write-ScriptLog -Message "Profile loaded: $userProfilePath"
} else {
    Write-ScriptLog -Message "ERROR: PowerShell profile not found at '$userProfilePath'. The 'config' function might not be available." -Level "ERROR"
    exit 1
}

# Check if an argument (the file/folder path) was passed
if ($args.Count -gt 0) {
    $itemPath = $args[0]
    Write-ScriptLog -Message "Attempting to add '$itemPath' to config..."
    
    # Call your config function
    try {
        config add $itemPath
        Write-ScriptLog -Message "Config add operation for '$itemPath' completed."
    } catch {
        Write-ScriptLog -Message "ERROR: Config add failed for '$itemPath'. Error: $_" -Level "ERROR"
    }

} else {
    Write-ScriptLog -Message "WARNING: No file or folder path was provided to the AddConfigItem script." -Level "WARN"
}

Write-ScriptLog -Message "Script finished."