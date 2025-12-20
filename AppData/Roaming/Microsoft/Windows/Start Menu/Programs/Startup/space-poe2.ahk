; Only work if Path of Exile 2 is the active window
#IfWinActive ahk_exe PathOfExileSteam.exe

    $*Space::
        Send {Blind}{Space}
        KeyWait, Space
    return

#IfWinActive