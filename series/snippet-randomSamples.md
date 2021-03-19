---
layout: page
title: Tools | PowerBullet Cheatsheet
permalink: /series/snippet-randomSamples
hero_image: /assets/images/foxdeployMOUNTAINTOP_hero.webp
hero_height: is-medium
show_sidebar: true
---

## Random Samples

Rehoming some orphaned pages here

## Capture MDT Command Output into logs

Capture command line output with MDT Toolkit
At a client, we needed the ability to run a command on the end user’s computer and then redirect the output to the BDD/SMSTS log.  In this particular case, the issue was because the USMT Scanstate tool would choke on any files with Alternate Data Streams.  If you’re curious, ADS is a method of storing two or more ‘streams’ of data on the disk pertaining to a file.  This is not found very often, and typically only during issues like this one.  In our case, files that had been downloaded from the internet with IE and never executed would be in a state in which the file was blocked, and to unblock it one would have to right-click the file and then choose unblock.

We used this tool created by Mark Russinovich of System Internals to automate the unblocking of files, to allow the process to complete.  You can use the same script to redirect any of your own tools to the logs. If you’re just interested in creating your own log entries, you can place the following lines into your own scripts.

```oLogging.CreateEntry "Remove-DataStreams: Preparing to remove ADS Information", LogTypeInfo```

```
<job id="Remove-DataStreams">
<script language="VBScript" src="ZTIUtility.vbs"/>
<script language="VBScript">
'//----------------------------------------------------------------------------
'// Purpose: Used to Remove Alternate Data Streams/Zone Identifiers
'// Usage: cscript Remove-DataStreams.wsf [/debug:true]
'// Version: 1.0 - 20 Nov 2012 - Stephen Owen
'//
'// This script is provided "AS IS" with no warranties, confers no rights and
'// is not supported by the authors or Deployment Artist.
'//
'// It should be noted that this process was needed in versions of USMT before 5.0,
'// as ScanState would fail if it encountered any files with Alternate Data Streams
'// Feel free to use this as a template if you'd like to run a command line or code
'// during a Task Sequence and want to redirect the output of the command to the BDD/SMSTS logs
'//
'// Instructions: Copy this script and Streams.exe into your Deployment Share tools or scripts folder.  Execute
'// the script by adding a 'Run Command Line' step in MDT or SCCM.
'//----------------------------------------------------------------------------
'//
'//----------------------------------------------------------------------------
'// Global constant and variable declarations
'//----------------------------------------------------------------------------

Option Explicit
Dim iRetVal
Dim iRC
Dim sCmd
'//----------------------------------------------------------------------------
'// End declarations
'//----------------------------------------------------------------------------
'//----------------------------------------------------------------------------
'// Main routine
'//----------------------------------------------------------------------------
On Error Resume Next
iRetVal = ZTIProcess
ProcessResults iRetVal
On Error Goto 0
'//---------------------------------------------------------------------------
'//
'// Function: ZTIProcess()
'//
'// Input: None
'//
'// Return: Success - 0
'// Failure - non-zero
'//
'// Purpose: Perform main ZTI processing
'//
'//---------------------------------------------------------------------------
Function ZTIProcess()
oLogging.CreateEntry "Remove-DataStreams: Preparing to remove ADS Information", LogTypeInfo
' Disable Zone Checks
oEnv("SEE_MASK_NOZONECHECKS") = 1
oLogging.CreateEntry "Remove-DataStreams: Beginning new removal method w/logging", LogTypeInfo
sCmd = "/accepteula -d -s ""C:\Documents and Settings"" "
iRC = oUtility.FindExeAndRunWithLogging( "streams.exe", sCmd )
If iRc <> 0 then
oLogging.CreateEntry "Remove-DataStreams: Error occured while running new method"
iRetVal = iRc
' Else
oLogging.CreateEntry "Remove-DataStreams: Successfully ran using new method"
' End if
'oLogging.CreateEntry "Remove-DataStreams: Beginning old method"
'Removal of ADS values begins here
'iRetVal = oUtility.RunWithHeartbeat("streams.exe /accepteula -d -s ""C:\Documents and Settings"" ")
' oLogging.CreateEntry "Remove-DataStreams: Completed Removal of ADS in C:\Documents and Settings"
'iRetVal = oUtility.RunWithHeartbeat("streams.exe /accepteula -d -s C:\")
' oLogging.CreateEntry "Remove-DataStreams: Completed Removal of ADS in C:\"
'if (iRetVal = 0) or (iRetVal = 3010) then
' ZTIProcess = Success
'Else
' ZTIProcess = Failure
' oLogging.CreateEntry "Remove-DataStreams: Error processing script Check the log."
'End If
' Enable Zone Checks
oEnv.Remove("SEE_MASK_NOZONECHECKS")
oLogging.CreateEntry "Remove-DataStreams: Return code from command = " & iRetVal, LogTypeInfo
oLogging.CreateEntry "Remove-DataStreams: Finished Removal", LogTypeInfo
End Function
</script>
</job>
```

## DSC Create Configuration on demand
Use this code in conjunction with the Steps in my DSC Chicken and Egg post to create a configuration.mof for a machine while it is being built!

```
$session = New-PSSession -ComputerName DC01
 
Write-host "Opening Session to PullServer"
Invoke-Command -session $session -ScriptBlock {
 
    #Create our $guid
    $guid = [guid]::NewGuid().Guid
 
    #Remove-item $env:windir\system32\MonitoringSoftware -Confirm -Force
 
    Configuration CreateConfig_Install7Zip
    {
    param([string[]]$MachineName="localhost")
     
        Node $MachineName
        {
            File InstallFilesPresent
                {
                Ensure = "Present"
                SourcePath = "\\dc01\Installer"
                DestinationPath = "C:\InstallFiles"
                Type = "Directory"
                Recurse=$true       # can only use this guy on a Directory
                }
 
            Package MonitoringSoftware
                {
                Ensure = "Present"  # You can also set Ensure to "Absent"
                Path  = "$Env:SystemDrive\Temp\Monitoring\7z920-x64.msi"
                Name = "7-Zip"
                ProductId = "23170F69-40C1-2702-0920-000001000000"
                DependsOn= "[File]InstallFilesPresent"
                }
          
            }
        #EndOFDSC Config
        }
 
        #Create the .mof for the imaging machine
        $newMof = CreateConfig_Install7Zip -MachineName $guid -OutputPath "$env:PROGRAMFILES\WindowsPowerShell\DscService\Configuration"
        Write-host "Config Created!"
         
        New-DSCCheckSum $newMof.FullName
         
}
 
Write-Host "Exited Remote Session"
Write-Host "Retrieving `$guid"
 
$GetGuid = Invoke-Command -session $session -ScriptBlock {$guid}
Write-Host "Retrieved! `n GUID : $GetGuid"
 
Write-Host "Closing Remote Session"
Remove-PSSession $session
 
 
 
configuration SetPullMode
{
    param ($NodeId)    
 
    LocalConfigurationManager
    {
        AllowModuleOverwrite = 'True'
        ConfigurationID = $NodeId
        ConfigurationModeFrequencyMins = 60 
        ConfigurationMode = 'ApplyAndAutoCorrect'
        RebootNodeIfNeeded = 'True'
        RefreshMode = 'PULL'
        DownloadManagerName = 'WebDownloadManager'
        DownloadManagerCustomData = (@{ServerUrl = "http://dc01:8080/psdscpullserver.svc"; AllowUnsecureConnection = “TRUE”})
         
    }
}
 
Write-Host "Setting Pull Mode for DSC"
 
SetPullMode -NodeId $GetGuid -OutputPath C:\temp\SetPullMode.mof 
Set-DscLocalConfigurationManager -path C:\temp\SetPullMode.mof -Verbose
 
#Get-DscLocalConfigurationManager

```

## My PowerShell Profile


I’ve seen everyone sharing their PowerShell Profile recently, so I thought I’d do the same. This includes a number of interesting little functions I’ve made, and that I’ve seen from others online.

I hope you’re able to copy or enjoy some of this stuff.

```
###Search-Google############################################################
 
function Search-Google
{
 
    Begin
    {
    $query='https://www.google.com/search?q='
    }
    Process
    {
    Write-Host $args.Count, "Arguments detected"
    "Parsing out Arguments: $args"
    for ($i=0;$i -le $args.Count;$i++){
    $args | % {"Arg $i `t $_ `t Length `t" + $_.Length, " characters";$i++} }
 
    $args | % {$query = $query + "$_+"}
    $url = "$query"
    }
    End
    {
    $url.Substring(0,$url.Length-1)
    "Final Search will be $url"
    "Invoking..."
    start "$url"
    }
}
 
###Helper Functions############################################################
 
Function Uptime{
param([parameter(Mandatory=$false)][string]$computer=".")
#$computer = read-host "Please type in computer name you would like to check uptime on"
 
$lastboottime = (Get-WmiObject -Class Win32_OperatingSystem -computername $computer).LastBootUpTime
 
$sysuptime = (Get-Date) – [System.Management.ManagementDateTimeconverter]::ToDateTime($lastboottime)
 
Write-Host "$computer has been up for: " $sysuptime.days "days" $sysuptime.hours "hours" $sysuptime.minutes "minutes" $sysuptime.seconds "seconds"}
 
Function diskusage
{
param([parameter(Mandatory=$false)][string]$remotepc=".")
#$remotepc = Read-host 'For which computer?'
Get-WmiObject win32_logicaldisk -ComputerName $remotepc  -Filter "drivetype=3" | select SystemName,DeviceID,VolumeName,@{Name="Size(GB)";Expression={"0:N1}" -f($_.size/1gb)}},@{Name="FreeSpace(GB)";Expression={"{0:N1}" -f($_.freespace/1gb)}}}
 
Function patches{
param([parameter(Mandatory=$false)][string]$remotepc=".")
#$remotepc = Read-host 'For which box?'
Get-WmiObject -Class "win32_quickfixengineering" -ComputerName $remotepc | select hotfixid,installedon}
 
function Play-Bubble{
[CmdletBinding()]
Param(
    [Parameter(Mandatory=$true,ValueFromPipeline=$true,ValueFromPipelineByPropertyName=$true)]
        $bubbles="0"
)
 
$sound = new-Object System.Media.SoundPlayer;
$sound.SoundLocation = "C:\users\sowen\Downloads\bubble_Pop-Sound_Explorer-1206462561.wav"
 
 1..[int]$bubbles | % {$sound.Play();start-sleep -Milliseconds 150}
}
 
###Get-SwitchedStatus############################################################
 
####################################################################
#     ----Name : Work Client Quest Switch Status
#     ---Author: Stephen Owen, Work, 7.24.2014
#     Function : Use this tool to determine if a user account has switched or not, based on the account's Source targetAddress property
#     ---Usage : Get-SwitchedStatus 
 
Function Get-SwitchedStatus {
<#
    .Synopsis
       Use this tool to determine if a user account has switched or not, based on the account's Source targetAddress property
    .DESCRIPTION
       This tool connects to the Source (legacy) AD Domain and looks up the specified user object, returning the .targetAddress property
       connects to the target domain to move the user account to the correct OU
    .PARAMETER UserName
        Specify the username to inquire
    .EXAMPLE
       Get-SwitchedStatus -UserName Stephen.Owen
       > This tool will connect to the source, and grab the targetAddress property of the object .  If this contains *@source.qmm, the account is most likely unSwitched.  If this value contains *@target.qmm, then the account is most likely Switched.
    .EXAMPLE
       "Stephen.Owen","Mark.Wuerslin" | ForEach-Object {Get-SwitchedStatus -UserName $_})
       > Perform Get-SwitchedStatus on both Stephen.Owen, then Mark.Wuerslin
#>
[CmdletBinding()]
param([Alias("UserName","LogonName")][parameter(Mandatory=$True,ValueFromPipeline=$True,position=0)][string[]]$UserNames,[string]$service="amatldc01",[switch]$WriteWarning)
 #Write-host "Checking for Quest Active Roles PSSnapIn..." -ForegroundColor White -NoNewline
      $obj=@()
      $Host.UI.RawUI.WindowTitle="---Get UserSwitchedStatus Tool"
      Write-Progress -Activity ("Checking for Quest Active Roles PSSnapIn...") -PercentComplete 25  -Status "Connecting"
            if (-not ((Get-PSSnapin).Name -contains "Quest.ActiveRoles.ADManagement")){
 
                try  {Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction Stop}
                catch{
                      #Write-host "[ERROR]" -ForegroundColor Red
                      Write-Warning "This tool depends on the Quest Active Roles tools to operate"
                      $DL = Read-Host "Download? Y/N"
                      IF ($DL -eq "Y"){
                        Start 'http://www.quest.com/quest_download_assets/individual_components/Quest_ActiveRolesManagementShellforActiveDirectoryx86_151.msi'
                        "Exiting..."
                        }
                        ELSE{"Exiting...";break}
 
                      BREAK
                      }
               finally{#Write-Host "[OKAY]" -ForegroundColor Green
                      }
            }
        ELSE{start-sleep -Milliseconds 150
             #Write-Host "[OKAY]" -ForegroundColor Green
             Write-Progress -Activity ("Checking for Quest Active Roles PSSnapIn...") -PercentComplete 50
            }
            if (-not($credential)){
                $credential= Get-Credential -Message "Enter credentials which can browse AD in Source and Target"}ELSE{"Cached credential detected, continuing..."
                }
        Write-host ("Detected: " + $UserNames.Count + " objects")
           #Connect to source
            start-sleep -Milliseconds 150
            #Write-Host "Connecting to Source..." -NoNewline
            Write-Progress -Activity ("Connecting to source...") -PercentComplete 50  -Status "Connecting..."
            try  {Connect-QADService $service -Credential $credential -ErrorAction Stop}
            Catch{
                 Write-warning "Error ocurred connecting to AMATLDC01 to pull source OU paths, check credentials..."
                 BREAK
                 }
          finally{#Write-Host "[OKAY]" -ForegroundColor Green
          }
    forEach ($CurrentObject in $UserNames){
        Try  {start-sleep -Milliseconds 150
              Write-Progress -Activity ("Looking up $CurrentObject on $service") -PercentComplete 75 -Status "Gathering Info..."
              $user = get-qaduser $CurrentObject -DontUseDefaultIncludedProperties -IncludedProperties targetAddress -Service $service -ConnectionAccount $credential.UserName -ConnectionPassword $credential.Password -ErrorAction Stop
              Write-Debug "Troubleshoot `$user"}
 
       catch {Write-Warning ("Unable to perform Get-QADUser for object $CurrentObject from service: $service `n check `$CurrentObject")
             }
             Write-Debug "Troubleshoot `$user"
 
        if ($user){
            if (-not($user.targetAddress)){
                if ($WriteWarning){
                    Write-Warning ("Unable to find targetAddress: $CurrentObject has NOT Switched")
                    }
 
                  }
            }
 
        if ($user.targetAddress -like "*@target.qmm"){
            $obj += [pscustomobject]@{UserName=$user;Status="Switched"}
            CONTINUE
            }
            if ($user.Email){
                $obj += [pscustomobject]@{UserName=$user;Status="Not Switched"}
                }
            ELSE{
                $obj += [pscustomobject]@{UserName=$user;Status="No E-mail"}
                }
        }
 
        $obj | ft
}
 
####Split-n-Trim#########################################################################
 
Function Split-N-Trim {
param(
      [Parameter(Mandatory=$True,ValueFromPipeline=$True)][string[]]$Objects
      )
      write-host ("-Recieved " + $Objects.Count +" objects")
      $Objects = $Objects.Trim().Split("`n")
      write-host ("Returning " + $Objects.Count +" objects")
      Return $Objects
}
 
new-alias Trim-N-Split Split-N-Trim
 
####Move-ClientUsers#########################################################################
 
####################################################################
#     ----Name : Work Client User Moving tool
#     ---Author: Stephen Owen, Work, 7.23.2014
#     Function : Post User-Migration, moves users to the correct OU
#     ---Usage : Use to ensure that users are placed in the right OU
 
Function Move-ClientUsers{
 This tool will enumerate the contents of '.\2014-07-22_20-13-48 M2 - User Migration.txt', omitting the first line, then connect to the source domain to retrieve each User's Object location.  Next, the process will connect to the target to verify the object location there.  If the values do not match, then the tool will move the object to the correct location.
    .EXAMPLE
       Move-ClientUsers -UserList '.\2014-07-22_20-13-48 M2 - User Migration.txt' -WhatIf
       > Receive Standard PowerShell WhatIf output, useful to know the scope of an action
#>
[CmdletBinding(SupportsShouldProcess=$true)]
 Param(
    [Parameter(Mandatory=$false,Position=0,HelpMessage="Please specify the users to be moved to the appropriate OUs.  This can be either names within a file, or a hashtable.")]
            [string[]]$UserList,
            [string[]]$ADRoot,
            [switch]$ShowVerbose, #Work-around support to enable lazy verbose output
            [switch]$ListOUs
 
            )
begin{
            Write-host "Checking for Quest Active Roles PSSnapIn..." -ForegroundColor White -NoNewline
 
            try  {Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction Stop}
            catch{
                  Write-host "[ERROR]" -ForegroundColor Red
                  Write-Warning "This tool depends on the Quest Active Roles tools to operate"
                  $DL = Read-Host "Download? Y/N"
                  IF ($DL -eq "Y"){
                    Start 'http://www.quest.com/quest_download_assets/individual_components/Quest_ActiveRolesManagementShellforActiveDirectoryx86_151.msi'
                    "Exiting..."
                    }
                    ELSE{"Exiting...";break}
 
                  BREAK
                  }
           finally{Write-host "[OKAY]" -ForegroundColor Green }
 
           if (-not($credential)){
                $credential= Get-Credential -Message "Enter credentials which can browse AD in Source and Target"}ELSE{"Cached credential detected, continuing..."
                }
 
           if ($ADRoot){
 
                #Connect to Target
                Write-host "Connecting to Target to enumerate $ADRoot members..." -NoNewLine
                try  {
                    Connect-QADService amatlds01 -Credential $credential -ErrorAction Stop | Out-Null
                     }
                catch{
                     Write-warning "Error ocurred connecting to AMATLDS01 to pull source OU paths, check credentials..."
                     BREAK
                     }
              finally{Write-Host "[OKAY]" -ForegroundColor Green}
 
               $InputObjects = get-qaduser -SearchRoot $ADRoot | select -ExpandProperty Name
               }
               ELSE{
 
                if ($Userlist -like "*User*"){$ListContainsUserObjects=$TRUE}
                #Flow, get users from migration file
                $InputObjects = Get-Content $UserList
                #Dump first line
                $InputObjects = $InputObjects[1..$InputObjects.Count]
                $InputObjects = $InputObjects | % {if ($_ -notlike "*#MULTIPLE_SEE_NOTES#$"){$_}}
            }
 
            $UsersArray = New-Object -TypeName System.Collections.ArrayList
 
            #Connect to source
            Write-host "Connecting to Source..." -NoNewline
            try  {Connect-QADService amatldc01 -Credential $credential -ErrorAction Stop | Out-Null}
            Catch{
                 Write-warning "Error ocurred connecting to AMATLDC01 to pull source OU paths, check credentials..."
                 BREAK
                 }
          finally{Write-host "[OKAY]" -ForegroundColor Green }
 
            #Flow, get user DN from source org
            #we want ParentContainer
            $i = 0;$x = $i
            ForEach ($user in $InputObjects){
                Write-Progress -Activity ("Retrieving Source DN for $user") -PercentComplete (($i/($InputObjects.count)*100 ))
                if ($user -eq "#MULTIPLE_SEE_NOTES#$"){BREAK}
                IF ($ListContainsUserObjects){$DN = get-QADUser $user | Select -ExpandProperty ParentContainer}
                    ELSE{$DN = get-QADComputer $user | Select -ExpandProperty ParentContainer}
 
                Write-Debug "Debug Breakpoint to test ParentContainer for Source"
 
                $obj = [pscustomobject]@{index=$i;UserName=$user;SourceContainer=$DN;TargetContainer=$null;Match=$false} 
 
                $UsersArray.Add($obj) | out-null
                $i++
                }
 
            if ($ShowVerbose){$UsersArray | Select-Object UserName,SourceContainer}
            $users = "add DN"
 
            #Connect to Target
            Write-host "Connecting to Target..." -NoNewLine
            try  {
                Connect-QADService amatlds01 -Credential $credential -ErrorAction Stop | Out-Null
                 }
            catch{
                 Write-warning "Error ocurred connecting to AMATLDS01 to pull source OU paths, check credentials..."
                 BREAK
                 }
          finally{Write-Host "[OKAY]" -ForegroundColor Green}
            #Flow, move users in target to appropriate location 
 
            ForEach ($user in $UsersArray){
 
                Write-Progress -Activity ("Retrieving Target DN for " + $user.UserName) -PercentComplete (($x/($UsersArray.count)*100 ))
                if ($user -eq "#MULTIPLE_SEE_NOTES#$"){BREAK}
                IF ($ListContainsUserObjects){$DN = get-QADUser $user.UserName | Select -ExpandProperty ParentContainer}
                    ELSE{$DN = get-QADComputer $user.UserName | Select -ExpandProperty ParentContainer}
 
                #Get Current Location in Target
                #$DN = get-QADUser $user.UserName | Select -ExpandProperty ParentContainer
 
                Write-Verbose ("Current object: "+ $user.UserName  +" `n`t Current Index $x Index based user name = " + $UsersArray[$x].UserName)
 
                #Set the TargetContainer value both for the current object in ForEach and also the outer object in $UsersArray
                $user.TargetContainer = $DN
                $UsersArray[$x].TargetContainer = $DN 
 
                $UsersArray[$x].Match = If (($user.SourceContainer -replace 'Clientad.Client.com','Client.com')-match $user.TargetContainer){$TRUE}ELSE{$FALSE}
 
                Write-Debug "Breakpoint: within ForEach loop in Target, use this to test comparison logic to see if user is in appropriate OU"
                if ($ShowVerbose){$User.SourceContainer,$user.TargetContainer}
 
                $x++
 
            }
 
            if ($ShowVerbose){$UsersArray |  Select-Object UserName,SourceContainer,TargetContainer,@{Name='Match';Expression={If (($_.SourceContainer -replace 'Clientad.Client.com','Client.com')-match $_.TargetContainer){$TRUE}ELSE{$FALSE}} } | Format-Table -AutoSize}
            Write-Debug "Breakpoint: Test comparison of Source & Target"
}
            process{
 
                        $y = 1
                        ForEach ($user in ($UsersArray | ? {($_.SourceContainer)} | ? Match -eq $false)){
                            if ($user -eq "#MULTIPLE_SEE_NOTES#$"){BREAK}
                            if($PSCmdlet.ShouldProcess($User.UserName,"Move object to '$($User.SourceContainer)'")){
                                Write-Progress -Activity ("Attempting to move " + $user.UserName) -PercentComplete (($y/($UsersArray.count)*100 )) -Status "Moving..."
                                $newTargetOU = (($user.SourceContainer -replace 'Clientad.Client.com','Client.com'))
                                    if ($newTargetOU -like "*/Clean Sweep"){
                                        "Clean sweeper detected, mitigating..."
                                        $newTargetOU = $newTargetOU -replace "/Clean Sweep",""
                                        }
                                 Write-host ("Preparing to move: " + $user.UserName) -NoNewline
                                try {Get-QADUser $user.UserName| Move-QADObject -NewParentContainer $newTargetOU -ErrorAction Stop}
                               catch{Write-debug "Troubleshooting..."}
                             finally{Write-host -ForegroundColor Green "`t`t`t[OKAY]"}
                               }
                               $y++
                       }
                If ($ListOUs){return $UsersArray}
                }
           }
            #return $UsersArray
            #$Global:UsersArray = $UsersArray
 
###Remind-Me Functions + Welcome Text############################################################
 
function RemindMe-Comparators {
 
$writeout = @"
Windows PowerShell includes the following comparison operators:
 
  -eq
  -ne
  -gt
  -ge
  -lt
  -le
  -Like
  -NotLike
  -Match
  -NotMatch
  -Contains
  -NotContains
  -In
  -NotIn
  -Replace
"@
 
"$writeout"
 
}
 
$custom = @"
--Custom Commands Available--
 RemindMe-Azure`t`tDisplay Reminder information for Azure
 RemindMe-Comparators`tDisplay Reminder information on Comparison Operators
 Search-Google`t`tQuickly Launch a google Search
 Play-Bubbles`t`tPop `dem Bubbles!
 Get-SwitchStatus`tSee the status of users
 Split-N-Trim`t`tSplit input on a new-line character and trim spaces
 Trim-N-Split`t`tThe same as above, but reversed
 Move-ClientUser`tMove User Accounts
 Uptime`t`t`t`tEasily get Uptime
 DiskUsage`t`t`tEasily Get Disk Usage
 Patches`t`t`tLists Patches
"@
 
Write-Host -fore Yellow -Back Black $custom
 
###Setup Env, import modules, change dirs############################################################
 
if (Test-path "C:\Program Files (x86)\Microsoft SDKs\Windows Azure\"){
    Write-Host "Azure Modules found, importing"
    gci 'C:\Program Files (x86)\Microsoft SDKs\Windows Azure\PowerShell\Azure' *.psd1 | select -ExpandProperty Fullname| Import-module -PassThru
    }
    ELSE
    {#Write-Warning "Azure and Azure Platform Modules not detected, skipping..."
}
 
if (Test-path "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1"){
    import-Module "C:\Program Files (x86)\Microsoft Configuration Manager\AdminConsole\bin\ConfigurationManager.psd1" -PassThru
    }
    ELSE
    {#Write-Warning "Config Manager PowerShell module not detected, skipping..."
        }
 
if (test-path C:\Users\sowen\dropbox\docs\Work\Client\Scripts){"`nClient Scripts Directory detected, must be using the work laptop, navigating to project scripts dir...";Set-location "C:\Users\sowen\dropbox\docs\Work\Client\Scripts"}
 
cls
 
###Display Welcome############################################################
 
Write-Host -fore Yellow -Back Black $custom
Write-host ("`n Online with PowerShell Version:" + (get-host | select -expand Version)
```
