#Variables
$PJVerification = "C:\Security\Scripts\PJUsage\Config\PJUsageVerification.txt"
$Verification = "C:\Security\Scripts\Configuration\Verification.txt"
$Template = "C:\Security\Scripts\ExcelTemplates\UsageTemplate.xlsx"
$PCisConfigured = Test-Path -Path $Verification
$ScriptisConfigured = Test-Path -Path $PJVerification
$TemplateExists = Test-Path -Path $Template
$PJworkbook = "C:\Security\Results\UserUsage\UserUsage.xlsx"
$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"

try {
  if ($PCisConfigured -eq $true) {write-host "Configuration has already occured." -ForegroundColor Green} else {
  write-host "Performing configuration now." -ForegroundColor Yellow
  write-host "Creating folders and files..."
  New-Item -Path "C:\Security\Scripts\" -ItemType "Directory"
  New-Item -Path "C:\Security\Scripts\ExcelTemplates" -ItemType "Directory"
  New-Item -Path "C:\Security\Scripts\Configuration" -ItemType "Directory"
  New-Item -Path "C:\Security\Scripts\Logs" -ItemType "Directory"
  New-Item -Path "C:\Security\Scripts\Logs\GeneralErrors.txt"
  New-Item -Path "C:\Security\Results" -ItemType "Directory"
  New-Item -Path $Verification
}
} Catch {
  Write-OutPut "Error setting up PCconfiguration on $timestamp" | Out-File -FilePath C:\Security\Scripts\Logs\GeneralErrors.txt -Append
}
try {
  if ($ScriptisConfigured -eq $true) {write-host "Configuration has already occured." -ForegroundColor Green} else {
  New-Item -Path "C:\Security\Results\UserUsage" -ItemType "Directory"
  New-Item -Path "C:\Security\Results\UserUsage\Logs" -ItemType "Directory"
  New-Item -Path "C:\Security\Results\UserUsage\Logs\Errorlog.txt"
  Move-Item -Path C:\PJUsage -Destination C:\Security\Scripts
  Move-Item -Path C:\Security\Scripts\PJUsage\UsageTemplate.xlsx -Destination C:\Security\Scripts\ExcelTemplates\UsageTemplate.xlsx
  Move-Item -Path C:\SetupScript.PS1 -Destination C:\Security\Scripts\PJUsage\PJUScript\Setup\SetupScript.PS1
  New-Item -Path $PJVerification
}
} Catch {
  Write-OutPut "Error setting up Script Configuration on $timestamp" | Out-File -FilePath C:\Security\Scripts\Logs\GeneralErrors.txt -Append
}
try {
  if ($TemplateExists -eq $true) {write-host "Template already exists." -ForegroundColor Green} else {
  Copy-Item -Path "$Template" -Destination "$PJworkbook"
}
} Catch {
  Write-OutPut "Error setting up Template on $timestamp" | Out-File -FilePath C:\Security\Scripts\Logs\GeneralErrors.txt -Append
}