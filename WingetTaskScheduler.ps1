Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Function to create a form
function WingetAddToScheduler {
    # Create application window
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Remote Computer Installation"
    $form.Size = New-Object System.Drawing.Size(500, 500) # Increase form size
    $form.StartPosition = "CenterScreen"
    
    $labelInformation = New-Object System.Windows.Forms.Label
    $labelInformation.Location = New-Object System.Drawing.Point(10, 20)
    $labelInformation.Size = New-Object System.Drawing.Size(420, 40)
    $labelInformation.Text = "Enabling WinRM service"
    $labelInformation.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold) # Set font to Arial, size 12, bold
    $labelInformation.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter # Center text
    $form.Controls.Add($labelInformation)
    
    # Text field for entering the remote computer name
    $labelRemoteComputer = New-Object System.Windows.Forms.Label
    $labelRemoteComputer.Location = New-Object System.Drawing.Point(10, 70)
    $labelRemoteComputer.Size = New-Object System.Drawing.Size(200, 20)
    $labelRemoteComputer.Font = New-Object System.Drawing.Font("Arial", 12, [System.Drawing.FontStyle]::Bold) # Set font to Arial, size 10, bold
    $labelRemoteComputer.Text = "Remote Computer Name:"
    $form.Controls.Add($labelRemoteComputer)
    
    $textboxRemoteComputer = New-Object System.Windows.Forms.TextBox
    $textboxRemoteComputer.Location = New-Object System.Drawing.Point(210, 70)
    $textboxRemoteComputer.Size = New-Object System.Drawing.Size(200, 20)
    $form.Controls.Add($textboxRemoteComputer)

    # TextBox for displaying errors
    $TextBoxErrors = New-Object System.Windows.Forms.TextBox
    $TextBoxErrors.Location = New-Object System.Drawing.Point(10, 240)  # Changed from (10, 190) to (10, 210)
    $TextBoxErrors.Size = New-Object System.Drawing.Size(450, 200)
    $TextBoxErrors.Multiline = $true  # Enable multiline text box
    $TextBoxErrors.ScrollBars = "Vertical"  # Add vertical scrollbar
    $form.Controls.Add($TextBoxErrors)

    $labelInformationError = New-Object System.Windows.Forms.Label
    $labelInformationError.Location = New-Object System.Drawing.Point(10, 200)
    $labelInformationError.Size = New-Object System.Drawing.Size(420, 40)
    $labelInformationError.Text = "Information:"
    $labelInformationError.Font = New-Object System.Drawing.Font("Arial", 12,  [System.Drawing.FontStyle]::Bold) # Set font to Arial, size 12, bold
    $labelInformationError.TextAlign = [System.Drawing.ContentAlignment]::MiddleCenter # Center text
    $form.Controls.Add($labelInformationError)
    
    # Button for remote computer installation
    $buttonInstall = New-Object System.Windows.Forms.Button
    $buttonInstall.Location = New-Object System.Drawing.Point(10, 110)  # Changed from (10,250) to (10, 270)
    $buttonInstall.Size = New-Object System.Drawing.Size(460, 65)
    $buttonInstall.BackColor = [System.Drawing.Color]::LightGray
    $buttonInstall.Font = New-Object System.Drawing.Font("Arial", 12,  [System.Drawing.FontStyle]::Bold) # Set font to Arial, size 12, bold
    $buttonInstall.Text = "Add Winget Task do TaskScheduler"
    $buttonInstall.Add_Click({
            # Get data from text fields
            $remoteComputer = $textboxRemoteComputer.Text
            $TextBoxErrors.Text = ""

            if (-not (Test-Connection -ComputerName $remoteComputer -Count 1 -Quiet)) {
                # Computer is not accessible, display info and stop script
                $TextBoxErrors.Text = "Computer $remoteComputer is not accessible on the network.`r`n"
                return
            }  
            # Define path to local file
            $localFile = Join-Path $PSScriptRoot "Config_Files\WingetUpdate.ps1"
            $localFile1 = Join-Path $PSScriptRoot "Config_Files\Start_Winget.bat"
        
            # Create "Service" folder on domain computer
            try {
                New-Item -Path "\\$remoteComputer\c$\ProgramData\Winget"-ItemType Directory -Force -ErrorAction Stop
            }
            catch {
                $TextBoxErrors.Text = "Error creating folder on remote computer $remoteComputer $_`r`n"
                return
            }

            # Copy file from local computer to remote computer
            try {
                Copy-Item -Path $localFile -Destination "\\$remoteComputer\c$\ProgramData\Winget" -Force
                Copy-Item -Path $localFile1 -Destination "\\$remoteComputer\c$\ProgramData\Winget" -Force
            }
            catch {
                $TextBoxErrors.Text = "Error copying file to remote computer $remoteComputer $_`r`n"
                return
            }
            try {
                Invoke-Command -ComputerName $remoteComputer -Credential $env:USERNAME -ScriptBlock {
                    param($localScript, $localScript1)
    
                    # Remove existing task
                   if (Get-ScheduledTask -TaskName "StartWinget" -ErrorAction SilentlyContinue) {
                        Unregister-ScheduledTask -TaskName "StartWinget" -Confirm:$false
                    }
    
                    # Create task trigger
                    $Trigger = New-ScheduledTaskTrigger -Daily -At "10:15"
                    #$Trigger = New-ScheduledTaskTrigger -Once -At (Get-Date).AddMinutes(1) 
    
                    # Create task action
                    $Action = New-ScheduledTaskAction -Execute "PowerShell" -Argument "C:\ProgramData\Winget\Start_Winget.bat"
    
                    # Create task principal
                    $Principal = New-ScheduledTaskPrincipal -UserId "NT AUTHORITY\SYSTEM" -LogonType ServiceAccount
    
                    # Add AllowStartIfOnBatteries and DontStopIfGoingOnBatteries settings
                    $Settings = New-ScheduledTaskSettingsSet -AllowStartIfOnBatteries -DontStopIfGoingOnBatteries
    
                    # Register new task with added settings
                    Register-ScheduledTask -TaskName "StartWinget" -Trigger $Trigger -Action $Action -Principal $Principal -Settings $Settings
                } -ArgumentList $localFile, $localFile1
                $TextBoxErrors.Text += "Script successfully run on remote computer."
            } 
            catch {
                $TextBoxErrors.Text += "Error occurred: $_`r`n"
                return
            }

            # Capture console errors
            if ($error) {
                $TextBoxErrors.Text += "Error occurred: $($error[0])`r`n"
                $error.Clear()
                return
            }

        }      
    )
    $form.Controls.Add($buttonInstall)
    
    # Run application
    $form.ShowDialog() | Out-Null
}

# Call function to create form
WingetAddToScheduler
