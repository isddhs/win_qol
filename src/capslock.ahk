#Requires AutoHotkey v2.0
#SingleInstance Force

CapsLock:: {
    Send("{LWin Down}{Tab}{LWin Up}")
    return
}