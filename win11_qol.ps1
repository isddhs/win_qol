<#  Windows 11 QoL Tweaks #>

Write-Host "Applying Windows 11 Quality of Life Tweaks..."
Start-Sleep -Milliseconds 300

# EXPLORER & UI
$adv = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"

Set-ItemProperty -Path $adv -Name "SnapAssist" -Value 0
Write-Host "Disabled Snap Assist Suggestions."

Set-ItemProperty -Path $adv -Name "TaskbarDa" -Value 0
Write-Host "Disabled Widgets."

Set-ItemProperty -Path $adv -Name "TaskbarMn" -Value 0
Write-Host "Disabled Chat from Taskbar."

$explorerPolicy = "HKCU:\Software\Policies\Microsoft\Windows\Explorer"
if (-not (Test-Path $explorerPolicy)) {
    New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Explorer" -Force | Out-Null
    Write-Host "Created Explorer policy key."
}
New-ItemProperty -Path $explorerPolicy -Name "DisableSearchBoxSuggestions" -PropertyType DWORD -Value 1 -Force | Out-Null
Write-Host "Disabled Search Box Suggestions."

# CONTEXT MENU
$clsid = "HKCU:\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32"
if (-not (Test-Path $clsid)) { New-Item -Path $clsid -Force | Out-Null }
Set-ItemProperty -Path $clsid -Name "(default)" -Value "" -Force
Write-Host "Enabled classic context menu."

# EXPLOERR
Set-ItemProperty -Path $adv -Name "HideFileExt" -Value 0
Write-Host "Showing file extensions."

Set-ItemProperty -Path $adv -Name "Hidden" -Value 1
Write-Host "Showing hidden files and folders."

Set-ItemProperty -Path $adv -Name "LaunchTo" -Value 1
Write-Host "Set File Explorer to open 'This PC'."

Set-ItemProperty -Path $adv -Name "TaskbarSi" -Value 0
Write-Host "Taskbar size set to small."

# PRIVACY
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CapabilityAccessManager\ConsentStore\location" -Name "Value" -Value "Deny"
Write-Host "Disabled Location Tracking."

$searchPolicyHKLM = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search"
if (-not (Test-Path $searchPolicyHKLM)) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Windows Search" -Force | Out-Null
    Write-Host "Created Windows Search policy key."
}
Set-ItemProperty -Path $searchPolicyHKLM -Name "AllowCortana" -Value 0
Write-Host "Disabled Cortana."

# TELEMETRY
$tele = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection"
if (-not (Test-Path $tele)) { New-Item -Path $tele -Force | Out-Null }
New-ItemProperty -Path $tele -Name "AllowTelemetry" -PropertyType DWORD -Value 1 -Force | Out-Null
Write-Host "Limited telemetry to Basic."

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Privacy" -Name "TailoredExperiencesWithDiagnosticDataEnabled" -Value 0
Write-Host "Disabled tailored experiences."

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" -Name "Enabled" -Value 0
Write-Host "Disabled Advertising ID tracking."

$cdm = "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager"
Set-ItemProperty -Path $cdm -Name "SubscribedContent-338389Enabled" -Value 0
Write-Host "Disabled tips and suggestions."

Set-ItemProperty -Path $cdm -Name "RotatingLockScreenOverlayEnabled" -Value 0
Write-Host "Disabled lock screen overlays/ads."

$searchHKCU = "HKCU:\Software\Policies\Microsoft\Windows\Windows Search"
if (-not (Test-Path $searchHKCU)) { New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows" -Name "Windows Search" | Out-Null }
New-ItemProperty -Path $searchHKCU -Name "DisableSearchBoxSuggestions" -PropertyType DWORD -Value 1 -Force | Out-Null
Write-Host "Disabled Bing in Windows Search."

# PERFORMANCE
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2
Write-Host "Set Visual Effects to Best Performance."

$serialize = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Serialize"
if (-not (Test-Path $serialize)) { New-Item -Path $serialize -Force | Out-Null }
New-ItemProperty -Path $serialize -Name "StartupDelayInMSec" -PropertyType DWORD -Value 0 -Force | Out-Null
Write-Host "Disabled startup delay."

Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value 0
Write-Host "Disabled window animations."

Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1
Write-Host "Disabled background apps."

# NOTIFICATIONS
Write-Host "Notification Center tweak skipped (to keep calendar/date flyout working)."

# SOUND TWEAKS
$storePolicy = "HKLM:\SOFTWARE\Policies\Microsoft\WindowsStore"
if (-not (Test-Path $storePolicy)) {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "WindowsStore" -Force | Out-Null
    Write-Host "Created WindowsStore policy key."
}
Set-ItemProperty -Path $storePolicy -Name "AutoDownload" -Value 2
Write-Host "Disabled Windows Store auto-updates."

Set-ItemProperty -Path "HKCU:\AppEvents\Schemes" -Name "(Default)" -Value ".None"
Write-Host "Disabled system sounds."

Write-Host ""
Write-Host "All tweaks applied successfully."
Write-Host "Restarting Explorer..."
Stop-Process -Name explorer -Force
Start-Sleep -Seconds 2
Write-Host "Done!"
