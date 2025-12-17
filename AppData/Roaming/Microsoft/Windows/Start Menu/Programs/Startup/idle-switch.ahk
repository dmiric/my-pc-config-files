#Requires AutoHotkey v1.1
#SingleInstance, Force
SetWorkingDir, %A_ScriptDir%

; --- CONFIGURATION ---
; The time in milliseconds the script waits for inactivity. (10 minutes = 600000 ms)
IdleTimeMs = 600000
; How often the script checks the idle time (in milliseconds). (30 seconds = 30000ms)
CheckIntervalMs = 60000 
; The TitleMatchMode 2 setting means the script only needs to find "Mozilla Firefox"
; somewhere in the window title.
SetTitleMatchMode, 2

; --- INITIALIZATION ---
; #Persistent is the correct directive for v1 and is needed to keep the script running.
#Persistent
; Set up the recurring timer that calls the SwitchToFirefox function.
SetTimer, SwitchToFirefox, %CheckIntervalMs%
Return

; --- MAIN FUNCTION ---
SwitchToFirefox:
    {
        ; A_TimeIdle returns the time, in milliseconds, since the last physical input.
        ; NOTE: A_TimeIdlePhysical in v2 is just A_TimeIdle in v1.

        If (A_TimeIdle >= IdleTimeMs)
        {
            ; Target window criteria. We use the reliable combination of
            ; title and ahk_exe to ensure we find a main Firefox window.
            WinTitle = Mozilla Firefox
            WinExe = ahk_exe firefox.exe

            ; Check if a matching Firefox window exists.
            IfWinExist, %WinTitle%,, %WinExe%
            {
                ; Activate the first found Firefox window.
                WinActivate, %WinTitle%,, %WinExe%

                ; Optional: Play a subtle sound or notification on activation
                ; SoundBeep, 1000, 150
            }
        }
        Return
    }