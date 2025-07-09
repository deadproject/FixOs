# **Uw-FixOs**

![Uw-FixOs Logo](https://github.com/deadproject/UnattendedWinstall/blob/main/Wallpaper.png?raw=true)

**UnattendedWinstall** is a Windows automation tool that leverages Microsoft's Answer Files to customize and streamline Windows installations. This tool allows for deep system configurations during installation, including a host of optimizations, privacy adjustments, and more. 

Additionally, **FixOs** is now part of the UnattendedWinstall project, enhancing the post-installation experience by applying various fixes to ensure a smoother and more efficient Windows environment.

---

### **Key Features**

#### **UnattendedWinstall**:
- **Windows Edition Selection:** You can select the preferred Windows edition (no longer restricted to Pro).
- **PowerShell Scripts:** Automatically run custom PowerShell scripts during installation to configure the system further.
- **Bypass Setup Requirements:**
  - Skip online account setup.
  - Skip Wi-Fi setup.
  - Bypass Windows 11 hardware checks (TPM, Secure Boot, etc.).
- **System Optimization:**
  - Disable telemetry through registry tweaks.
  - Enable the **Ultimate Performance** power plan for high-performance tasks.
  - Configure Windows services for optimal performance and minimal background processes.
  - Limit Windows Updates to only security updates for two years.
- **Pre-installed Apps:** 
  - Microsoft Store
  - Microsoft Edge
  - Modern Notepad
  - Modern Media Player
  - Photos App
- **File Explorer Tweaks:**
  - Remove Home and Gallery from the File Explorer view.
  - Remove the Home page from Windows Settings.
  - Open File Explorer to This PC instead of Quick access.

#### **FixOs Integration**:
FixOs brings a set of post-installation tweaks to further refine the user experience. Some of the key features of FixOs include:
- **Privacy Enhancements:** Further reduces telemetry, disables unneeded background services, and ensures the system runs with minimal data collection.
- **Performance Tweaks:** Applies additional settings to optimize startup times, reduce bloatware, and fine-tune Windows performance for efficiency.
- **Security Fixes:** Patches common system vulnerabilities, ensuring the system stays secure with minimal intervention.

---

### **Installation Instructions**

#### **Method 1: Create a Bootable Windows Installation USB**
1. **Download `autounattend.xml`:** Download the preferred `autounattend.xml` configuration file from the project repository.
2. **Create a Bootable Windows USB:**
   - Use [Rufus](https://rufus.ie/en/) or the [Media Creation Tool](https://www.microsoft.com/en-us/software-download/windows10) to create a bootable USB drive.
   - **Important:** Avoid selecting any checkboxes in the "Customize Your Windows Experience" section when using Rufus to prevent overwriting your settings.
3. **Copy `autounattend.xml`** to the root of your USB.
4. **Install Windows:** Boot from the USB and perform a clean Windows installation. The scripts will run automatically during setup.

#### **Method 2: Create a Custom Windows ISO**
1. **Download `autounattend.xml`:** Download the `autounattend.xml` from the repository.
2. **Download the Official Windows ISO** from Microsoft for your desired version.
3. **Modify the ISO:**
   - Use [AnyBurn](https://anyburn.com/download.php) to add `autounattend.xml` to the root of the ISO.
4. **Create a Bootable USB:** Use [Rufus](https://rufus.ie/en/) or [Ventoy](https://github.com/ventoy/Ventoy) to make a bootable USB from the edited ISO.
5. **Install Windows:** Boot from the USB and complete the installation. The script will run automatically.

---

### **Additional Notes**
- **Tested Versions:**
  - Windows 10 (Tested on 22H2)
  - Windows 11 (Tested on 24H2)
  - Supports 32-bit, 64-bit, and ARM architectures.

---

### **Feedback & Community**

If you have any questions, feedback, or suggestions, feel free to join our community on [Discord](https://discord.gg/EzHu6tw5PQ) or participate in the discussions on [GitHub](https://github.com/deadproject/UnattendedWinstall/discussions).

---

### **Contributors & Sources**
- **Base Answer File Generator:** [Schneegans Unattend Generator](https://schneegans.de/windows/unattend-generator/)
- **FixOs Integration:** A collection of post-installation fixes to improve Windows performance and security.
