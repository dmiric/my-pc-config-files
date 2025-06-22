; ======================================================================================================================
; --- Admin Rights Check ---
; ======================================================================================================================
if not A_IsAdmin {
   try Run('*RunAs "' A_ScriptFullPath '"')
   ExitApp
}

; ======================================================================================================================
; Chezmoi Auto-Push Helper v6.0 (COM Object Fix) by AutoHotkey v2
; ======================================================================================================================

#SingleInstance force

; ======================================================================================================================
; --- CONFIGURATION ---
; ======================================================================================================================
EnableDebugMessages := true  ; Set to 'true' to see detailed popups, 'false' for silent operation.

GitBranch := "main"
CheckIntervalMS := 4 * 60 * 60 * 1000  ; 4 hours

ChezmoiExePath := "C:\Users\admin\util\chezmoi\chezmoi.exe"
ChezmoiPath := "C:\Users\admin\.local\share\chezmoi"

; ======================================================================================================================
; --- AUTO-EXECUTE SECTION (Runs on script startup) ---
; ======================================================================================================================
if not FileExist(ChezmoiExePath) {
    MsgBox("The configured chezmoi.exe path does not exist:`n" . ChezmoiExePath, "Error", "Icon!")
    ExitApp
}
if not DirExist(ChezmoiPath) {
    MsgBox("The configured chezmoi source path does not exist:`n" . ChezmoiPath, "Error", "Icon!")
    ExitApp
}

WinWait("ahk_class Shell_TrayWnd")

A_TrayMenu.Icon := "shell32.dll", 44
A_TrayMenu.Add("Check Now", (*) => WatchForChanges())
A_TrayMenu.Add("Exit Script", (*) => ExitApp())
SetTimer(WatchForChanges, CheckIntervalMS)
WatchForChanges()

Return

; ======================================================================================================================
; --- CORE LOGIC & HELPER FUNCTIONS ---
; ======================================================================================================================

WatchForChanges() {
    ; =======================================================================================
    ; --- THE DEFINITIVE, FINAL FIX: Using a COM Object ---
    ; AutoHotkey's native Run() command is proving unreliable in this specific environment.
    ; We are now using the Windows Script Host Shell object, which is a much more robust
    ; and predictable way to execute commands and capture their output. This sidesteps
    ; all the previous issues.
    ; =======================================================================================
    try {
        command := 'cmd /c "git status --porcelain 2>&1"'
        shell := ComObject("WScript.Shell")
        shell.CurrentDirectory := ChezmoiPath ; Set the working directory before running
        
        process := shell.Exec(command)

        ; Read the entire output stream from the process
        FullOutput := process.StdOut.ReadAll()

        ; Wait for the process to finish before getting the exit code
        while (process.Status = 0) {
            Sleep(50)
        }
        ExitCode := process.ExitCode

    } catch as e {
        MsgBox("A critical COM error occurred.`n`n" e.Message, "Script Error")
        return
    }

    ; --- DEBUGGING BLOCK ---
    if (EnableDebugMessages) {
        debugMsg := "--- Git Status Debug (WScript.Shell Method) ---`n`n"
        debugMsg .= "Exit Code: " . ExitCode . "`n`n"
        debugMsg .= "Raw Output from Git:`n[`n" . FullOutput . "`n]`n`n"
        debugMsg .= "Trimmed Output is Empty: " . (Trim(FullOutput) = "") . "`n`n"
        
        if (ExitCode != 0) {
            debugMsg .= "ACTION: Script sees an error and will display it."
        } else if (Trim(FullOutput) = "") {
            debugMsg .= "ACTION: Script sees no changes and will do nothing."
        } else {
            debugMsg .= "ACTION: Script sees changes and will proceed to parse them."
        }
        MsgBox(debugMsg, "Debug Information")
    }
    ; --- END DEBUGGING BLOCK ---

    if (ExitCode != 0) {
        ErrorMessage := "Failed to execute 'git status' with Exit Code: " . ExitCode
        ErrorMessage .= "`n`nWorking Directory:`n" . ChezmoiPath
        ErrorMessage .= "`n`n--- Full Output from Git (including errors) ---`n" . (Trim(FullOutput) ? FullOutput : "[No output was produced]")
        MsgBox(ErrorMessage, "Git Execution Error", "Icon!")
        return
    }

    ChangedFilesRaw := FullOutput 
    
    if Trim(ChangedFilesRaw) = ""
        return

    ChangedFilesList := ""
    ChangedFilesArray := []
    for line in StrSplit(ChangedFilesRaw, "`n`r") {
        line := Trim(line)
        if (line != "" && SubStr(line, 1, 2) != "##") {
            filePath := Trim(SubStr(line, 4))
            ChangedFilesList .= filePath . "`n"
            ChangedFilesArray.Push(filePath)
        }
    }

    if Trim(ChangedFilesList) = ""
        return

    if CheckAgainstWhitelist(ChangedFilesArray) {
        AutoCommitFlow(ChangedFilesList)
    } else {
        ManualCommitFlow(ChangedFilesList)
    }
}

ManualCommitFlow(changedFiles) {
    if MsgBox("The following non-whitelisted files have changed:`n`n" . changedFiles . "`nDo you want to commit and push them?", "Confirm Manual Push", "YesNo Icon?") != "Yes"
        return
    
    PushChanges("manual: Sync non-whitelisted files")
}

AutoCommitFlow(changedFiles) {
    PushChanges("auto: Sync whitelisted files")
}

PushChanges(commitMsg) {
    if RunWait('git add .', ChezmoiPath, "Hide") != 0 {
        MsgBox("Error: 'git add' command failed.", "Git Error", "Icon!")
        return
    }

    if RunWait('git commit -m "' . commitMsg . '"', ChezmoiPath, "Hide") != 0 {
        MsgBox("Error: 'git commit' command failed. (Maybe there was nothing to commit?)", "Git Error", "Icon!")
        return
    }

    if RunWait('git pull --rebase', ChezmoiPath, "Hide") != 0 {
        MsgBox("Error: 'git pull --rebase' failed. Please check for merge conflicts manually.", "Git Error", "Icon!")
        return
    }

    if RunWait('git push origin ' . GitBranch, ChezmoiPath, "Hide") != 0 {
        MsgBox("Error: 'git push' command failed. Check credentials and network connection.", "Git Error", "Icon!")
        return
    }

    A_TrayTip := "Success"
    A_TrayTipText := "Changes pushed successfully with message:`n" . commitMsg
    TrayTip()
}

CheckAgainstWhitelist(filesArray) {
    WhitelistFile := ChezmoiPath . "\.autopush"
    if !FileExist(WhitelistFile)
        return false
    WhitelistPatterns := FileRead(WhitelistFile)
    for filePath in filesArray {
        isMatch := false
        for pattern in StrSplit(WhitelistPatterns, "`n`r") {
            pattern := Trim(pattern)
            if (pattern = "" || SubStr(pattern, 1, 1) = "#")
                continue
            pattern := StrReplace(pattern, "\", "\\")
            pattern := StrReplace(pattern, ".", "\.")
            pattern := StrReplace(pattern, "*", ".*")
            pattern := StrReplace(pattern, "?", ".")
            if RegExMatch(filePath, "i)^" . pattern . "$") {
                isMatch := true
                break
            }
        }
        if !isMatch
            return false
    }
    return true
}