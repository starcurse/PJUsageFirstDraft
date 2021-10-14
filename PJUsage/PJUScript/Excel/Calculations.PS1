#Assigning the entire workbook to a variable
$PJworkbook = "C:\Security\Results\UserUsage\UserUsage.xlsx"
#Opening Excel as a ComObject in PowerShell, disabling visual clutter to increase performance
$Excel = New-Object -ComObject excel.application
$Excel.ScreenUpdating = $false
$Excel.EnableEvents = $false
$Excel.DisplayStatusbar = $false
$Excel.Visible = $false
$Excel.DisplayAlerts = $false
#Assigning variables to important parts of the workbook
$Workbook = $Excel.Workbooks.Open($PJworkbook)
$Calculations = $Workbook.worksheets.item("Calculations")
#Importing RawData CSV and assigning it to the correct columns
$RawDataCSV = "C:\Security\Scripts\PJUsage\Temp\RawDataCSV.csv"
$RawDataData = Import-Csv -Path $RawDataCSV
$Calculations.Activate()
$LogonID = "Logon ID"
$UserAccount = "User Account"
$EntryType = "Entry Type"
$i = 2
foreach($process in $RawDataData) {
    $Calculations.cells.item($i,1) = $process.$LogonID
    $Calculations.cells.item($i,2) = $process.$UserAccount
    $Calculations.cells.item($i,3) = $process.Date
    $Calculations.cells.item($i,4) = $process.Time
    $Calculations.cells.item($i,5) = $process.$EntryType
    $i++
}
#Sorting Calculations worksheet by Logon ID
$SortRange = $Calculations.UsedRange 
$SortRange2 = $Calculations.Range("A2")
[void] $SortRange.Sort($SortRange2,1,$null,$null,1,$null,1,1)
#Inserting formula into every cell in Column F besides the header
$Calculations.Cells.Item(2,6).Formula = "=(IF(E2=`"Logon`",`"`",(D2-VLOOKUP(A2,`$A`$2:`$D2,4,FALSE))`*24))"
$rows = $Calculations.range("A1").currentregion.rows.count
$Calculations.range("F2:F$rows").formula = $Calculations.range("F2").formula 
#Examining each cell in F Column and deleting the entire row if cell is blank
$FCell = $Calculations.range("F2:F$rows")
$i = 2
foreach ($cell in $FCell) {
    $value = $Calculations.cells.item($i,6)
    if ($value.value2 -eq "") {
        $value.EntireRow.Delete()
     }
     $i++
}
$Workbook.Save()
#Exporting Calculations worksheet as a CSV
$CALCSV = "C:\Security\Scripts\PJUsage\Temp\CalculationCSV.csv"
$xlCSV = 6
$Calculations.SaveAs($CALCSV,$xlCSV)
$Excel.Quit()
#Opening a workbook with the proper settings configured
$AutomaticFormulaConfig = "C:\Security\Scripts\ExcelTemplates\AutomaticFormulaConfig.xlsx"
$Excel = New-Object -ComObject excel.application
$Excel.ScreenUpdating = $false
$Excel.EnableEvents = $false
$Excel.DisplayStatusbar = $false
$Excel.Visible = $false
$Excel.DisplayAlerts = $false
$Workbook = $Excel.Workbooks.Open($AutomaticFormulaConfig)
#Opening proper workbook with new settings
$Workbook = $Excel.Workbooks.Open($PJworkbook)
#Importing 
$CalcData = Import-Csv -Path $CALCSV
$UserAccount = "User Account"
$DailyResults = $Workbook.worksheets.item("Daily Results")
$DailyResults.Activate()
$i = 2
foreach($process in $CalcData) {
    $DailyResults.cells.item($i,1) = $process.Date
    $DailyResults.cells.item($i,2) = $process.$UserAccount
    $DailyResults.cells.item($i,3) = $process.Hours
    $i++
}
# Sorting Daily Results by Date
$rows = $DailyResults.range("A1").currentregion.rows.count
$SortRange = $DailyResults.UsedRange 
$SortRange2 = $DailyResults.Range("A2")  
[void] $SortRange.Sort($SortRange2,1,$null,$null,1,$null,1,1)
# Inserting formula into every cell in D column
$DailyResults.Cells.Item(2,4).Formula = "=SUMIF(B:B,B2,C:C)"
$rows = $DailyResults.range("A1").currentregion.rows.count
$DailyResults.range("D2:D$rows").formula = $DailyResults.range("D2").Formula
# Saving Daily Results as a CSV
$DResults = "C:\Security\Scripts\PJUsage\Temp\DailyResultsCSV.csv"
$DailyResults.SaveAs($DResults,$xlCSV)
$Excel.Quit()
# Importing DailyResults CSV into Total Results 
$Excel = New-Object -ComObject excel.application
$Excel.ScreenUpdating = $false
$Excel.EnableEvents = $false
$Excel.DisplayStatusbar = $false
$Excel.Visible = $false
$Excel.DisplayAlerts = $false
$Workbook = $Excel.Workbooks.Open($PJworkbook)
$DResultsData = Import-Csv -Path $DResults
$TotalHours = "Total Hours"
$TotalResults = $Workbook.worksheets.item("Total Results")
$TotalResults.Activate()
$i = 2
foreach($process in $DResultsData) {
    $TotalResults.cells.item($i,1) = $process.Username
    $TotalResults.cells.item($i,2) = $process.$TotalHours
    $i++
}
#Deleting duplicate columns
$TRUsedColumns = 1,2
$TotalResults.UsedRange.RemoveDuplicates($TRUsedColumns)
#Enabling visual clutter for users when they use excel again
$Excel.ScreenUpdating = $true
$Excel.EnableEvents = $true
$Excel.DisplayStatusbar = $true
#Saving workbook and quitting excel
$Workbook.Save()
$Excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Excel)