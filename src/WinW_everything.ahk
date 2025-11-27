#Requires Autohotkey v2.0

; Win+W - focus or open Everything
#w::
; Alt+W - focus or open Everything
!w::
{
    if WinExist("ahk_exe Everything.exe")  ; Check if it's already running
    {
        WinActivate  ; Bring it to the front
    }
    else {
        Run("C:\Program Files\Everything\Everything.exe")
    }
}
