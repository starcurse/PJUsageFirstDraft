Function Get-LoginEvents {
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
        enum LogonTypes {
            Unknown = 0
            Interactive = 2
            Network = 3
            Batch = 4
            Service = 5
            Unlock = 7
            NetworkClearText = 8
            NewCredentials = 9
            RemoteInteractive = 10
            CachedInteractive = 11
        }
        $UserLogins = @{
            LogName = 'Security'
            ID = 4624
        }
        $EIDLI = if ($UserLogins.ID = 4624) {
            Write-Output "Logon"
        } else {
            Write-Output "Error"
        }
        if ($PSBoundParameters.ContainsKey('StartTime')){
            $UserLogins['StartTime'] = $StartTime
        }
        if ($PSBoundParameters.ContainsKey('EndTime')){
            $UserLogins['EndTime'] = $EndTime
        }
    }
    Process {
        Get-WinEvent -ComputerName $ComputerName -FilterHashtable $UserLogins | foreach-Object {
           $Logonlog = [pscustomobject]@{
               ComputerName = $ComputerName
                UserAccount = $_.Properties.Value[5]
                UserDomain = $_.Properties.Value[6]
                LogonID = $_.Properties.Value[7]
                EntryType = $EIDLI
                LogonType = [LogonTypes]$_.Properties.Value[8]
                Date = $_.TimeCreated.ToString('MM/dd/yyyy')
                Time = $_.TimeCreated.ToString('HH:mm')
            }
            if ($_.Properties.Value[11] -eq '-') {
                Write-Output [-InputObject] $Logonlog | Out-Null
            } else {
                $Logonlog
            }
        }
    }
    End{}
}
$LoginCSV = "C:\Security\Scripts\PJUsage\Temp\LoginEvents.csv"
Get-LoginEvents -StartTime (Get-Date).AddDays(-1) | Where-Object LogonType -eq 'Interactive' | Export-Csv -Path $LoginCSV -NoTypeInformation
Get-LoginEvents -StartTime (Get-Date).AddDays(-1) | Where-Object LogonType -eq 'Network' | Export-Csv -Path $LoginCSV -NoTypeInformation -Append
Get-LoginEvents -StartTime (Get-Date).AddDays(-1) | Where-Object LogonType -eq 'RemoteInteractive' | Export-Csv -Path $LoginCSV -NoTypeInformation -Append
Get-LoginEvents -StartTime (Get-Date).AddDays(-1) | Where-Object LogonType -eq 'CachedInteractive' | Export-Csv -Path $LoginCSV -NoTypeInformation -Append