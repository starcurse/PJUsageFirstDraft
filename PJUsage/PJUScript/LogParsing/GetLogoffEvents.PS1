Function Get-LogoffEvents {
    Param (
        [Parameter(
            ValueFromPipeline = $true,
            ValueFromPipelineByPropertyName = $true
        )]
        [Alias('Name')]
        [string]$ComputerName = $env:ComputerName
        ,
        [datetime]$StartTime
        ,
        [datetime]$EndTime
    )
    Begin {
        $UserLogoffs = @{
            LogName = 'Security'
            ID = 4634,4647
        } 
        $EIDLO = if ($UserLogoffs.ID = 4634,4647) {
            Write-Output "Logoff"
        } else {
            Write-Output "Error"
        }
        $HideLogonType = Write-Output "N/A"
        if ($PSBoundParameters.ContainsKey('StartTime')) {
            $UserLogoffs['StartTime'] = $StartTime
        }
        if ($PSBoundParameters.ContainsKey('EndTime')) {
            $UserLogoffs['EndTime'] = $EndTime
        }
    }
    Process {
        Get-WinEvent -FilterHashtable $UserLogoffs | foreach-Object {
            $Logofflog = [pscustomobject]@{
                ComputerName = $ComputerName
                UserAccount = $_.Properties.Value[1]
                UserDomain = $_.Properties.Value[2]
                LogonID = $_.Properties.Value[3]
                EntryType = $EIDLO
                LogonType = $HideLogonType
                Date = $_.TimeCreated.ToString('MM/dd/yyyy')
                Time = $_.TimeCreated.ToString('HH:mm')
             }
                 $Logofflog
         }
    }
    End{}
}
Get-LogoffEvents -StartTime (Get-Date).AddDays(-1) | Export-Csv -Path C:\Security\Scripts\PJUsage\Temp\LogoffEvents.csv -NoTypeInformation