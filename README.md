<h2>Winget Auto-Update Scheduler</h2>

This script automates the addition of a task to the Task Scheduler, ensuring that winget update runs every time you log in. It's designed to keep your applications up-to-date effortlessly.

<b>Features</b><br>
<li>Automated Task Creation: Adds a scheduled task to run winget update at every login.</li>
<li>Centralized Configuration: Configuration files are stored in the C:\\ProgramData\Winget folder for easy access and management.</li><br>
<li>Compatibility: Requires the WinRM service to be enabled for seamless operation.</li><br>
<b>Prerequisites</b><br>
<li>Windows Remote Management (WinRM): Ensure that the WinRM service is enabled on your system. This is necessary for the script to function correctly.</li><br>
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
    
