#Requires AutoHotkey v2.0
#SingleInstance Force

Debug := true
LogFile := A_ScriptDir "\WinE.log"
Log(msg) {
    global Debug
    if Debug
        FileAppend(msg "`n", LogFile)
}

#e::Explorer_NewTab()
!e::Explorer_Focus()

; Titles to ignore (Control Panel, system pages, etc.)
IgnoreTitles := [
    "Programs and Features",
    "Control Panel",
    "Network and Sharing Center",
    "Devices and Printers",
    "System",
    "Power Options",
    "Sound",
    "User Accounts",
    "Troubleshooting",
    "Windows Defender Firewall",
    "Credential Manager",
    "File History",
    "Indexing Options"
]

IsIgnoredExplorer(winObj) {
    global IgnoreTitles
    
    hwnd := winObj.HWND
    title := WinGetTitle("ahk_id " hwnd)

    Log("IsIgnoredExplorer: HWND " hwnd ", Title: " title)

    for ignore in IgnoreTitles {
        if InStr(title, ignore) {
            Log("IsIgnoredExplorer: Ignored title match: " ignore)
            return true
        }
    }
    return false
}

GetExplorerWindow() {
    Windows := ComObject("Shell.Application").Windows
    Log("GetExplorerWindow: Enumerating windows...")

    for win in Windows {

        hwnd := win.HWND
        title := WinGetTitle("ahk_id " hwnd)

        try {
            full := win.FullName
        } catch as e {
            full := "[Exception]"
        }

        Log("GetExplorerWindow: HWND " hwnd ", FullName: " full ", Title: " title)

        if InStr(full, "explorer.exe") {
            if !IsIgnoredExplorer(win) {
                Log("GetExplorerWindow: Selected HWND " hwnd)
                return hwnd
            }
        }
    }

    Log("GetExplorerWindow: No suitable window found.")
    return 0
}

RestoreAndActivateExplorer(ExplorerHwnd) {
    if !ExplorerHwnd
        return
    if WinGetMinMax(ExplorerHwnd) = -1
        WinRestore(ExplorerHwnd)
    WinActivate(ExplorerHwnd)
    DllCall("SetForegroundWindow", "ptr", ExplorerHwnd)
    DllCall("ShowWindow", "ptr", ExplorerHwnd, "int", 9) ; SW_RESTORE
}

Explorer_Focus() {
    ExplorerHwnd := GetExplorerWindow()
    if !ExplorerHwnd {
        Explorer_NewWindow()
        return
    }
    RestoreAndActivateExplorer(ExplorerHwnd)
}

Explorer_NewTab() {
    ExplorerHwnd := GetExplorerWindow()
    if !ExplorerHwnd {
        Explorer_NewWindow()
        return
    }

    Windows := ComObject("Shell.Application").Windows
    Count := Windows.Count()

    RestoreAndActivateExplorer(ExplorerHwnd)
    SendMessage(0x0111, 0xA21B, 0, "ShellTabWindowClass1", ExplorerHwnd)

    timeout := A_TickCount + 5000
    while Windows.Count() = Count {
        Sleep 10
        if A_TickCount > timeout {
            Explorer_NewWindow()
            return
        }
    }
}

Explorer_NewWindow() {
    Run("explorer.exe")
    WinWaitActive("ahk_class CabinetWClass")
    WinActivate("ahk_class CabinetWClass")
    DllCall("SetForegroundWindow", "ptr", WinExist("A"))
}
