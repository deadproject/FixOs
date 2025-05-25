# FixOs by Project/Deadproject
# Star us on GitHub: "https://github.com/deadproject/FixOs"
# Visit our Site: "https://FixOs.pages.dev"
# visit our Creator site: "https://vDevhub.pages.dev"
# Enhancing your Windows experience with powerful tweaks and optimizations

# Start logging
$logFilePath = "C:\path\to\logfile.txt"
Start-Transcript -Path $logFilePath

# Check if script is running as Administrator
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Try {
        Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit
    }
    Catch {
        Write-Host "Failed to run as Administrator. Please rerun with elevated privileges."
        Stop-Transcript
        Exit
    }
}

# Function to execute commands with error handling
function Execute-Command {
    param (
        [string]$command
    )
    try {
        Invoke-Expression $command
    } catch {
        Write-Host "Error executing command: $command"
        Write-Host "Error details: $_"
    }
}

# Enables .NET Framework 3.5
Execute-Command "DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /Source:X:\sources\sxs /LimitAccess"

# Configure Maximum Password Age in Windows
Execute-Command "net.exe accounts /maxpwage:UNLIMITED"

# Allow Execution of PowerShell Script Files
Execute-Command "Set-ExecutionPolicy -Scope 'LocalMachine' -ExecutionPolicy 'AllSigned' -Force"

# Optimize svchost.exe processes based on RAM
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'SvcHostSplitThresholdInKB' -Type DWord -Value $ram -Force"

# Remove AutoLogger if it exists
$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Execute-Command "Remove-Item '$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl'"
}
$icaclsCommand = "icacls `"$autoLoggerDir`" /deny SYSTEM:`"(OI)(CI)F`""
Execute-Command $icaclsCommand

# Disables Teredo
$registryKeysTeredo = @(
    @{Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"; Name = "DisabledComponents"; Type = "DWord"; Value = 1}
)
foreach ($key in $registryKeysTeredo) {
    Execute-Command "New-ItemProperty -Path $($key.Path) -Name $($key.Name) -PropertyType $($key.Type) -Value $($key.Value) -Force"
}
Execute-Command "netsh interface teredo set state disabled"

# Disable Scheduled Tasks
$scheduledTasks = @(
    "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser",
    "Microsoft\Windows\Application Experience\ProgramDataUpdater",
    "Microsoft\Windows\Autochk\Proxy",
    "Microsoft\Windows\Customer Experience Improvement Program\Consolidator",
    "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip",
    "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector",
    "Microsoft\Windows\Feedback\Siuf\DmClient",
    "Microsoft\Windows\Feedback\Siuf\DmClientOnScenarioDownload",
    "Microsoft\Windows\Windows Error Reporting\QueueReporting",
    "Microsoft\Windows\Application Experience\MareBackup",
    "Microsoft\Windows\Application Experience\StartupAppTask",
    "Microsoft\Windows\Application Experience\PcaPatchDbTask",
    "Microsoft\Windows\Maps\MapsUpdateTask"
)
foreach ($task in $scheduledTasks) {
    Execute-Command "schtasks /Change /TN '$task' /Disable"
}

# Enable the Ultimate Performance power plan
Execute-Command "powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61"
Execute-Command "powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61"

# Set Services to Manual
Write-Output 'Setting Services to Manual...'
$servicesToSet = @(
    'AJRouter', 'ALG', 'AppIDSvc', 'AppMgmt', 'AppReadiness', 'AppVClient', 'AppXSvc', 'Appinfo',
    'AssignedAccessManagerSvc', 'AudioEndpointBuilder', 'AudioSrv', 'Audiosrv', 'AxInstSV', 'BDESVC',
    'BFE', 'BITS', 'BTAGService', 'BcastDVRUser  Service_*', 'BrokerInfrastructure', 'Browser',
    'BthAvctpSvc', 'BthHFSrv', 'CDPSvc', 'CDPUser  Svc_*', 'COMSysApp', 'CaptureService_*', 'CertPropSvc',
    'ClipSVC', 'ConsentUxUser  Svc_*', 'CoreMessagingRegistrar', 'CredentialEnrollmentManagerUser  Svc_*',
    'CryptSvc', 'CscService', 'DPS', 'DcomLaunch', 'DcpSvc', 'DevQueryBroker', 'DeviceAssociationBrokerSvc_*',
    'DeviceAssociationService', 'DeviceInstall', 'DevicePickerUser  Svc_*', 'DevicesFlowUser  Svc_*', 'Dhcp',
    'DiagTrack', 'DialogBlockingService', 'DispBrokerDesktopSvc', 'DisplayEnhancementService', 'DmEnrollmentSvc',
    'Dnscache', 'DoSvc', 'DsSvc', 'DsmSvc', 'DusmSvc', 'EFS', 'EapHost', 'EntAppSvc', 'EventLog',
    'EventSystem', 'FDResPub', 'Fax', 'FontCache', 'FrameServer', 'FrameServerMonitor', 'GraphicsPerfSvc',
    'HomeGroupListener', 'HomeGroupProvider', 'HvHost', 'IEEtwCollectorService', 'IKEEXT', 'InstallService',
    'InventorySvc', 'IpxlatCfgSvc', 'KeyIso', 'KtmRm', 'LSM', 'LanmanServer', 'LanmanWorkstation',
    'LicenseManager', 'LxpSvc', 'MSDTC', 'MSiSCSI', 'MapsBroker', 'McpManagementService', 'MessagingService_*',
    'MicrosoftEdgeElevationService', 'MixedRealityOpenXRSvc', 'MpsSvc', 'MsKeyboardFilter', 'NPSMSvc_*',
    'NaturalAuthentication', 'NcaSvc', 'NcbService', 'NcdAutoSetup', 'NetSetupSvc', 'NetTcpPortSharing',
    'Netlogon', 'Netman', 'NgcCtnrSvc', 'NgcSvc', 'NlaSvc', 'OneSyncSvc_*', 'P9RdrService_*', 'PNRPAutoReg',
    'PNRPsvc', 'PcaSvc', 'PeerDistSvc', 'PenService_*', 'PerfHost', 'PhoneSvc', 'PimIndexMaintenanceSvc_*',
    'PlugPlay', 'PolicyAgent', 'Power', 'PrintNotify', 'PrintWorkflowUser  Svc_*', 'ProfSvc', 'PushToInstall',
    'QWAVE', 'RasAuto', 'RasMan', 'RemoteAccess', 'RemoteRegistry', 'RetailDemo', 'RmSvc', 'RpcEptMapper',
    'RpcLocator', 'RpcSs', 'SCPolicySvc', 'SCardSvr', 'SDRSVC', 'SEMgrSvc', 'SENS', 'SNMPTRAP', 'SNMPTrap',
    'SSDPSRV', 'SamSs', 'ScDeviceEnum', 'Schedule', 'SecurityHealthService', 'Sense', 'SensorDataService',
    'SensorService', 'SensrSvc', 'SessionEnv', 'SgrmBroker', 'SharedAccess', 'SharedRealitySvc',
    'ShellHWDetection', 'SmsRouter', 'Spooler', 'SstpSvc', 'StateRepository', 'StiSvc', 'StorSvc', 'SysMain',
    'SystemEventsBroker', 'TabletInputService', 'TapiSrv', 'TermService', 'TextInputManagementService',
    'Themes', 'TieringEngineService', 'TimeBroker', 'TimeBrokerSvc', 'TokenBroker', 'TrkWks',
    'TroubleshootingSvc', 'TrustedInstaller', 'UI0Detect', 'UdkUser  Svc_*', 'UevAgentService', 'UmRdpService',
    'UnistoreSvc_*', 'User  DataSvc_*', 'User  Manager', 'UsoSvc', 'VGAuthService', 'VMTools', 'VSS', 'VacSvc',
    'VaultSvc', 'W32Time', 'WEPHOSTSVC', 'WFDSConMgrSvc', 'WMPNetworkSvc', 'WManSvc', 'WPDBusEnum', 'WSService',
    'WSearch', 'WaaSMedicSvc', 'WalletService', 'WarpJITSvc', 'WbioSrvc', 'Wcmsvc', 'WcsPlugInService',
    'WdNisSvc', 'WdiServiceHost', 'WdiSystemHost', 'WebClient', 'Wecsvc', 'WerSvc', 'WiaRpc', 'WinDefend',
    'WinHttpAutoProxySvc', 'WinRM', 'Winmgmt', 'WlanSvc', 'WpcMonSvc', 'WpnService', 'WpnUser  Service_*',
    'WwanSvc', 'XblAuthManager', 'XblGameSave', 'XboxGipSvc', 'XboxNetApiSvc', 'autotimesvc', 'bthserv',
    'camsvc', 'cbdhsvc_*', 'cloudidsvc', 'dcsvc', 'defragsvc', 'diagnosticshub.standardcollector.service',
    'diagsvc', 'dmwappushservice', 'dot3svc', 'edgeupdate', 'edgeupdatem', 'embeddedmode', 'fdPHost', 'fhsvc',
    'gpsvc', 'hidserv', 'icssvc', 'iphlpsvc', 'lfsvc', 'lltdsvc', 'lmhosts', 'mpssvc', 'msiserver', 'netprofm',
    'nsi', 'p2pimsvc', 'p2psvc', 'perceptionsimulation', 'pla', 'seclogon', 'shpamsvc', 'smphost', 'spectrum',
    'sppsvc', 'ssh-agent', 'svsvc', 'swprv', 'tiledatamodelsvc', 'tzautoupdate', 'uhssvc', 'upnphost', 'vds',
    'vm3dservice', 'vmicguestinterface', 'vmicheartbeat', 'vmickvpexchange', 'vmicrdv', 'vmicshutdown',
    'vmictimesync', 'vmicvmsession', 'vmicvss', 'vmvss', 'wbengine', 'wcncsvc', 'webthreatdefsvc',
    'webthreatdefusersvc_*', 'wercplsupport', 'wisvc', 'wlidsvc', 'wlpasvc', 'wmiApSrv', 'workfolderssvc',
    'wuauserv', 'wudfsvc'
)

foreach ($service in $servicesToSet) {
    Execute-Command "Set-Service -Name '$service' -StartupType Manual -ErrorAction Continue"
}

# Set Wallpaper
$defaultWallpaperPath = "C:\Windows\Web\4K\Wallpaper\Windows\img0_3840x2160.jpg"
$darkModeWallpaperPath = "C:\Windows\Web\4K\Wallpaper\Windows\img19_1920x1200.jpg"

function Set-Wallpaper ($wallpaperPath) {
    Execute-Command "reg.exe add 'HKEY_CURRENT_USER\Control Panel\Desktop' /v Wallpaper /t REG_SZ /d '$wallpaperPath' /f"
    # Notify the system of the change
    Execute-Command "rundll32.exe user32.dll, UpdatePerUser  SystemParameters"
}

# Check Windows version
$windowsVersion = (Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion").CurrentBuild

# Apply appropriate wallpaper based on Windows version or existence of dark mode wallpaper
if ($windowsVersion -ge 22000) {  # Assuming Windows 11 starts at build 22000
    if (Test-Path $darkModeWallpaperPath) {
        Set-Wallpaper -wallpaperPath $darkModeWallpaperPath
    }
} else {
    # Apply default wallpaper for Windows 10
    Set-Wallpaper -wallpaperPath $defaultWallpaperPath
}

# Disable Xbox Game Bar
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'ShowStartupPanel' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'GamePanelStartupTipIndex' -Value 3 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'AllowAutoGameMode' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'UseNexusForGameBarEnabled' -Value 0 -Type DWord"

# Disable GameDVR (screen recording)
Execute-Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR' -Name 'AllowGameDVR' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR' -Name 'AppCaptureEnabled' -Value 0 -Type DWord"

# Disable Background Apps
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' -Name 'GlobalUser Disabled' -Value 1 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'BackgroundAppGlobalToggle' -Value 0 -Type DWord"

# Disable Hibernation
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control\Power' -Name 'HibernateEnabled' -Value 0 -Type DWord"

# Disable Automatic Low Disk Space Check
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' -Name 'NoLowDiskSpaceChecks' -Value 1 -Type DWord"

# Optimize System Responsiveness for Background Tasks
Execute-Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' -Name 'SystemResponsiveness' -Value 0 -Type DWord"

# Disable Taskbar Transparency (Visual Effects)
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Value 2 -Type DWord"

# Disable Windows Search (Indexing)
Execute-Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search' -Name 'BackgroundAppGlobalToggle' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\WSearch' -Name 'Start' -Value 4 -Type DWord"

# Improve Network Performance (TCP/IP & AFD)
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'DelayedAckFrequency' -Value 1 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters' -Name 'CongestionAlgorithm' -Value 1 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DefaultReceiveWindow' -Value 16384 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters' -Name 'DefaultSendWindow' -Value 16384 -Type DWord"

# Disable Game Mode Auto-Start
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'ShowStartupPanel' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'AllowAutoGameMode' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\GameBar' -Name 'AutoGameModeEnabled' -Value 0 -Type DWord"

# Optimize Shutdown Speed
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Control' -Name 'WaitToKillServiceTimeout' -Value '2000' -Type String"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'WaitToKillAppTimeout' -Value '2000' -Type String"
Execute-Command "Set-ItemProperty -Path 'HKCU:\Control Panel\Desktop' -Name 'HungAppTimeout' -Value '1000' -Type String"

# Disable Cortana
Execute-Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowCortana' -Value 0 -Type DWord"
Execute-Command "Set-ItemProperty -Path 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search' -Name 'AllowSearchToUseLocation' -Value 0 -Type DWord"

# Disables Telemetry and Data Collection
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection' /v AllowTelemetry /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection' /v AllowTelemetry /t REG_DWORD /d 0 /f"

# Disables Location Services
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' /v NoLocation /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Location\DeviceStatus' /v 'EnableLocation' /t REG_DWORD /d 0 /f"

# Disables Activity History
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\System' /v EnableActivityFeed /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\System' /v PublishUserActivities /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\System' /v UploadUserActivities /t REG_DWORD /d 0 /f"

# Disables Feedback & Tips Notifications
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection' /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f"

# Disables Advertising ID
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f"

# Disables Windows Error Reporting
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting' /v Disabled /t REG_DWORD /d 1 /f"

# Disables Delivery Optimization (Peer-to-peer Updates)
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' /v DODownloadMode /t REG_DWORD /d 0 /f"

# Disables Microsoft Account Data Collection
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings' /v 'IsMSACloudSearchEnabled' /t REG_DWORD /d 0 /f"

# Disables Speech Services and Voice Activation
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Speech_OneCore\Settings' /v 'EnableSpeechRecognition' /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Speech_OneCore\Settings' /v 'EnableDictation' /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Holographic' /v 'EnableVoiceActivation' /t REG_DWORD /d 0 /f"

# Disables Windows Ink and Handwriting Personalization
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\InputPersonalization' /v 'RestrictImplicitTextCollection' /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\InputPersonalization' /v 'RestrictImplicitInkCollection' /t REG_DWORD /d 1 /f"

# Disables App Notifications
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications' /v 'ToastEnabled' /t REG_DWORD /d 0 /f"

# Disables Suggested Content in Settings App
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v 'DisableWindowsConsumerFeatures' /t REG_DWORD /d 1 /f"

# Disables Show Windows Tips
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v 'ShowWindowsTips' /t REG_DWORD /d 0 /f"

# Disables Sync Settings
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore' /v 'CloudSyncEnabled' /t REG_DWORD /d 0 /f"

# Disables App Launch Tracking
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v 'Start_TrackProgs' /t REG_DWORD /d 0 /f"

# Disables Automatically Submitting Samples to Windows Defender
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows Defender' /v 'DisableAutomaticSampleSubmission' /t REG_DWORD /d 1 /f"

# Disables User Data Collection for Windows Defender
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet' /v 'SpyNetReporting' /t REG_DWORD /d 0 /f"

# Disables Windows Store Apps Feedback
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer' /v 'NoFeedback' /t REG_DWORD /d 1 /f"

# Disables Cloud-Based Content and Services
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v 'DisableWindowsSpotlightOnLockScreen' /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v 'DisableWindowsConsumerFeatures' /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v 'DisableWindowsSpotlightActiveUser' /t REG_DWORD /d 1 /f"

# Disable Web Search
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Search' /v 'CortanaEnabled' /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Search' /v 'AllowCortana' /t REG_DWORD /d 0 /f"

# Prevents the System from Sending Language Data
Execute-Command "reg.exe add 'HKCU\Control Panel\International\User Profile' /v 'HttpAcceptLanguageOptOut' /t REG_DWORD /d 1 /f"

# Disable Windows Store Access
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\WindowsStore' /v 'RemoveWindowsStore' /t REG_DWORD /d 1 /f"

# Disable Microsoft Store Automatic Updates
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\WindowsStore' /v 'AutoDownload' /t REG_DWORD /d 2 /f"

# Disable the 'Let apps use my advertising ID' setting
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo' /v 'DisabledByGroupPolicy' /t REG_DWORD /d 1 /f"

# Prevent apps from accessing your personal info
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy' /v 'AllowAppTrack' /t REG_DWORD /d 0 /f"

# Disable Syncing of Passwords, Themes, and Other Settings
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\SyncManager' /v 'SyncEnabled' /t REG_DWORD /d 0 /f"

# Disable Windows Store Background Tasks
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications' /v 'AllowAppService' /t REG_DWORD /d 0 /f"

# Disables Windows Ink Workspace
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace' /v AllowWindowsInkWorkspace /t REG_DWORD /d 0 /f"

# Disables Feedback Notifications
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection' /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f"

# Disables the Advertising ID for All Users
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo' /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f"

# Disables Windows Error Reporting
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting' /v Disabled /t REG_DWORD /d 1 /f"

# Disables Delivery Optimization
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config' /v DODownloadMode /t REG_DWORD /d 0 /f"

# Disables Remote Assistance
Execute-Command "reg.exe add 'HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance' /v fAllowToGetHelp /t REG_DWORD /d 0 /f"

# Search Windows Update for Drivers First
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching' /v SearchOrderConfig /t REG_DWORD /d 1 /f"

# Gives Multimedia Applications like Games and Video Editing a Higher Priority
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' /v SystemResponsiveness /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile' /v NetworkThrottlingIndex /t REG_DWORD /d 10 /f"

# Controls whether the memory page file is cleared at shutdown. Value 0 means it will not be cleared, speeding up shutdown.
Execute-Command "reg.exe add 'HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management' /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f"

# Enables NDU (Network Diagnostic Usage) Service on Startup
Execute-Command "reg.exe add 'HKLM\SYSTEM\ControlSet001\Services\Ndu' /v Start /t REG_DWORD /d 2 /f"

# Increases IRP stack size to 30 for the LanmanServer service to Improve Network Performance and Stability
Execute-Command "reg.exe add 'HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters' /v IRPStackSize /t REG_DWORD /d 30 /f"

# Hides the Meet Now Button on the Taskbar
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' /v HideSCAMeetNow /t REG_DWORD /d 1 /f"

# Gives Graphics Cards a Higher Priority for Gaming
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' /v 'GPU Priority' /t REG_DWORD /d 8 /f"

# Gives the CPU a Higher Priority for Gaming
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' /v Priority /t REG_DWORD /d 6 /f"

# Gives Games a higher priority in the system's scheduling
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games' /v 'Scheduling Category' /t REG_SZ /d 'High' /f"

# Start Menu Customization
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start' /v ConfigureStartPins /t REG_SZ /d '{ \"pinnedList\": [] }' /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start' /v ConfigureStartPins_ProviderSet /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start' /v ConfigureStartPins_WinningProvider /t REG_SZ /d B5292708-1619-419B-9923-E5D9F3925E71 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start' /v ConfigureStartPins /t REG_SZ /d '{ \"pinnedList\": [] }' /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start' /v ConfigureStartPins_LastWrite /t REG_DWORD /d 1 /f"

# Sets Windows Update to Only Install Security Updates and Delay Other Updates for 2 Years
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU' /v AUOptions /t REG_DWORD /d 3 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' /v DeferFeatureUpdates /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' /v DeferFeatureUpdatesPeriodInDays /t REG_DWORD /d 365 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' /v DeferQualityUpdates /t REG_DWORD /d 1 /f"
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate' /v DeferQualityUpdatesPeriodInDays /t REG_DWORD /d 365 /f"

# Disable Windows Spotlight and set the normal Windows Picture as the desktop background
# Disable Windows Spotlight on the lock screen
Execute-Command "reg.exe add 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v DisableWindowsSpotlightOnLockScreen /t REG_DWORD /d 1 /f"
# Disable Windows Spotlight suggestions, tips, tricks, and more on the lock screen
Execute-Command "reg.exe add 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f"
# Disable Windows Spotlight on Settings
Execute-Command "reg.exe add 'HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent' /v DisableWindowsSpotlightActiveUser /t REG_DWORD /d 1 /f"

# Remove gallery from file explorer
Execute-Command "reg.exe add 'HKEY_CURRENT_USER\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' /v 'System.IsPinnedToNameSpaceTree' /t REG_DWORD /d 0 /f"
Execute-Command "reg.exe add 'HKEY_USERS\%USERPROFILE%\Software\Classes\CLSID\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}' /v 'System.IsPinnedToNameSpaceTree' /t REG_DWORD /d 0 /f"

# Remove home from file explorer
Execute-Command "reg.exe delete 'HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}' /f"

# Remove home page from settings
Execute-Command "reg.exe add 'HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer' /v SettingsPageVisibility /t REG_SZ /d 'Hide:Home' /f"

# File Explorer default to This PC
Execute-Command "reg.exe add 'HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' /v LaunchTo /t REG_DWORD /d 1 /f"

# Disable Recell
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\Recell' -Name 'Start' -Value 4 -Type DWord"

# Disable DICM
Execute-Command "Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\DICM' -Name 'Start' -Value 4 -Type DWord"

# software remove/install

# Ensure PowerShell is running with Administrator privileges
$IsAdmin = [Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()
$IsAdmin.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator) -or {
    Write-Host "This script requires Administrator privileges. Please run as Administrator."
    exit
}

# Install Chocolatey if not already installed
Write-Host "Checking if Chocolatey is installed..."
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Chocolatey is not installed. Installing Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
} else {
    Write-Host "Chocolatey is already installed."
}

# Install desired programs using Chocolatey
$packagesToInstall = @(
    'thorium-browser',
    'powershell-core',
    '7zip',
    'vlc',
    'git'
)

Write-Host "Installing packages using Chocolatey..."

foreach ($package in $packagesToInstall) {
    Write-Host "Installing $package..."
    choco install $package -y
}

# Remove Microsoft Edge from the taskbar
Write-Host "Removing Microsoft Edge from the taskbar..."
$edgeTaskbarPath = "$env:APPDATA\Microsoft\Internet Explorer\Quick Launch\User Pinned\TaskBar\Microsoft Edge.lnk"
if (Test-Path $edgeTaskbarPath) {
    Remove-Item $edgeTaskbarPath -ErrorAction SilentlyContinue
}

# List of unwanted apps to remove
$appsToRemove = @(
    'Microsoft.Microsoft3DViewer',
    'Microsoft.BingSearch',
    'Microsoft.WindowsCalculator',
    'Microsoft.WindowsCamera',
    'Clipchamp.Clipchamp',
    'Microsoft.WindowsAlarms',
    'Microsoft.549981C3F5F10',
    'Microsoft.Windows.DevHome',
    'MicrosoftCorporationII.MicrosoftFamily',
    'Microsoft.WindowsFeedbackHub',
    'Microsoft.GetHelp',
    'Microsoft.Getstarted',
    'microsoft.windowscommunicationsapps',
    'Microsoft.WindowsMaps',
    'Microsoft.MixedReality.Portal',
    'Microsoft.BingNews',
    'Microsoft.MicrosoftOfficeHub',
    'Microsoft.Office.OneNote',
    'Microsoft.OutlookForWindows',
    'Microsoft.Paint',
    'Microsoft.MSPaint',
    'Microsoft.People',
    'Microsoft.PowerAutomateDesktop',
    'MicrosoftCorporationII.QuickAssist',
    'Microsoft.SkypeApp',
    'Microsoft.MicrosoftSolitaireCollection',
    'Microsoft.MicrosoftStickyNotes',
    'MicrosoftTeams',
    'MSTeams',
    'Microsoft.Todos',
    'Microsoft.WindowsSoundRecorder',
    'Microsoft.Wallet',
    'Microsoft.BingWeather',
    'Microsoft.Xbox.TCUI',
    'Microsoft.XboxApp',
    'Microsoft.XboxGameOverlay',
    'Microsoft.XboxGamingOverlay',
    'Microsoft.XboxIdentityProvider',
    'Microsoft.XboxSpeechToTextOverlay',
    'Microsoft.GamingApp',
    'Microsoft.YourPhone',
    'Microsoft.ZuneVideo'
)

Write-Host "Removing unwanted apps..."

# Loop through each app and remove it if installed or provisioned
foreach ($app in $appsToRemove) {
    Write-Host "Removing $app..."

    # Remove the app for the current user
    Get-AppxPackage -Name $app | Remove-AppxPackage -ErrorAction SilentlyContinue

    # Remove the app as a provisioned package so it doesn't get installed for new users
    Get-AppxProvisionedPackage -Online | Where-Object DisplayName -EQ $app | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue
}

# Notify the user that the operation has finished
Write-Host "Unwanted apps removal complete."

# Reboot the system (if needed)
$reboot = Read-Host "Do you want to reboot the system now? (Y/N)"
if ($reboot -eq 'Y') {
    Write-Host "Rebooting the system..."
    Restart-Computer -Force
} else {
    Write-Host "Reboot cancelled. Please restart the system later."
}
