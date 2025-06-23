#Requires AutoHotkey v1
; =================================================================
;     VIRTUAL DESKTOP SWITCH MONITOR (AUTOHOTKEY v1 - FINAL OPTIMIZED)
; =================================================================

; --- CONFIGURATION ---
if not A_IsAdmin
{
   Run *RunAs "%A_ScriptFullPath%"
   ExitApp
}
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%
; This changes how AHK finds windows, allowing us to search for partial titles.
SetTitleMatchMode, 2
DetectHiddenWindows, On

; --- USER CONFIGURATION ---
targetProcess := "firefox.exe"
; We will now also use the window title to filter.
; "Mozilla Firefox" is the most reliable part of the main window's title.
targetWindowTitle := "Mozilla Firefox"
virtualDesktopToolPath := "C:\Users\admin\util\VirtualDesktop.exe"


; --- INITIALIZATION ---
IfNotExist, %virtualDesktopToolPath%
{
    MsgBox, 48, Error, VirtualDesktop.exe not found.
    ExitApp
}
Menu, Tray, Add, Exit Script, ExitHandler
Menu, Tray, Default, Exit Script
Menu, Tray, Icon, shell32.dll, 277

DesktopStates := {}
RunWait, "%virtualDesktopToolPath%" /GetCurrentDesktop,, Hide
lastDesktop := ErrorLevel
TrayTip, Desktop Switcher, Monitoring Started on Desktop #%lastDesktop%.

; --- CORE LOOP ---
Loop
{
    RunWait, "%virtualDesktopToolPath%" /GetCurrentDesktop,, Hide
    currentDesktop := ErrorLevel

    If (currentDesktop != lastDesktop)
    {
        ; --- THE NEW, OPTIMIZED WINGET COMMAND ---
        ; This command now finds windows that match BOTH the process name AND the title.
        WinGet, hwndList, List, %targetWindowTitle%,, ahk_exe %targetProcess%
        
        if (hwndList > 0)
        {
            TrayTip, Desktop Switcher, Switched to #%currentDesktop%. Moving %hwndList% main window(s)...
            
            ; --- The rest of the logic is the same, but now operates on a smaller, more accurate list ---

            ; Step 1: SAVE state.
            if !IsObject(DesktopStates[lastDesktop])
                DesktopStates[lastDesktop] := {}
            
            Loop, %hwndList%
            {
                this_hwnd := hwndList%A_Index%
                WinGet, state, MinMax, ahk_id %this_hwnd%
                DesktopStates[lastDesktop, this_hwnd] := state
            }
            
            ; Step 2: HIDE windows.
            Loop, %hwndList%
            {
                this_hwnd := hwndList%A_Index%
                WinHide, ahk_id %this_hwnd%
            }

            ; Step 3: MOVE windows.
            Loop, %hwndList%
            {
                this_hwnd_hex := hwndList%A_Index%
                this_hwnd_dec := this_hwnd_hex + 0
                Run, "%virtualDesktopToolPath%" /GetDesktop:%currentDesktop% /MoveWindowHandle:%this_hwnd_dec%,, Hide
            }

            ; --- DEBUGGER BLOCK ---
            ; This is our breakpoint, placed AFTER the move commands have been sent.
            ;    MsgBox, 4, Debug - Post-Move, The script has just sent %hwndList% 'MoveWindowHandle' commands.`n`nCheck if the windows have actually moved to desktop #%currentDesktop%.`n`nDo you want to inspect all script variables now?
            ;    IfMsgBox, Yes
            ;    {
            ;        ListVars ; Opens the variable inspector window.
            ;        Pause    ; Pauses the script. Right-click tray icon -> Pause Script to resume.
            ;    }
            ; --- END DEBUGGER BLOCK ---

            ; Step 4: RESTORE state.
            if IsObject(DesktopStates[currentDesktop])
            {
                Loop, %hwndList%
                {
                    this_hwnd := hwndList%A_Index%
                    if (DesktopStates[currentDesktop].HasKey(this_hwnd))
                    {
                        storedState := DesktopStates[currentDesktop, this_hwnd]
                        if (storedState = -1)
                            WinMinimize, ahk_id %this_hwnd%
                        else if (storedState = 1)
                            WinMaximize, ahk_id %this_hwnd%
                        else
                            WinRestore, ahk_id %this_hwnd%
                    }
                }
            }

            ; Step 5: SHOW windows.
            Loop, %hwndList%
            {
                this_hwnd := hwndList%A_Index%
                if (DesktopStates[currentDesktop].HasKey(this_hwnd) && DesktopStates[currentDesktop, this_hwnd] != -1)
                {
                    WinShow, ahk_id %this_hwnd%
                }
            }
        }
        
        lastDesktop := currentDesktop
    }
    Sleep, 250
}
Return

; --- EXIT HANDLER ---
ExitHandler:
    ExitApp
Return