---
title: "PowerShell: Reapply ACLs Based on Folder Name"
date: "2014-08-22"
categories: 
  - "scripting"
tags: 
  - "ad"
  - "powershell"
  - "quest"
  - "script-sharing"
---

Recently in a project, we needed a way to reapply ACLs to user's roaming profile / home folder directories on a file share.

### Wait, why would you ever need to do that?

Somehow someone in the service desk noted that a user was missing permission to his share, and decided to resolve this by forcing permissions down from the top folder object all the way down.  They of course opted to choose the option to 'replace all properties with inherited properties from this object.'  You know, the one which displayed a scary 'Are you really sure you want to do this?' alert.

[![picard](images/picard.jpg)](https://foxdeploy.files.wordpress.com/2014/08/picard.jpg)

This really caused a lot of issues, as we were in a project migrating users from Domain A to Domain B.

Fortunately for all involved, the user shares impacted had a naming convention that basically a user' roaming profile was named after that person's SAm or UPN name.  Using this olive branch, we were able to get very close to fixing 95% of users with one swift tool.

The overall goal of this tool is to determine what permissions the folder should have had based on the user name for Domain A. If the user account is valid, then the tool will apply an appropriate ACE for the user's account in Domain A.

Once this was finished, we then used the functionality provided by Quest Migration Manager for Active Directory to apply a Domain B equivalent permission to all of the affected directories. You could also do the same by rerunning this script and manually specifying the name of Domain B within the Domain parameter.

\[code language="powershell"\] #################################################################### # ----Name : FoxDeploy ACL Fixing tool # ---Author: Stephen Owen, $company, 7.16.2014 # Function : Post User-Migration, use this tool to add users back to a share with their own name # ---Notes : This tool can be used to restore appropriate Read-level of the $company account to a users share # needed after a particularly overzealous application of permissions stripped Source Perms from certain shares Function Fix-ACLs{ <# .Synopsis Use this tool Post User-Migration, to give a user permission to a share, where the user's name matches the folder .DESCRIPTION This tool receives a file share, then enumerates one level for directory objects. As the directories expected should be in the format of “userfirstname.userlastname”, it is trivial to determine the account which should have ownership of this share. .PARAMETER FileServers The path to the fileserver to process .PARAMETER ADServer The AD Server to use to obtain the user object for permissions application .PARAMETER DomainA The Short Name of the original Domain .EXAMPLE Fix-ACLs -FileServers "\\\\aumjfp01\\users" -ADServer "localserver" > This will return all of the directories under \\\\aumjfp01\\users. The rest of the example will assume the current user in question is OLDDOMAIN\\Jimmy.John. > A Quest AD lookup is performed to verify a valid user exists for the name of the folder (\\\\aumjfp01\\“jimmy.john”). > In this case an AD lookup is performed for OLDDomain\\jimmy.john > If valid, give this user permission to the folder, if not, add user name to $badUsers, which is reported at the end of the function .NOTES Sources: http://blog.netnerds.net/2007/07/powershell-set-acl-does-not-appear-to-work/ http://chrisfederico.wordpress.com/2008/02/01/setting-acl-on-a-file-or-directory-in-powershell/

#> \[CmdletBinding()\] Param( \[Parameter(Mandatory=$true,Position=0,HelpMessage="Please specify the file shares to be processed, in the format \\\\server\\share")\] \[string\[\]\]$FileServers, \[string\]$ADServer = "amatldc01", \[string\]$DomainA = "OldDomain"

)

if (-not($credential)){ $credential= Get-Credential -Message "Enter credentials which can be used to lookup a user account in AD on $ADServer" } ELSE{"Cached credential detected, continuing..." }

Write-host "Checking for Quest Active Roles PSSnapIn..." -ForegroundColor White -NoNewline

try {Add-PSSnapin Quest.ActiveRoles.ADManagement -ErrorAction Stop} catch{ Write-host "\[ERROR\]" -ForegroundColor Red Write-Warning "This tool depends on the Quest Active Roles tools to operate" $DL = Read-Host "Download? Y/N" IF ($DL -eq "Y"){ Start 'http://www.quest.com/quest\_download\_assets/individual\_components/Quest\_ActiveRolesManagementShellforActiveDirectoryx64\_151.msi' "Exiting..." } ELSE{"Exiting...";break}

BREAK }

Write-host "\[OKAY\]" -ForegroundColor Green

#Connect to source Write-host "Connecting to Source..." -NoNewline try {Connect-QADService $ADServer -Credential $credential -ErrorAction Stop | Out-Null} Catch{ Write-warning "Error ocurred connecting to $ADServer to pull source OU paths, check credentials..." BREAK } Write-host "\[OKAY\]" -ForegroundColor Green

$badUsers = @() ForEach ($FileServer in $FileServers){

try {$UserDirs = Get-ChildItem $FileServer -ErrorAction Stop | Where-Object PSIsContainer -eq $true} catch{Write-Warning "Error occurred connecting to $FileServer, check spelling and if valid path" BREAK } $i = 0

ForEach ($userDir in $UserDirs){ Write-Progress -Activity ("Setting permission for $userDir of $FileServer") -PercentComplete (($i/($UserDirs.count)\*100 )) #$userDir $acl = Get-Acl $userDir.FullName $DomainA\_ADAccount = ($DomainA + "\\" + $userDir.Name) "Verifying $DomainA\_ADAccount is valid user"

if (Get-QADUser $DomainA\_ADAccount){ Write-Host "User good, setting permissions..." -NoNewline $inherit = \[system.security.accesscontrol.InheritanceFlags\]"ContainerInherit, ObjectInherit" $propagation = \[system.security.accesscontrol.PropagationFlags\]"None" $permission = "$DomainA\_ADAccount","FullControl",$inherit,$propagation,"Allow" #$permission $accessRule = New-Object System.Security.AccessControl.FileSystemAccessRule $permission $acl.SetAccessRule($accessRule) | Out-Null

Write-Verbose "About to set $acl" try {#In a future version, this should create a job and then check for status while writing out progress Set-Acl -path $userDir.FullName -AclObject $acl} catch { }

Write-Host "\[OKAY\]" -ForegroundColor GREEN

} ELSE { write-error "Not a valid user account" $badUsers += $DomainA\_ADAccount }

"User Completed" $i++ #End of this userDir } #End of this FileServer } #End of function "The following user accounts were not found during an AD lookup, please investigate" return $badUsers} \[/code\]
