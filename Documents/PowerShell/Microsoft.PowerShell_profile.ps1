Import-Module -Name Microsoft.WinGet.CommandNotFound
# f45873b3-b655-43a6-b217-97c00aa0db58

# Load Cmder profile for all PowerShell sessions
Import-Module 'C:\Users\admin\cmder\vendor\profile.ps1'

$env:PATH = "$env:USERPROFILE\util;" + $env:PATH

# Custom function for managing dotfiles with a bare git repo.
# Includes special handling for 'add' and 'status' commands.
function config {
    [CmdletBinding()]
    param(
        [Parameter(ValueFromRemainingArguments=$true)]
        [string[]]$Arguments
    )

    Write-Verbose "Config function initiated. Captured arguments: $Arguments"

    $baseGitArgs = "--git-dir", "$HOME/.dotfiles", "--work-tree", "$HOME"

    # --- SPECIAL: 'add' command ---
    if ($Arguments.Count -gt 0 -and $Arguments[0].ToLower() -eq 'add') {
        # ... (The existing 'add' logic remains unchanged)
        Write-Host "==> Detected 'add' command. Special handling activated." -ForegroundColor White
        Write-Verbose "About to run: git @baseGitArgs $Arguments"
        git @baseGitArgs $Arguments; $exitCode = $LASTEXITCODE
        Write-Verbose "Git command finished with exit code: $exitCode"
        if ($exitCode -ne 0) { Write-Warning "The 'git add' command failed. Aborting directory logging."; return }
        Write-Host "==> Checking paths to log directories..." -ForegroundColor White
        $logFilePath = "$HOME/.configdirectories"; $newDirsLogged = $false
        if (Test-Path $logFilePath) { $loggedDirs = Get-Content $logFilePath } else { $loggedDirs = @() }
        $pathsToAdd = $Arguments | Select-Object -Skip 1
        foreach ($path in $pathsToAdd) {
            $resolvedItems = try { Resolve-Path -Path $path -ErrorAction SilentlyContinue } catch {}
            if ($null -ne $resolvedItems) {
                foreach ($item in $resolvedItems) {
                    if (Test-Path -LiteralPath $item.Path -PathType Container) {
                        $relativePath = [System.IO.Path]::GetRelativePath($HOME, $item.Path); if ($relativePath -ne ".") { $relativePath = ".\" + $relativePath }
                        if ($relativePath -notin $loggedDirs) {
                            Add-Content -Path $logFilePath -Value $relativePath; Write-Host "--> Logged new directory: $relativePath" -ForegroundColor Cyan; $loggedDirs += $relativePath; $newDirsLogged = $true
                        } else { Write-Host "--> Skipping '$relativePath' because it is already logged." -ForegroundColor Yellow }
                    } else { Write-Host "--> Skipping '$($item.Path)' because it is a file, not a directory." -ForegroundColor Yellow }
                }
            } else { Write-Warning "Could not find or resolve the path '$path'. Skipping." }
        }
        if ($newDirsLogged) { Write-Host "==> Staging the updated '.configdirectories' file..." -ForegroundColor Green; git @baseGitArgs add $logFilePath
        } else { Write-Host "==> No new directories were logged. Nothing to update." -ForegroundColor White }
    
    # --- *** NEW: 'status' command *** ---
    } elseif ($Arguments.Count -gt 0 -and $Arguments[0].ToLower() -eq 'status') {
        
        Write-Host "==> Intercepted 'status'. Auto-staging all tracked files..." -ForegroundColor White

        # Step 1: Add new files from managed directories
        $logFilePath = "$HOME/.configdirectories"
        if (Test-Path $logFilePath) {
            $managedDirs = Get-Content $logFilePath
            Write-Verbose "Found $($managedDirs.Count) managed directories to check."
            foreach ($dir in $managedDirs) {
                $fullDirPath = Join-Path -Path $HOME -ChildPath $dir
                if (Test-Path $fullDirPath) {
                    Write-Host "--> Staging new files in '$dir'" -ForegroundColor Cyan
                    git @baseGitArgs add $fullDirPath
                } else {
                    Write-Warning "Directory '$dir' from log file not found. Skipping."
                }
            }
        }

        # Step 2: Stage all MODIFIED and DELETED tracked files everywhere
        Write-Host "--> Staging all modified/deleted tracked files..." -ForegroundColor Cyan
        git @baseGitArgs add --update

        # Step 3: Display the final, clean status
        Write-Host "==> Final Repository Status:" -ForegroundColor Green
        # We pass the original arguments ($Arguments) so that flags like '--short' are respected.
        git @baseGitArgs @Arguments

    # --- DEFAULT: All other commands ---
    } else {
        Write-Verbose "Running standard command: git @baseGitArgs $Arguments"
        git @baseGitArgs $Arguments
    }
}