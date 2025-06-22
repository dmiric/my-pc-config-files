Import-Module -Name Microsoft.WinGet.CommandNotFound
# f45873b3-b655-43a6-b217-97c00aa0db58

# Load Cmder profile for all PowerShell sessions
Import-Module 'C:\Users\admin\cmder\vendor\profile.ps1'

$env:PATH = "$env:USERPROFILE\util;" + $env:PATH

# Alias for managing dotfiles with a bare git repo
function config {
   git --git-dir="$HOME/.dotfiles" --work-tree="$HOME" $args
}