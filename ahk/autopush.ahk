#Requires AutoHotkey v2.0
#SingleInstance Force ; Ensures only one instance of the script runs

; --- Configuration ---
syncInterval := 4 * 60 * 60 * 1000 ; 4 hours in milliseconds
userProfilePath := 'C:\Users\admin'

; --- Main Script ---
SyncDotfiles()
SetTimer(SyncDotfiles, syncInterval)

SyncDotfiles() {
    ; Use a literal, single-quoted string. This is the simplest and most
    ; reliable way to define the command.
    ; The Run command correctly executes the command string.
    Run('C:\Program Files\PowerShell\7\pwsh.exe -File "' . A_ScriptDir . '\autopush.ps1"', , "Hide")

    ; Optional: Uncomment for debugging
    ;FileAppend(A_Now . " - Sync attempted.`n", A_ScriptDir . "\sync_log.txt")
}
