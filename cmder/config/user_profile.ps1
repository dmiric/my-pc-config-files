# Use this file to run your own startup commands

## Prompt Customization
<#
.SYNTAX
    <PrePrompt><CMDER DEFAULT>
    λ <PostPrompt> <repl input>
.EXAMPLE
    <PrePrompt>N:\Documents\src\cmder [master]
    λ <PostPrompt> |
#>

[ScriptBlock]$PrePrompt = {

}

# Replace the cmder prompt entirely with this.
# [ScriptBlock]$CmderPrompt = {}

[ScriptBlock]$PostPrompt = {

}

## <Continue to add your own>

# # Delete default powershell aliases that conflict with bash commands
# if (get-command git) {
#     del -force alias:cat
#     del -force alias:clear
#     del -force alias:cp
#     del -force alias:diff
#     del -force alias:echo
#     del -force alias:kill
#     del -force alias:ls
#     del -force alias:mv
#     del -force alias:ps
#     del -force alias:pwd
#     del -force alias:rm
#     del -force alias:sleep
#     del -force alias:tee
# }

# init zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

# set arrow up down autocomplete in shell
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward

# My custom alias for listing only files
function l {
    Get-ChildItem -File -Name
}

# My custom alias for listing all files and directories (including hidden)
function la {
    Get-ChildItem -Force -Name
}

#
# Advanced PowerShell tab-completion for 'make' targets.
# This version is context-aware and handles complex commands with variables and chaining.
#
Register-ArgumentCompleter -CommandName 'make', 'make.exe' -ScriptBlock {
    param($wordToComplete, $commandAst, $cursorPosition)

    # --- NEW: Context-Aware Logic ---
    # We only want to provide completions for the first argument after the 'make' command.
    # We check if there's more than one argument before the cursor. If so, we're not completing the target anymore.
    # $commandAst.CommandElements is an array of all parts of the command line.
    # The first element is 'make' itself. We only want to complete the second element.
    $elementsBeforeCursor = $commandAst.CommandElements | Where-Object { $_.Extent.EndOffset -lt $cursorPosition }
    
    # If the count is greater than 1, it means we are past the first argument (the target).
    # In this case, we should not provide any completions, so we simply exit.
    if ($elementsBeforeCursor.Count -gt 1) {
        return
    }
    # --- End of new logic ---

    # Find the Makefile in the current directory, checking for both 'Makefile' and 'makefile'
    $makefile = Get-ChildItem -Path . -Filter 'Makefile' -ErrorAction SilentlyContinue | Select-Object -First 1
    if (-not $makefile) {
        $makefile = Get-ChildItem -Path . -Filter 'makefile' -ErrorAction SilentlyContinue | Select-Object -First 1
    }

    # If no Makefile is found, we can't do anything.
    if (-not $makefile) {
        return
    }

    # Use a regular expression to find all lines that define a documented target.
    # This matches your Makefile's help format perfectly: `target: ## Help text`
    $targets = (Get-Content $makefile.FullName) | ForEach-Object {
        if ($_ -match '^([a-zA-Z0-9_-]+):.*##') {
            $matches[1]
        }
    }

    # Filter the list of targets based on what the user has already typed.
    $targets | Where-Object { $_ -like "$wordToComplete*" } | ForEach-Object {
        # Create a rich completion result for a better user experience.
        [System.Management.Automation.CompletionResult]::new($_, $_, 'ParameterValue', $_)
    }
}