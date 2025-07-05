# Check if script is running as Administrator
If (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]"Administrator")) {
    Try {
        Start-Process PowerShell.exe -ArgumentList ("-NoProfile -ExecutionPolicy Bypass -File `"{0}`"" -f $PSCommandPath) -Verb RunAs
        Exit
    }
    Catch {
        Write-Host "Failed to run as Administrator. Please rerun with elevated privileges."
        Exit
    }
}

# Enables .NET Framework 3.5
DISM /Online /Enable-Feature /FeatureName:NetFx3 /All /Source:X:\sources\sxs /LimitAccess

# Configure Maximum Password Age in Windows
net.exe accounts /maxpwage:UNLIMITED

# Allow Execution of PowerShell Script Files
Set-ExecutionPolicy -Scope 'LocalMachine' -ExecutionPolicy 'AllSigned' -Force

# Groups or splits svchost.exe processes based on the amount of physical memory in the system to optimize performance
$ram = (Get-CimInstance -ClassName Win32_PhysicalMemory | Measure-Object -Property Capacity -Sum).Sum / 1kb
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "SvcHostSplitThresholdInKB" -Type DWord -Value $ram -Force

$autoLoggerDir = "$env:PROGRAMDATA\Microsoft\Diagnosis\ETLLogs\AutoLogger"
If (Test-Path "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl") {
    Remove-Item "$autoLoggerDir\AutoLogger-Diagtrack-Listener.etl"
}
$icaclsCommand = "icacls `"$autoLoggerDir`" /deny SYSTEM:`"(OI)(CI)F`""
Invoke-Expression $icaclsCommand | Out-Null

# Disables Teredo
$registryKeysTeredo = @(
    @{Path = "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip6\Parameters"; Name = "DisabledComponents"; Type = "DWord"; Value = 1}
)
foreach ($key in $registryKeysTeredo) {
    New-ItemProperty -Path $key.Path -Name $key.Name -PropertyType $key.Type -Value $key.Value -Force
}
netsh interface teredo set state disabled

# Disables Telemetry
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
    schtasks /Change /TN $task /Disable
}

# Enable the Ultimate Performance power plan
powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61

# Set the Ultimate Performance power plan as active
powercfg -setactive e9a42b02-d5df-448d-aa00-03f14749eb61

# Set Services to Manual
Write-Output 'Set Services to Manual: Turns a bunch of system services to manual that do not need to be running all the time.'
Set-Service -Name 'AJRouter' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'ALG' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppIDSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppMgmt' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppReadiness' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AppVClient' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'AppXSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Appinfo' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'AssignedAccessManagerSvc' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'AudioEndpointBuilder' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'AudioSrv' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'Audiosrv' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'AxInstSV' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BDESVC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BFE' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'BITS' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BTAGService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BcastDVRUserService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BrokerInfrastructure' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'Browser' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'BthAvctpSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'BthHFSrv' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'CDPSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CDPUserSvc_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'COMSysApp' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CaptureService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CertPropSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ClipSVC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ConsentUxUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CoreMessagingRegistrar' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'CredentialEnrollmentManagerUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'CryptSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'CscService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DPS' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DcomLaunch' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DcpSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DevQueryBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DeviceAssociationBrokerSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DeviceAssociationService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DeviceInstall' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DevicePickerUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DevicesFlowUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Dhcp' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DialogBlockingService' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'DispBrokerDesktopSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DisplayEnhancementService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DmEnrollmentSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Dnscache' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'DoSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DsSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DsmSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'DusmSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'EFS' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'EapHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'EntAppSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'EventLog' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'EventSystem' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'FDResPub' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Fax' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'FontCache' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'FrameServer' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'FrameServerMonitor' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'GraphicsPerfSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'HomeGroupListener' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'HomeGroupProvider' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'HvHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'IEEtwCollectorService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'IKEEXT' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'InstallService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'InventorySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'IpxlatCfgSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'KeyIso' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'KtmRm' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'LSM' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'LanmanServer' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'LanmanWorkstation' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'LicenseManager' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'LxpSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MSDTC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MSiSCSI' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MapsBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'McpManagementService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MessagingService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MicrosoftEdgeElevationService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MixedRealityOpenXRSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'MpsSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'MsKeyboardFilter' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NPSMSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NaturalAuthentication' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NcaSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NcbService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NcdAutoSetup' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NetSetupSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NetTcpPortSharing' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'Netlogon' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'Netman' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NgcCtnrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NgcSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'NlaSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'OneSyncSvc_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'P9RdrService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PNRPAutoReg' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PNRPsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PcaSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PeerDistSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PenService_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PerfHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PhoneSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PimIndexMaintenanceSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PlugPlay' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PolicyAgent' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Power' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'PrintNotify' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'PrintWorkflowUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ProfSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'PushToInstall' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'QWAVE' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RasAuto' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RasMan' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RemoteAccess' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'RemoteRegistry' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'RetailDemo' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RmSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RpcEptMapper' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'RpcLocator' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'RpcSs' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SCPolicySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SCardSvr' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SDRSVC' -StartupType Manual -ErrorAction Continue 
Set-Service -Name 'SEMgrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SENS' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SNMPTRAP' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SNMPTrap' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SSDPSRV' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SamSs' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'ScDeviceEnum' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Schedule' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SecurityHealthService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Sense' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SensorDataService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SensorService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SensrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SessionEnv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SgrmBroker' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SharedAccess' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SharedRealitySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ShellHWDetection' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SmsRouter' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Spooler' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SstpSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'StateRepository' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'StiSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'StorSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'SysMain' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'SystemEventsBroker' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TabletInputService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TapiSrv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TermService' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TextInputManagementService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Themes' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TieringEngineService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TimeBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TimeBrokerSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TokenBroker' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TrkWks' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'TroubleshootingSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'TrustedInstaller' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UI0Detect' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UdkUserSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UevAgentService' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'UmRdpService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UnistoreSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UserDataSvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'UserManager' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'UsoSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'VGAuthService' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'VMTools' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'VSS' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'VacSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'VaultSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'W32Time' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WEPHOSTSVC' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WFDSConMgrSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WMPNetworkSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WManSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WPDBusEnum' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WSService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WSearch' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WaaSMedicSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WalletService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WarpJITSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WbioSrvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Wcmsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WcsPlugInService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WdNisSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WdiServiceHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WdiSystemHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WebClient' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Wecsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WerSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WiaRpc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WinDefend' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WinHttpAutoProxySvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WinRM' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'Winmgmt' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WlanSvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WpcMonSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WpnService' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'WpnUserService_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'WwanSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XblAuthManager' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XblGameSave' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XboxGipSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'XboxNetApiSvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'autotimesvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'bthserv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'camsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'cbdhsvc_*' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'cloudidsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'dcsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'defragsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'diagnosticshub.standardcollector.service' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'diagsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'dmwappushservice' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'dot3svc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'edgeupdate' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'edgeupdatem' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'embeddedmode' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'fdPHost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'fhsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'gpsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'hidserv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'icssvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'iphlpsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'lfsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'lltdsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'lmhosts' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'mpssvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'msiserver' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'netprofm' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'nsi' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'p2pimsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'p2psvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'perceptionsimulation' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'pla' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'seclogon' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'shpamsvc' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'smphost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'spectrum' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'sppsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'ssh-agent' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'svsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'swprv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'tiledatamodelsvc' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'tzautoupdate' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'uhssvc' -StartupType Disabled -ErrorAction Continue
Set-Service -Name 'upnphost' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vds' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vm3dservice' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicguestinterface' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicheartbeat' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmickvpexchange' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicrdv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicshutdown' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmictimesync' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicvmsession' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmicvss' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'vmvss' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wbengine' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wcncsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'webthreatdefsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'webthreatdefusersvc_*' -StartupType Automatic -ErrorAction Continue
Set-Service -Name 'wercplsupport' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wisvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wlidsvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wlpasvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wmiApSrv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'workfolderssvc' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wuauserv' -StartupType Manual -ErrorAction Continue
Set-Service -Name 'wudfsvc' -StartupType Manual -ErrorAction Continue

# Disable Xbox Game Bar
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "GamePanelStartupTipIndex" -Value 3 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Value 0 -Type DWord

# Disable GameDVR (screen recording)
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\GameDVR" -Name "AppCaptureEnabled" -Value 0 -Type DWord

# Disable Background Apps
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" -Name "GlobalUserDisabled" -Value 1 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BackgroundAppGlobalToggle" -Value 0 -Type DWord

# Disable Hibernation
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "HibernateEnabled" -Value 0 -Type DWord

# Disable Automatic Low Disk Space Check
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoLowDiskSpaceChecks" -Value 1 -Type DWord

# Optimize System Responsiveness for Background Tasks
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" -Name "SystemResponsiveness" -Value 0 -Type DWord

# Disable Taskbar Transparency (Visual Effects)
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value 2 -Type DWord

# Improve Network Performance (TCP/IP & AFD)
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "DelayedAckFrequency" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name "CongestionAlgorithm" -Value 1 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters" -Name "DefaultReceiveWindow" -Value 16384 -Type DWord
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\AFD\Parameters" -Name "DefaultSendWindow" -Value 16384 -Type DWord

# Disable Game Mode Auto-Start
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "ShowStartupPanel" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AllowAutoGameMode" -Value 0 -Type DWord
Set-ItemProperty -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Value 0 -Type DWord

# Optimize Shutdown Speed
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control" -Name "WaitToKillServiceTimeout" -Value "2000" -Type String
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "WaitToKillAppTimeout" -Value "2000" -Type String
Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "HungAppTimeout" -Value "1000" -Type String

# Disable Cortana
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0 -Type DWord
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowSearchToUseLocation" -Value 0 -Type DWord

# Disables Telemetry and Data Collection
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v AllowTelemetry /t REG_DWORD /d 0 /f

# Disables Location Services
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v NoLocation /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Location\DeviceStatus" /v "EnableLocation" /t REG_DWORD /d 0 /f

# Turns off Activity History (User can re-enable it later)
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v EnableActivityFeed /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v PublishUserActivities /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v UploadUserActivities /t REG_DWORD /d 0 /f

# Disables Feedback & Tips Notifications
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowSyncProviderNotifications /t REG_DWORD /d 0 /f

# Disables Advertising ID
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f

# Disables Windows Error Reporting
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f

# Disables Delivery Optimization (Peer-to-peer Updates)
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f

# Disables Microsoft Account Data Collection
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SearchSettings" /v "IsMSACloudSearchEnabled" /t REG_DWORD /d 0 /f

# Disables Speech Services and Voice Activation
reg.exe add "HKCU\Software\Microsoft\Speech_OneCore\Settings" /v "EnableSpeechRecognition" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Speech_OneCore\Settings" /v "EnableDictation" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Holographic" /v "EnableVoiceActivation" /t REG_DWORD /d 0 /f

# Disables Windows Ink and Handwriting Personalization
reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t REG_DWORD /d 1 /f
reg.exe add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t REG_DWORD /d 1 /f

# Disables App Notifications
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\PushNotifications" /v "ToastEnabled" /t REG_DWORD /d 0 /f

# Disables Suggested Content in Settings App
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f

# Disables Show Windows Tips
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowWindowsTips" /t REG_DWORD /d 0 /f

# Disables Sync Settings
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\CloudStore" /v "CloudSyncEnabled" /t REG_DWORD /d 0 /f

# Disables App Launch Tracking
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t REG_DWORD /d 0 /f

# Disables Automatically Submitting Samples to Windows Defender
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAutomaticSampleSubmission" /t REG_DWORD /d 1 /f

# Disables User Data Collection for Windows Defender
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t REG_DWORD /d 0 /f

# Disables Windows Store Apps Feedback
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoFeedback" /t REG_DWORD /d 1 /f

# Disables Cloud-Based Content and Services
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightOnLockScreen" /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightActiveUser" /t REG_DWORD /d 1 /f

# Disable Web Search
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaEnabled" /t REG_DWORD /d 0 /f
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "AllowCortana" /t REG_DWORD /d 0 /f

# Prevents the System from Sending Language Data
reg.exe add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t REG_DWORD /d 1 /f

# Disable Windows Store Access
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "RemoveWindowsStore" /t REG_DWORD /d 1 /f

# Disable Microsoft Store Automatic Updates
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WindowsStore" /v "AutoDownload" /t REG_DWORD /d 2 /f

# Disable the "Let apps use my advertising ID" setting
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\AdvertisingInfo" /v "DisabledByGroupPolicy" /t REG_DWORD /d 1 /f

# Prevent apps from accessing your personal info
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\Privacy" /v "AllowAppTrack" /t REG_DWORD /d 0 /f

# Disable Syncing of Passwords, Themes, and Other Settings
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\SyncManager" /v "SyncEnabled" /t REG_DWORD /d 0 /f

# Disable Windows Store Background Tasks
reg.exe add "HKCU\Software\Microsoft\Windows\CurrentVersion\BackgroundAccessApplications" /v "AllowAppService" /t REG_DWORD /d 0 /f

# Disables Windows Ink Workspace
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" /v AllowWindowsInkWorkspace /t REG_DWORD /d 0 /f

# Disables Feedback Notifications
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v DoNotShowFeedbackNotifications /t REG_DWORD /d 1 /f

# Disables the Advertising ID for All Users
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AdvertisingInfo" /v DisabledByGroupPolicy /t REG_DWORD /d 1 /f

# Disables Windows Error Reporting
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\Windows Error Reporting" /v Disabled /t REG_DWORD /d 1 /f

# Disables Delivery Optimization
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DeliveryOptimization\Config" /v DODownloadMode /t REG_DWORD /d 0 /f

# Disables Remote Assistance
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v fAllowToGetHelp /t REG_DWORD /d 0 /f

# Search Windows Update for Drivers First
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\DriverSearching" /v SearchOrderConfig /t REG_DWORD /d 1 /f

# Gives Multimedia Applications like Games and Video Editing a Higher Priority
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v SystemResponsiveness /t REG_DWORD /d 0 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile" /v NetworkThrottlingIndex /t REG_DWORD /d 10 /f

# Controls whether the memory page file is cleared at shutdown. Value 0 means it will not be cleared, speeding up shutdown.
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v ClearPageFileAtShutdown /t REG_DWORD /d 0 /f

# Enables NDU (Network Diagnostic Usage) Service on Startup
reg.exe add "HKLM\SYSTEM\ControlSet001\Services\Ndu" /v Start /t REG_DWORD /d 2 /f

# Increases IRP stack size to 30 for the LanmanServer service to Improve Network Performance and Stability
reg.exe add "HKLM\SYSTEM\CurrentControlSet\Services\LanmanServer\Parameters" /v IRPStackSize /t REG_DWORD /d 30 /f

# Hides the Meet Now Button on the Taskbar
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v HideSCAMeetNow /t REG_DWORD /d 1 /f

# Gives Graphics Cards a Higher Priority for Gaming
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "GPU Priority" /t REG_DWORD /d 8 /f

# Gives the CPU a Higher Priority for Gaming
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v Priority /t REG_DWORD /d 6 /f

# Gives Games a higher priority in the system's scheduling
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Multimedia\SystemProfile\Tasks\Games" /v "Scheduling Category" /t REG_SZ /d "High" /f

# Start Menu Customization
reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins /t REG_SZ /d "{ \"pinnedList\": [] }" /f
reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins_ProviderSet /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start" /v ConfigureStartPins_WinningProvider /t REG_SZ /d B5292708-1619-419B-9923-E5D9F3925E71 /f
reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" /v ConfigureStartPins /t REG_SZ /d "{ \"pinnedList\": [] }" /f
reg.exe add "HKLM\SOFTWARE\Microsoft\PolicyManager\providers\B5292708-1619-419B-9923-E5D9F3925E71\default\Device\Start" /v ConfigureStartPins_LastWrite /t REG_DWORD /d 1 /f

# Sets Windows Update to Only Install Security Updates and Delay Other Updates for 2 Years
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v AUOptions /t REG_DWORD /d 3 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdates /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferFeatureUpdatesPeriodInDays /t REG_DWORD /d 365 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdates /t REG_DWORD /d 1 /f
reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate" /v DeferQualityUpdatesPeriodInDays /t REG_DWORD /d 365 /f

# Disable Windows Spotlight and set the normal Windows Picture as the desktop background
# Disable Windows Spotlight on the lock screen
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightOnLockScreen /t REG_DWORD /d 1 /f
# Disable Windows Spotlight suggestions, tips, tricks, and more on the lock screen
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsConsumerFeatures /t REG_DWORD /d 1 /f
# Disable Windows Spotlight on Settings
reg.exe add "HKEY_LOCAL_MACHINE\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v DisableWindowsSpotlightActiveUser /t REG_DWORD /d 1 /f

# Remove the "Home" and "Gallery" from Explorer 
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f
reg.exe delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f
reg.exe delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}" /f
reg.exe delete "HKLM\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" /f

# Add registry key to hide the "Home" in Settings
reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v SettingsPageVisibility /t REG_SZ /d "Hide:Home" /f