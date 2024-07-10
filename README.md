<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Winget Auto-Update Scheduler</title>
</head>
<body>
    <h1>Winget Auto-Update Scheduler</h1>
    <p>This script automates the addition of a task to the Task Scheduler, ensuring that <code>winget update</code> runs every time you log in. It's designed to keep your applications up-to-date effortlessly.</p>
    
    <h2>Features</h2>
    <ul>
        <li><strong>Automated Task Creation</strong>: Adds a scheduled task to run <code>winget update</code> at every login.</li>
        <li><strong>Centralized Configuration</strong>: Configuration files are stored in the <code>C:\\ProgramData\\Winget</code> folder for easy access and management.</li>
        <li><strong>Compatibility</strong>: Requires the WinRM service to be enabled for seamless operation.</li>
    </ul>
    
    <h2>Prerequisites</h2>
    <p><strong>Windows Remote Management (WinRM)</strong>: Ensure that the WinRM service is enabled on your system. This is necessary for the script to function correctly.</p>
    
    <h2>Installation</h2>
    <ol>
        <li>
            <strong>Enable WinRM Service</strong>:
            <p>Open PowerShell as Administrator and run:</p>
            <pre><code>Enable-PSRemoting -Force</code></pre>
        </li>
        <li>
            <strong>Download the Script</strong>:
            <p>Clone the repository or download the script directly.</p>
        </li>
        <li>
            <strong>Run the Script</strong>:
            <p>Execute the script with appropriate permissions to add the scheduled task.</p>
        </li>
    </ol>
    
    <h2>Usage</h2>
    <p>Once installed, the task will automatically run <code>winget update</code> every time you log in, keeping your applications up-to-date without manual intervention.</p>
    
    <h2>Configuration</h2>
    <p>All configuration files are located in the <code>C:\\ProgramData\\Winget</code> folder. You can modify these files to customize the behavior of the update process.</p>
    
</body>
</html>
