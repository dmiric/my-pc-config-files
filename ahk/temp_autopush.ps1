$env:HOME = "C:\Users\Admin"
. "C:\Users\admin\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"
config status
config commit -m "auto commit"
config push
Start-Sleep -Seconds 60
