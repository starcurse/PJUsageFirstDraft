$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"
$Logins = C:\Security\Scripts\PJUsage\PJUScript\LogParsing\GetLoginEvents.PS1
$Logoffs = C:\Security\Scripts\PJUsage\PJUScript\LogParsing\GetLogoffEvents.PS1
try {
$Logins
$Success = $true
} Catch {
    Write-OutPut "Error running GetLoginEvents script on $timestamp" | Out-File -FilePath C:\Security\Results\UserUsage\Logs\Errorlog.txt -Append
    $Success = $false
}
try {
    $Logoffs
    $Success = $true
} Catch {
    Write-OutPut "Error running GetLogoffEvents script on $timestamp" | Out-File -FilePath C:\Security\Results\UserUsage\Logs\Errorlog.txt -Append
    $Success = $false
}
if ($Success -eq $true) {
    Write-Host "Success"
} else {
    Write-Host "A problem occured, check C:\Security\Results\UserUsage\Logs\Errorlog.txt for more details."
}