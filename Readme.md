# FixOs - The Ultimate Windows Optimization  🚀

**FixOs** is a PowerShell script designed to optimize and customize your Windows experience. <br> From software management to system optimizations and customization, FixOs provides functions to enhance Windows 10 and 11 systems.<br><br>**FixOs** features most of the same enhancements as [UnattendedWinstall](https://github.com/deadproject/UnattendedWinstall) without needing to do a clean install of Windows.

## Requirements 💻
- Windows 11
    - *Tested on Windows 11 24H2*
    - *Most things should work on Windows 10 22H2 but there are some issues*

## Usage Instructions 📜
To use **FixOs**, follow these steps to launch PowerShell as an Administrator and run the installation script:

1. **Open PowerShell as Administrator:**
     - **Windows 10/11**: Right-click on the **Start** button and select **Windows PowerShell (Admin)** or **Windows Terminal (Admin)**
     - PowerShell will open in a new window.

2. **Confirm Administrator Privileges**: 
     - If prompted by the User Account Control (UAC), click **Yes** to allow PowerShell to run as an administrator.

3. **Enable PowerShell Script Execution:**
     - Run the following command to allow script execution:
     ```powershell
     Set-ExecutionPolicy Unrestricted
     ```

4. **Paste and Run the Command**:
     - Copy the following command:
     ```powershell
     irm "https://github.com/deadproject/FixOs/raw/main/base.ps1" | iex
     ```
     - To paste into PowerShell, **Right-Click** or press **Ctrl + V** in the PowerShell or Terminal window
     - Press **Enter** to execute the command

This command will download and execute the **FixOs** application directly from GitHub.

## Current Features 🛠️

### Software & Apps 💿
- Install Software
- Remove Windows Apps (Permanently)
    - Microsoft Edge
    - OneDrive
    - Recall
    - Copilot
    - Other Useless Windows Bloatware 

### Optimize 🚀
- Set UAC Notification Level
- Disable or Enable Windows Security Suite
- Privacy Settings
- Gaming Optimizations
- Windows Updates
- Power Settings
- Scheduled Tasks
- Windows Services

### Customize 🎨
- Taskbar Customization
- Start Menu Settings
- Explorer Options
- Notification Preferences
- Sound Settings
- Accessibility Options
- Search Configuration
- And, More

### About ⓘ
- About FixOs
- Support Information
---
> [!NOTE]
> This tool is currently in development. Any issues can be reported using the Issues tab.<br>

## 📬 Get in Touch

Feel free to reach out to me for any questions, collaboration opportunities, or if you just want to talk about tech!

[![Join our Discord](https://img.shields.io/badge/Join_Our_Discord-7289DA?style=for-the-badge&logo=discord&logoColor=white)](https://discord.gg/EzHu6tw5PQ) 

<p>&copy; 2025 vDevhub,All Rights Reserved.</p>
