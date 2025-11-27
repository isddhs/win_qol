param(
    [string]$Option
)

function Show-Menu {
    Clear-Host
    Write-Host "====================================="
    Write-Host "          Windows 11 QoL"
    Write-Host "====================================="
    Write-Host ""
    Write-Host " 1) Apply ALL Tweaks"
    Write-Host " 2) Apply UI Tweaks Only"
    Write-Host " 3) Apply Privacy Tweaks Only"
    Write-Host " 4) Apply Performance Tweaks Only"
    Write-Host " 5) Restore Windows Defaults"
    Write-Host " 0) Exit"
    Write-Host ""
}

function Read-Choice {
    Param([string]$prompt)
    Write-Host -NoNewline $prompt
    return Read-Host
}

function Apply-UI-Tweaks {
    Write-Host "`n--- Applying UI Tweaks ---"
    Start-Sleep -Milliseconds 300

    $adv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

    Set-ItemProperty -Path $adv -Name "SnapAssist" -Value 0
    Write-Host "Disabled Snap Assist Suggestions."

    Set-ItemProperty -Path $adv -Name "TaskbarDa" -Value 0
    Write-Host "Disabled Widgets."

    Set-ItemProperty -Path $adv -Name "TaskbarMn" -Value 0
    Write-Host "Disabled Chat from Taskbar."

    $clsid = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
    if (-not (Test-Path $clsid)) { New-Item -Path $clsid -Force | Out-Null }
    Set-ItemProperty -Path $clsid -Name "(default)" -Value "" -Force
    Write-Host "Enabled classic (advanced) context menu."

    Set-ItemProperty -Path $adv -Name "HideFileExt" -Value 0
    Write-Host "Set to show file extensions."

    Set-ItemProperty -Path $adv -Name "Hidden" -Value 1
    Write-Host "Set to show hidden files and folders."

    Set-ItemProperty -Path $adv -Name "LaunchTo" -Value 1
    Write-Host "Set File Explorer to open 'This PC'."

    Set-ItemProperty -Path $adv -Name "TaskbarSi" -Value 0
    Write-Host "Set taskbar to small size."

    Write-Host "`nUI Tweaks applied."
}

function Apply-Privacy-Tweaks {
    Write-Host "`n--- Applying Privacy Tweaks ---"
    Start-Sleep -Milliseconds 300

    # Location
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
    Write-Host "Disabled Location Tracking."

    # Cortana / Search
    $searchPolicyHKLM = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
    if (-not (Test-Path $searchPolicyHKLM)) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search" -Force | Out-Null
        Write-Host "Created Windows Search policy key."
    }
    Set-ItemProperty -Path $searchPolicyHKLM -Name "AllowCortana" -Value 0
    Write-Host "Disabled Cortana."

    # Telemetry
    $tele = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
    if (-not (Test-Path $tele)) { New-Item -Path $tele -Force | Out-Null }
    New-ItemProperty -Path $tele -Name "AllowTelemetry" -PropertyType DWORD -Value 1 -Force | Out-Null
    Write-Host "Limited telemetry to Basic."

    # Tailored experiences & Advertising
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0
    Write-Host "Disabled tailored experiences."
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
    Write-Host "Disabled Advertising ID tracking."

    # Tips & Lock Screen
    $cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
    Set-ItemProperty -Path $cdm -Name "SubscribedContent-338389Enabled" -Value 0
    Write-Host "Disabled tips and suggestions."
    Set-ItemProperty -Path $cdm -Name "RotatingLockScreenOverlayEnabled" -Value 0
    Write-Host "Disabled lock screen overlays and ads."

    # Search Box Suggestions (Bing integration)
    $searchHKCU = "HKCU:\Software\Policies\Microsoft\Windows\Windows Search"
    if (-not (Test-Path $searchHKCU)) { New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Windows Search" | Out-Null }
    New-ItemProperty -Path $searchHKCU -Name "DisableSearchBoxSuggestions" -PropertyType DWORD -Value 1 -Force | Out-Null
    Write-Host "Disabled Bing integration in Windows Search."

    Write-Host "`nPrivacy Tweaks applied."
}

function Apply-Performance-Tweaks {
    Write-Host "`n--- Applying Performance Tweaks ---"
    Start-Sleep -Milliseconds 300

    # Visual Effects
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
    Write-Host "Set Visual Effects for Best Performance."

    # Startup delay
    $serialize = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
    if (-not (Test-Path $serialize)) { New-Item -Path $serialize -Force | Out-Null }
    New-ItemProperty -Path $serialize -Name "StartupDelayInMSec" -PropertyType DWORD -Value 0 -Force | Out-Null
    Write-Host "Disabled startup delay for applications."

    # Window animations
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
    Write-Host "Disabled window animations."

    # Background apps
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
    Write-Host "Disabled background apps."

    # System sounds
    Set-ItemProperty -Path "HKCU:\AppEvents\Schemes" -Name "(Default)" -Value ".None"
    Write-Host "Disabled system sounds."

    # Windows Store auto-updates
    $storePolicy = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
    if (-not (Test-Path $storePolicy)) {
        New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "WindowsStore" -Force | Out-Null
        Write-Host "Created WindowsStore policy key."
    }
    Set-ItemProperty -Path $storePolicy -Name "AutoDownload" -Value 2
    Write-Host "Disabled Automatic App Updates from Store."

    Write-Host "`nPerformance Tweaks applied."
}

function Apply-All-Tweaks {
    Apply-UI-Tweaks
    Apply-Privacy-Tweaks
    Apply-Performance-Tweaks

    Write-Host "`nAll tweaks applied successfully."
    Write-Host "Restarting Explorer to apply changes..."
    Stop-Process -Name explorer -Force
    Start-Sleep -Seconds 2
    Write-Host "Done."
}

function Restore-Defaults {
    Write-Host "`n--- Restore Defaults ---"

    # TODO: fill in real default values here
    Write-Host "Restoring default registry values (not implemented yet)."
}

function Run-Choice {
    param([string]$choice)

    switch ($choice) {
        "1" { Apply-All-Tweaks }
        "2" { Apply-UI-Tweaks }
        "3" { Apply-Privacy-Tweaks }
        "4" { Apply-Performance-Tweaks }
        "5" { Restore-Defaults }
        "0" { Write-Host "`nExiting..." }
        default { Write-Host "`nInvalid choice. Exiting..." }
    }
}

if ($Option) {
    # run speicifed choice and exit if supplied
    Run-Choice $Option
    exit
}

# menu loop
do {
    Show-Menu
    $choice = Read-Choice "Select an option: "
    Run-Choice $choice

    if ($choice -ne "0") {
        Write-Host "`nPress any key to return to menu..."
        [void][System.Console]::ReadKey($true)
    }

} until ($choice -eq "0")
