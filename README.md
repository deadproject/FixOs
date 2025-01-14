# Project's Unattended Windows installation

## Introduction

UnattendedWinstall leverages Microsoft's [Answer Files](https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/update-windows-settings-and-scripts-create-your-own-answer-file-sxs?view=windows-11) (or Unattend files) to automate and customize Windows installations. It enables modifications to Windows Settings and Packages directly in the Windows ISO during setup.
**!Note**
This is Answer file Created by Project,its just Verison of Memory tech tips for my personal use

### Why Use an Answer File?

#### Security

- Provides transparency by allowing inspection of all changes in the answer file.
- Runs directly on official Windows ISOs from Microsoft, eliminating the need for unofficial sources.
- Utilizes a Microsoft-supported feature designed for streamlined mass deployment of Windows installations.

#### Automation

- Enables automated configuration across multiple devices, saving time and effort by eliminating repetitive manual setups.

### Versions

[![Version 2 Release (Latest)](https://img.shields.io/badge/Version-1.1.0%20Latest-0078D4?style=for-the-badge&logo=github&logoColor=white)](https://github.com/deadproject/UnattendedWinstall/releases/tag/v1.1.0)
[![Version 1 Release](https://img.shields.io/badge/Version-1.0.0-FFA500?style=for-the-badge&logo=github&logoColor=white)](https://github.com/deadproject/UnattendedWinstall/releases/tag/v1.0.0)


> [!NOTE] 
> UnattendedWinstall has been tested and optimized for personal use. For those interested in customizing further, [create your own answer file](https://schneegans.de/windows/unattend-generator/) 
> This answer file was created for my personal use, based on Schneegans' project and inspired by [Memory Tech Tips Answer File](https://github.com/memstechtips/UnattendedWinstall)

## <ins>**Installing Windows with an Answer File**</ins>
In short, you need to include the `autounattend.xml` answer file on your Windows Installation Media so it can be read and executed during the Windows Setup. Here are a few ways to do it:

> [!NOTE]<br/>
> - The filename included on the root of the Windows Installation Media must be `autounattend.xml` or else it won't execute.
<br/>

### <ins>Method 1: Create a Bootable Windows Installation Media</ins>

1. Download your preferred `autounattend.xml` file and save it on your computer.
2. Create a [Windows 10](https://www.microsoft.com/en-us/software-download/windows10) or [Windows 11](https://www.microsoft.com/en-us/software-download/windows11) Bootable Installation USB drive with [Rufus](https://rufus.ie/en/) or the Media Creation Tool. 
> [!IMPORTANT]<br/>
> - Some users have reported issues with the Media Creation Tool when creating the Windows Installation USB. Use it at your own discretion. <br/>
> - When using Rufus, don’t select any of the checkboxes in “Customize Your Windows Experience” as it creates another `autounattend.xml` file that might overwrite settings in the UnattendedWinstall file.
3. Copy the `autounattend.xml` file you downloaded in Step 1 to the root of the Bootable Windows Installation USB you created in Step 2.
4. Boot from the Windows Installation USB, do a clean install of Windows as normal, and the scripts will run automatically.
</br>

### <ins>Method 2: Create a Custom ISO File</ins> 

1. Download your preferred `autounattend.xml` file and save it on your computer.
2. Download the [Windows 10](https://www.microsoft.com/en-us/software-download/windows10) or [Windows 11](https://www.microsoft.com/en-us/software-download/windows11) ISO file depending on the version you want.
3. Download and Install [AnyBurn](https://anyburn.com/download.php)
   - In AnyBurn, select the “Edit Image File” option.
   - Navigate to and select the Official Windows ISO file you downloaded in Step 2.
   - Click on “Add” and select the `autounattend.xml` file you downloaded in Step 1 or just click and drag the `autounattend.xml` into the AnyBurn window.
   - Click on “Next,” then on “Create Now.” You should be prompted to overwrite the ISO file, click on “Yes.”
   - Once the process is complete, close AnyBurn.
4. Use the ISO file to Install Windows on a Virtual Machine OR use a program like [Rufus](https://rufus.ie/en/) or [Ventoy](https://github.com/ventoy/Ventoy) to create a bootable USB flash drive with the edited Windows ISO file.
> [!IMPORTANT]<br/>
> - When using Rufus, don’t select any of the checkboxes in “Customize Your Windows Experience” as it creates another `autounattend.xml` file that might overwrite settings in the UnattendedWinstall file.
5. Boot from the Windows Installation USB, do a clean install of Windows as normal, and the scripts will run automatically.
</br>


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

- Ability to choose Windows Edition (Pro is not enforced anymore as in v1.0.0)
- Allows execution of PowerShell scripts by default
- bypass the online account
- bypass the Wi-Fi selection
- bypass windows 11 requirements (tpm, secure boot, etc)
- add the ability to Sign in with local account
- Sets privacy-related registry keys to disable telemetry
- Configures Windows services for optimal performance
- Enables the Ultimate Performance power plan
- Limits Windows Update to install only security updates for two year
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

**Made by Project**

**UnattendedWinstall**

> [!NOTE] 
> You need to reboot your system after the first logon, so the UanttendedScript.ps1 can apply the necessary system changes.
