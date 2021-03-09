---
title: "Automatically move old photos out of DropBox with PowerShell to free up space"
date: "2015-02-02"
redirect_from : /2015/02/02/dropbox-powershell-2
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
tags: 
  - "dropbox"
  - "powershell"
---

I love dropbox, we all love Dropbox, it even comes preinstalled on our phones!

Sadly, it can be irritating when you get notices like this on the desktop

[![Dropbox Nag Screen](../assets/images/2015/02/images/dropbox-nag-screen.png)](../assets/images/2015/02/images/dropbox-nag-screen.png)

I noticed one day that my DropBox camera roll folder was using up the vast majority of my free space, something like 60 or more percent! Since I've got a 9 month old, its no wonder. I am constantly recording pictures and videos of her, so it's a matter of course.

If we could move all files older than three or four months out of the Dropbox 'Camera Uploads' folder, we could really free up some space! Additionally, I wanted to backup my files from DropBox onto another Storage Provider (OneDrive) as well as move a copy onto my backup drive. To solve all of these needs, I wrote a PowerShell script which can run as a scheduled task to handle moving the items out of the Camera Uploads folder. This can be run on any system that you've got the DropBox desktop client installed.  

I even included a snazzy looking summary report which is displayed after the job finishes.

Simply download the .ps1 file, then modify the few highlighted lines below.

```powershell 
####User Params Here # / This should be the path to your Dropbox camera Uploads folder $cameraFolder = "C:UsersStephenDropboxCamera Uploads"

# / If you want to create a copy somewhere else, provide it here 
$SkyDriveFolder = "C:\Users\Stephen\SkyDrive\Pictures\Camera Roll"

# / Finally, files are MOVED from your Dropbox folder to this path 
$BackupFolder = "D:\Photos\Galaxy Note II"

# / Specify the maximum age of files in days here. Anything older than this is moved out of the $cameraFolder path 
$MoveFilesOlderThanAge = "-113"

# / Specify the path to an optional logo for your status report 
$logoPath = C:UsersStephenDropboxSpeakingDemoslogo.png"

\# / Specify the path to a CSS file $cssPath = "C:\Users\Stephen\Dropbox\Speaking\Demosstyle.css" ####End user params 
```

Save the code below as a Move-DropBoxFiles.ps1. Next, to setup a scheduled task using the below code. (Borrowed liberally from the King of Code himself, Ed Wilson, [in this blog post on Scheduled Jobs](http://blogs.technet.com/b/heyscriptingguy/archive/2012/09/18/create-a-powershell-scheduled-job.aspx).

```powershell
$dailyTrigger = New-JobTrigger -Daily -At "2:00 PM"

$option = New-ScheduledJobOption -StartIfOnBattery –StartIfIdle

Register-ScheduledJob -Name UpdateHelp -ScriptBlock \`

{c:pathtoMove-DropboxFiles.ps1} -Trigger $dailyTrigger -ScheduledJobOption $option 
```

Now, when this runs every day at 2:00 PM, you should see a PowerShell window popup momentarily, and then the files will be copied and moved according to the criteria you select. When the job is finished, you'll see this nice looking HTML Status Page pop-up.

![](../assets/images/2015/02/images/dropbox-backup.png) Automatic file move from DropBox report

**Enjoy!**

## Full source here:

```powershell
####User Params Here
# / This should be the path to your Dropbox camera Uploads folder
$cameraFolder = "C:UsersStephenDropboxCamera Uploads"
 
# / If you want to create a copy somewhere else, provide it here
$SkyDriveFolder = "C:UsersStephenSkyDrivePicturesCamera Roll"
 
# / Finally, files are MOVED from your Dropbox folder to this path
$BackupFolder = "D:PhotosGalaxy Note II"
 
# / Specify the maximum age of files in days here.  Anything older than this is moved out of the $cameraFolder path
$MoveFilesOlderThanAge = "-113"
 
# / Specify the path to an optional logo for your status report
$logoPath = "C:UsersStephenDropboxSpeakingDemoslogo.png"
 
# / Specify the path to a CSS file 
$cssPath =  "C:UsersStephenDropboxSpeakingDemosstyle.css"
####End user params
 
 
$backupFiles = new-object System.Collections.ArrayList
$itemCount = Get-ChildItem $cameraFolder |  Where-Object LastWriteTime -le ((get-date).AddDays($MoveFilesOlderThanAge)) | Measure-Object | select -ExpandProperty Count
 
Get-ChildItem $cameraFolder |  Where-Object LastWriteTime -le ((get-date).AddDays($MoveFilesOlderThanAge)) | ForEach-Object {
    $i++ 
    Write-Progress -PercentComplete (($i/$itemCount) * 100) -Status "Moving $_ ($i of $itemCount)" -Activity ("Backup up files older than " + ((get-date).AddDays($MoveFilesOlderThanAge)))
    Copy-Item -Destination $SkyDriveFolder -Path $_.FullName -PassThru
    $backupFiles.Add((Move-Item -Destination $BackupFolder -Path $_.FullName -PassThru | select BaseName,Extension,Length,Directory))
    Start-Sleep -Milliseconds 25
    }
 
$companyLogo = "<div align=left><img src=`"$logoPath`"></div>"
$header = @"
  
 $companyLogo
 <h1>File export from Dropbox Report</h1>
 <p>The following automated report was generated at $(Get-Date) and contains the $itemcount files which were older than 
$([math]::Abs($MoveFilesOlderThanAge)) days. <Br><Br>This backup job was executed on System: $($Env:Computername)</p>
 
 
 <hr>
"@
 
$post = @"
 <h3>These items were moved to <b>$BackupFolder</b> for archiving to Azure</h3>
"@
 
$HTMLbase = $backupFiles | ConvertTo-Html -Head $header -CssUri $CssPath `
                            -Title ("Dropbox Backup Report for $((Get-Date -UFormat "%Y-%m-%d"))") `
                            -PostContent $post
                                             
 
$HTMLbase | out-file $StatusReportPathDropboxBackup_$((Get-Date -UFormat "%Y-%m-%d"))_Log.html 
 
& $StatusReportPathDropboxBackup_$((Get-Date -UFormat "%Y-%m-%d"))_Log.html 
```

## CSS File Removed
The Referenced Css File was Zen Theme from CSS Garden.