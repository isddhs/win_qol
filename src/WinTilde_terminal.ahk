#Requires AutoHotkey v2.0

; Win+` opens a new Windows Terminal tab
#`:: {
    Run "wt.exe -w 0 new-tab"
}

; Alt+` focuses or opens Windows Terminal
!`::
{
    try {
        if WinExist("ahk_exe WindowsTerminal.exe") {
            WinActivate
        } else {
            Run "wt.exe -w 0 new-tab"
        }
    }
}