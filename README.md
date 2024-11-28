# UnattendedWinstall

## Introduction

UnattendedWinstall leverages Microsoft's [Answer Files](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11) (or Unattend files) to automate and customize Windows installations. It enables modifications to Windows Settings and Packages directly in the Windows ISO during setup.

### Why Use an Answer File?

#### Security

- Provides transparency by allowing inspection of all changes in the answer file.
- Runs directly on official Windows ISOs from Microsoft, eliminating the need for unofficial sources.
- Utilizes a Microsoft-supported feature designed for streamlined mass deployment of Windows installations.

#### Automation

- Enables automated configuration across multiple devices, saving time and effort by eliminating repetitive manual setups

> [!NOTE] 
> UnattendedWinstall has been tested and optimized for personal use. For those interested in customizing further, [create your own answer file](https://schneegans.de/windows/unattend-generator/) 


### Feedback and Community

If you have feedback, suggestions, or need help with UnattendedWinstall, please feel free to join the discussion on GitHub or our Discord community:

[![Join Discord Community])](https://discord.gg/EzHu6tw5PQ)

## Requirements

- Windows 10 or Windows 11  
  - *(Tested on Windows 10 22H2 & Windows 11 24H2)*
  - *(32-bit, 64-bit and arm64 is supported)* 


### Sources and Contributions

<details>
  <summary>Click to Show</summary>

- **Base Answer File Generation**:
  - [Schneegans Unattend Generator](https://schneegans.de/windows/unattend-generator/)

</details>

### Key Features

- Windows 10/11 Pro is installed by default
  - *prompted to enable after Windows installation*
- Allows execution of PowerShell scripts by default
- Features
  - bypass the online account
  - bypass the Wi-Fi selection
  - bypass windows 11 requirements (tpm, secure boot, etc)
  - add the ability to Sign in with local account
  - Support Arm, amd/intel 64 bit, amd/intel 32 bit


- Apps preinstalled
  - Microsoft edge
  - terminal
  - notepad (modern)
  - media player (modern)
  - photos


- What else?
  - remove home & gallery from file Explorer
  - remove home page from settings

- Privacy Settings 
  - all are off expect microphone and camara 

**Made by Project**

**UnattendedWinstall version 1.0**

> [!NOTE] 
> You need to reboot your system after the first logon, so the UanttendedScript.ps1 can apply the necessary system changes.
