#Assigning variables to important files
$Template = "C:\Security\Scripts\ExcelTemplates\PJUTemplate.xlsx"
$PJworkbook = "C:\Security\Results\UserUsage\UserUsage.xlsx"
$csvLogin = "C:\Security\Scripts\PJUsage\Temp\LoginEvents.csv"
$csvLogoff = "C:\Security\Scripts\PJUsage\Temp\LogoffEvents.csv"
$LoginData = Import-Csv -Path $csvLogin
$LogoffData = Import-Csv -Path $csvLogoff
$WorkbookExists = Test-Path -Path "$PJworkbook"
#Testing for existence of the excel workbook, if it doesn't exist then a new workbook is created
if ($WorkbookExists -eq $false) {
    Copy-Item -Path "$Template" -Destination "$PJworkbook"
}
#Opening Excel as a ComObject in PowerShell, disabling visual clutter to increase performance
$Excel = New-Object -ComObject excel.application
$Excel.ScreenUpdating = $false
$Excel.EnableEvents = $false
$Excel.DisplayStatusbar = $false
$Excel.Visible = $false
$Excel.DisplayAlerts = $false
#Assigning variables to important parts of the workbook
$Workbook = $Excel.Workbooks.Open($PJworkbook)
$RawData = $Workbook.worksheets.item("Raw Data")
#Creating headers in excel
$RawData.cells.item(1,1) = "User Account"
$RawData.cells.item(1,2) = "Entry Type"
$RawData.cells.item(1,3) = "Computer Name"
$RawData.cells.item(1,4) = "User Domain"
$RawData.cells.item(1,5) = "Date"
$RawData.cells.item(1,6) = "Time"
$RawData.cells.item(1,7) = "Logon Type"
$RawData.cells.item(1,8) = "Logon ID"
$i = 2
#Looping through the worksheet and inputting relevant data from Login CSV where required
foreach($process in $LoginData) {
 $RawData.cells.item($i,1) = $process.UserAccount
 $RawData.cells.item($i,2) = $process.EntryType
 $RawData.cells.item($i,3) = $process.ComputerName
 $RawData.cells.item($i,4) = $process.UserDomain
 $RawData.cells.item($i,5) = $process.Date
 $RawData.cells.item($i,6) = $process.Time
 $RawData.cells.item($i,7) = $process.LogonType
 $RawData.cells.item($i,8) = $process.LogonID
 $i++
}
#Looping through the worksheet and inputting relevant data from Logoff CSV where required
foreach($process in $LogoffData) {
    $RawData.cells.item($i,1) = $process.UserAccount
    $RawData.cells.item($i,2) = $process.EntryType
    $RawData.cells.item($i,3) = $process.ComputerName
    $RawData.cells.item($i,4) = $process.UserDomain
    $RawData.cells.item($i,5) = $process.Date
    $RawData.cells.item($i,6) = $process.Time
    $RawData.cells.item($i,7) = $process.LogonType
    $RawData.cells.item($i,8) = $process.LogonID
    $i++
   }
# Saving workbook
$Workbook.Save()
# Enabling visual clutter for users when they use excel again
$Excel.ScreenUpdating = $true
$Excel.EnableEvents = $true
$Excel.DisplayStatusbar = $true
# Exporting RawData as a CSV 
$RawDataCSV = "C:\Security\Scripts\PJUsage\Temp\RawDataCSV.csv"
$xlCSV = 6
$RawData.SaveAs($RawDataCSV,$xlCSV)
# Quitting Excel
$Excel.Quit()