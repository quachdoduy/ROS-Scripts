# ROS-Scripts
Router-OS Script (Mikrotik) project for Crossian.

[![Lang EN](https://img.shields.io/badge/lang-en-green)](https://github.com/quachdoduy/ROS-Scripts/blob/main/README.md)
[![Lang VI](https://img.shields.io/badge/lang-vi-yellow)](https://github.com/quachdoduy/Mikrotik-RouterOS-Script/blob/main/README.vi.md)<br/>
[![GitHub stars](https://img.shields.io/github/stars/quachdoduy/ROS-Scripts?logo=GitHub&style=flat&color=red)](https://github.com/quachdoduy/ROS-Scripts/stargazers)
[![GitHub watchers](https://img.shields.io/github/watchers/quachdoduy/ROS-Scripts?logo=GitHub&style=flat&color=blue)](https://github.com/quachdoduy/ROS-Scripts/watchers)<br/>
[![donate with paypal](https://img.shields.io/badge/Like_it%3F-Donate!-green?logo=githubsponsors&logoColor=orange&style=flat)](https://paypal.me/quachdoduy)
[![donate with buymeacoffe](https://img.shields.io/badge/Like_it%3F-Donate!-blue?logo=githubsponsors&logoColor=orange&style=flat)](https://buymeacoffee.com/quachdoduy)

>If you have any script ideas or just want to share your opinion, you can [Discuss here](https://github.com/quachdoduy/ROS-Scripts/discussions/), or open an [Issue](https://github.com/quachdoduy/ROS-Scripts/issues) if you find any errors.

# TABLE OF CONTENTS
- [Table of Contents](#table-of-contents)
- [Original idea](#original-idea)
- [Features](#features)
- [System requirements](#system-requirements)
- [Initial setup](#initial-setup)
    - [Pre-Installation](#pre-installation)
    - [Installation](#installation)
- [Next Stage](#next-stage)

# Original idea
- Automate the monitoring of WAN connections of the device and send alerts to Telegram and Slack.
- Write scripts with a centralized and reusable approach for smaller individual scripts.

# Features
- Notification Channels (Selectable)
    - **Email Notification**: Sends alerts to a configured email.
    - **Telegram Notification**: Sends alerts to a configured Telegram account.
    - **Webhook Notification**: Sends alerts to a configured webhook. Webhooks are widely used as many applications use them as a data gateway before processing.
- Logging
    - Logs all operations performed on the device for future tracking.
- System Health Monitoring
    - WAN Connection Status: Monitors the connection status of WAN interfaces.
    - Power Supply Units (PSUs) Status: Checks the status of power sources.
    - Performance Monitoring:
        - CPU Load: Alerts when CPU usage > 80%.
        - RAM Usage: Alerts when RAM usage > 75%.
        - HDD Usage: Alerts when storage usage > 65%.
        - Temperature Monitoring:
            - CPU & Mainboard Temperature:
                - Warning: 60-75°C
                - Alarm: Above 75°C
    *All alerts include an audible "beep" warning from the mainboard speaker.*
- Device Startup
    - Notifies about the device startup process.
    - Backs up the device configuration.
    - Reboots the device.

# System requirements
1. Software
    - RouterOS
    The script was written for RouterOS'7.n' (specifically RouterOS'7.15.2'). Ensure backward compatibility with RouterOS'6.n' and lower versions.
    - The script was written in Microsoft's Visual Code with compatible extensions.
        - [Visual Code](https://code.visualstudio.com/download)
        - [Extensions](https://github.com/devMikeUA/vscode_mikrotik_routeros_script)
2. Hardware
The script may increase in size with updates. Be cautious with devices having 16MB or lower storage.
*Configuration files may grow over time, so regular monitoring is recommended.*

# Initial setup
## Pre-Installation
Information to prepare before installation.
1. **Organization Short Name**: Stored in the variable **varCustomName**
    - Example: `:global varCustomName "Customer ABC XYZ";`
2. **Notification Methods**: Stored in the array **arrSendNotify**
    - Example: `:global arrSendNotify {"email";"telegram";"webhook"};`
    - *Settings for each alert method will be configured in* **GlobalConfig.rsc**.
3. **WAN Monitoring Configuration**:
    - Number of WANs: **arrWANname**
        - Example: `:global arrWANname {"WAN-1";"WAN-2"};`
    - WAN Interface Names: **arrWANinterface**
        - Example: `:global arrWANinterface {"pppoe-out1";"pppoe-out2"};`
    - WAN Next-Hop IPv4 Addresses: **arrWANnexthop**
        - Example: `:global arrWANnexthop {"8.8.8.8";"8.8.4.4"};`
4. **Power Supply Monitoring Configuration**:
    - Number of PSUs: **arrPSUname**
        - Example: `:global arrPSUname {"PSU-1";"PSU-2"};`
    - PSU Health IDs in SystemHealth Table: **arrPSUhealthID**
        - Example: `:global arrPSUhealthID {"8";"9"};`
5. **Temperature Monitoring Configuration**:
    - Number of Temperature Sources: **arrTemperature**
        - Example: `:global arrTemperature {"Board-Temperature";"CPU-Temperature";"Switch-Temperature"};`
    - Temperature Sensor IDs in SystemHealth Table: **arrTemperatureID**
        - Example: `:global arrTemperatureID {"7";"0";"1"};`
## Installation
- Configure basic network settings on the router with a chosen IP, ensuring file transfer capability.
- Upload **InitialSetup.rsc** and import it using: `/import InitialSetup.rsc`
- Update and save the configurations in the **GlobalConfig** script.
- Execute the script to update environment variables: `/system/script/run GlobalConfig;`

# Next Stage
- **First-Run Check Function**: Ensures a status check after each reboot. **(Done: 10/Feb/2025)**
- **Initial Auto-Scheduler Setup**: **(Done: 10/Feb/2025)**
- Enhanced Configuration Update Function: Minimizes direct script modifications.

*[Back to Top](#ros-scripts)*