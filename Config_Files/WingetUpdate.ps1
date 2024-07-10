function Add-WinGetPath {
  $WinGetPath = (Get-ChildItem -Path "C:\Program Files\WindowsApps\Microsoft.DesktopAppInstaller*_x64*\winget.exe").DirectoryName
  If (-Not(($Env:Path -split ';') -contains $WinGetPath))
    { 
    If ($env:path -match ";$")
      {
        $env:path +=  $WinGetPath + ";"
      }
    else
      {
        $env:path +=  ";" + $WinGetPath + ";"			
      }
    write-host "Winget path $WinGetPath added to environment variable"
    }
  else
    { 
      write-host "Winget path already exists in registry."
    }
    }

Add-WinGetPath

# Create Winget Catalog
$logDirectory = "C:\ProgramData\Winget"
if (-Not (Test-Path -Path $logDirectory)) {
    New-Item -ItemType Directory -Path $logDirectory
}

# Winget Log Name
$computerName = $env:COMPUTERNAME
$logFile = "$logDirectory\Winget_$computerName.log"

# Funkcja do logowania
function Write-Log {
    param (
        [string]$message
    )
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    $logMessage = "$timestamp - $message"
    Add-Content -Path $logFile -Value $logMessage
}

Write-Log "Script started."

# Check if winget is installed
try {
    $wingetCheck = Get-Command winget -ErrorAction Stop
    Write-Log "winget is installed."
} catch {
    Write-Log "winget is not installed. Installing winget..."
    # Pobieranie i instalacja winget
    $wingetInstaller = "https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle"
    $tempPath = "$env:TEMP\Microsoft.DesktopAppInstaller.msixbundle"
    try {
        Write-Log "Downloading winget installer from $wingetInstaller..."
        Invoke-WebRequest -Uri $wingetInstaller -OutFile $tempPath -ErrorAction Stop
        Write-Log "winget installer downloaded to $tempPath."
        
        Write-Log "Installing winget..."
        Add-AppxPackage -Path $tempPath -ErrorAction Stop
        Remove-Item $tempPath
        Write-Log "winget installed successfully."
        Start-Sleep -Seconds 10  # break
    } catch {
        Write-Log "Error occurred during winget installation: $_"
        exit 1
    }
}

# Update
try {
    Write-Log "Updating programs using winget..."

    $upgradeOutput = winget upgrade --all --accept-source-agreements --silent --disable-interactivity --accept-package-agreements --force
    $updatedApps = $upgradeOutput | Select-String "Successfully upgraded"
    $failedApps = $upgradeOutput | Select-String "Failed to upgrade"   
    
    Write-Log "Programs updated successfully."
    foreach ($line in $upgradeOutput) {
    Write-Log "$line"

}
} catch {
    Write-Log "Error occurred during programs update: $_"
}

Write-Log "Script finished."
