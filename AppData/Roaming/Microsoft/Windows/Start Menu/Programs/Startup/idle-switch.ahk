#Requires AutoHotkey v2.0

; --- Configuration ---
; The time in seconds the script waits for inactivity. (10 minutes = 600 seconds)
IdleTimeSeconds := 65
; How often the script checks the idle time (in milliseconds). (30 seconds = 30000ms)
CheckIntervalMs := 60000 
; The TitleMatchMode 2 setting means the script only needs to find "Firefox" somewhere in the window title.
SetTitleMatchMode 2

; The script is persistent so it doesn't immediately exit after startup

; The script starts by setting a recurring timer
SetTimer(SwitchToFirefox, CheckIntervalMs)
return

; --- Main Function ---
SwitchToFirefox()
{
    ; A_TimeIdlePhysical returns the time, in milliseconds, since the last
    ; physical input (keyboard, mouse).

    CurrentIdleTime := A_TimeIdlePhysical / 1000 ; Convert ms to seconds

    ; Check if the current idle time is greater than or equal to the target time
    if (CurrentIdleTime >= IdleTimeSeconds)
    {
        ; Use WinExist() to check if a Firefox window is open
        WinTitle := "Mozilla Firefox"

        if WinExist(WinTitle)
        {
            ; Activate the first found Firefox window
            WinActivate(WinTitle)

            ; Optional: Play a subtle sound or notification on activation
            ; SoundBeep(1000, 150)
        }
    }
}