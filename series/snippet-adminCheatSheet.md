---
layout: page
title: Tools | Admins Cheatsheet
permalink: /series/snippet-adminCheatSheet
hero_image: /assets/images/foxdeployMOUNTAINTOP_hero.jpg
hero_height: is-medium
show_sidebar: true
---

## Admins Cheatsheet

Here is a list of common PowerShell one-liners that might help you!

# Get all ‘Error’ events from the last two weeks from a remote computer
```
Get-WinEvent -LogName Application -computername RemoteComputer1,RemoteComputer2 |
   Where-Object LevelDisplayname -eq Error |
     Where-Object TimeCreated -ge ((Get-Date).AddDays(-14)) |
       Export-Csv .\Temp\SDC.csv
```

# Get all members of the Administrators group of a remote machine
```
Get-WMIObject -Query `
" SELECT * FROM Win32_GroupUser `
WHERE GroupComponent='Win32_Group.Domain='RemotePC',`
Name='Administrators'" -ComputerName RemotePC
```

# Export all mailboxes from an Exchange Server, 5 at a time
Thanks to StackOverflow for some help with the logic on waiting for a job to finish
```
$mailboxes = Get-Mailbox
 
ForEach ($mailbox in $mailboxes){
    $running = @(Get-Job | Where-Object { $_.State -eq 'Running' })
    if ($running.Count -ge 8) {
         #too many jobs, we'll wait for the first to complete
         $running | Wait-Job -Any
         }
 
         #there weren't too many jobs, or a job just completed, let's go
 
    Start-Job {
            New-MailboxExportRequest -Mailbox $mailbox.Alias -FilePath "\\SERVER01\PSTFileShare\$($mailbox | select -Expand Alias)_Export.pst"
            while ((get-mailboxexportrequest -mailbox $mailbox.Alias).Status -eq 'InProgress'){
                "Mailbox export in progress, waiting"
                start-sleep 60
                }
 
        }
    #End of this Mailbox
    } 
 
#lets wait for everything to finish
Wait-Job * | out-null
 
# Process the results
foreach($job in Get-Job)
{
    $result = Receive-Job $job
    Write-Host $result
}
```