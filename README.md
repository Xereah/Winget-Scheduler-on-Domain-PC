<b>Winget Auto-Update Scheduler</b>
This script automates the addition of a task to the Task Scheduler, ensuring that winget update runs every time you log in. It's designed to keep your applications up-to-date effortlessly.

Features
Automated Task Creation: Adds a scheduled task to run winget update at every login.
Centralized Configuration: Configuration files are stored in the C:\\ProgramData\Winget folder for easy access and management.
Compatibility: Requires the WinRM service to be enabled for seamless operation.
Prerequisites
Windows Remote Management (WinRM): Ensure that the WinRM service is enabled on your system. This is necessary for the script to function correctly.
Installation
Enable WinRM Service:
Open PowerShell as Administrator and run:

powershell:
Enable-PSRemoting -Force

Download the Script:
Clone the repository or download the script directly.

Run the Script:
Execute the script with appropriate permissions to add the scheduled task.

Usage
Once installed, the task will automatically run winget update every time you log in, keeping your applications up-to-date without manual intervention.

Configuration
All configuration files are located in the C:\\ProgramData\Winget folder. You can modify these files to customize the behavior of the update process.
