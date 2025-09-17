# **FixOs**

![FixOs Logo](https://github.com/deadproject/FixOs/blob/main/FixOs-Standard/Wallpaper.png?raw=true)

---

## 🚀 Big Update: Now Available in Two Versions!

FixOs has received a major update! It now comes in **two powerful versions** to meet different needs:

- 🎯 **FixOs Standard** – Balanced performance, modern UI, and core apps.
- 🛠️ **FixOs-LTS** – Optimized for minimalism, speed, and long-term performance with reduced background processes and telemetry.

---

## 📎 Quick Access

[![FixOs Standard](https://img.shields.io/badge/FixOs-Standard-blue?style=for-the-badge&logo=windows)](https://github.com/deadproject/FixOs/blob/main/FixOs-Standard/README.md)  
[![FixOs-LTS](https://img.shields.io/badge/FixOs-LTS-orange?style=for-the-badge&logo=windows)](https://github.com/deadproject/FixOs/blob/main/FixOs-Lts/README.md)

---

## 🧩 Installation Instructions

> 📝 The installation method is the **same** for both **FixOs Standard** and **FixOs-LTS**.

### 💽 Method 1: Create a Bootable USB (Recommended)

1. **Download `autounattend.xml`**  
   Get the desired configuration file from this repository.

2. **Create a Bootable USB Drive**
   - Use [Rufus](https://rufus.ie/en/) or the [Media Creation Tool](https://www.microsoft.com/en-us/software-download/windows10) to create a Windows USB.
   - ⚠️ **Important:** Do not enable any "Customize Windows Experience" options in Rufus to avoid overwriting FixOs settings.

3. **Copy `autounattend.xml`**  
   Place the file in the **root directory** of your USB drive.

4. **Boot & Install**  
   Boot from the USB and proceed with a **clean Windows installation**. The setup will run automatically based on the selected FixOs version.

---

### 📀 Method 2: Create a Custom ISO

1. **Download `autounattend.xml`**  
   Get it from the repository.

2. **Download an Official Windows ISO**  
   Download from Microsoft’s website for your target version (Windows 10/11).

3. **Inject the Unattend File**
   - Use [AnyBurn](https://anyburn.com/download.php) or similar tool to **add `autounattend.xml`** to the **root** of the ISO.

4. **Create Bootable USB**
   - Use [Rufus](https://rufus.ie/en/) or [Ventoy](https://github.com/ventoy/Ventoy) to burn the edited ISO to a USB drive.

5. **Boot & Install**  
   Boot from USB and proceed with installation. The script will run automatically.

---

## ✅ Supported & Tested Versions

FixOs works with both **Windows 10** and **Windows 11**, across various architectures:

- 🧪 **Windows 10:** Tested on **22H2**
- 🧪 **Windows 11:** Tested on **24H2**
- 💻 Supports **32-bit**, **64-bit**, and **ARM** builds

---

## 📬 Feedback & Community

We’d love to hear your thoughts! If you have questions, suggestions, or feedback:

- 💬 Join the [FixOs Discord](https://discord.gg/EzHu6tw5PQ)
- 📢 Start a thread in [GitHub Discussions](https://github.com/deadproject/FixOs/discussions)

---

## 🙌 Contributors & Sources

- 🛠️ **Unattended XML Generator:** [Schneegans Unattend Generator](https://schneegans.de/windows/unattend-generator/)
- 🧩 **FixOs Integration:** Developed with a curated set of tweaks for performance, privacy, and usability.

---

> 👨‍💻 Made with ❤️ by the FixOs Team
