$timestamp = Get-Date -Format "MM/dd/yyyy HH:mm"
$AddToExcel = C:\Security\Scripts\PJUsage\PJUScript\Excel\AddToExcel.PS1
$Calculations = C:\Security\Scripts\PJUsage\PJUScript\Excel\Calculations.PS1
try {
$AddToExcel
$Success = $true
} Catch {
    Write-OutPut "Error running AddToExcel script on $timestamp" | Out-File -FilePath C:\Security\Results\UserUsage\Logs\Errorlog.txt -Append
    $Success = $false
}
try {
    $Calculations
    $Success = $true
} Catch {
    Write-OutPut "Error running Calculations script on $timestamp" | Out-File -FilePath C:\Security\Results\UserUsage\Logs\Errorlog.txt -Append
    $Success = $false
}
if ($Success -eq $true) {
    Write-Host "Success"
} else {
    Write-Host "A problem occured, check C:\Security\Results\UserUsage\Logs\Errorlog.txt for more details."
}