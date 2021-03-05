---
title: "SCCM 1511 - All prerequisites, in PowerShell"
date: "2016-01-22"
categories: 
  - "scripting"
tags: 
  - "powershell"
  - "sccm"
---

Just a warning, there's a FEW things you can't install w/ PowerShell, so make sure that you still do these steps manually:

- Use ADSI Edit to create a Systems\\Systems Management Container
- Give your SCCM Primary site computer account 'Full Control' permissions of this and all descendant objects

Beyond that, this PowerShell script will install all of the Non-SQL Pre-requisites for you.

To use, first, [download the Windows 10 ADK from this](http://go.microsoft.com/fwlink/p/?LinkId=526740)  link.  Place it in a folder called \_Software\\ADK at the root of a drive.

Next, download [the x86 and x64 bit MS XML Parsers](https://www.microsoft.com/en-us/download/details.aspx?id=3988), available, uh in the links to the left. Put these both within the same \_Software folder.

Finally, insert a Windows Server install disk (for your appropriate OS Version) to the machine.

Then, run this code to install all Prerequisites in record time!

\[code lang="powershell"\] $drives = Get-PSDrive -PSProvider FileSystem $PrereqDrive = $drives.Root | ? ({Test-Path $\_\\\_Software}) if (test-path &quot;$($PrereqDrive)\_Software&quot;){ $PreReqSrc = &quot;$($PrereqDrive)\_Software&quot; Write-Host &quot;SCCM Prereq source found at $PreReqSrc&quot; } else { Write-Warning &quot;Couldn't find a source folder called '\_Software' at the root of any drive&quot; }

$ServerISODrive = $drives.Root | ? ({Test-Path $\_\\Sources}) $ServerSXSSrc = &quot;$($ServerISODrive)Sources&quot;

Write-Host &quot;Installing MSXML Prereqs...&quot; try { Msiexec /i $PreReqSrc\\msxml6.msi /passive /l\*+ %windir%\\temp\\SCCM\_MSXML6.log msiexec /i $PreReqSrc\\msxml6\_x64.msi /passive /l\*+ %windir%\\temp\\SCCM\_MSXML6\_64.log } catch { Write-Warning &quot;Ensure that MSXML files were placed within $PreReqSrc&quot; }

Add-WindowsFeature -Name NET-Framework-Features,NET-Framework-Core -Source $ServerSXSSrc\\sxs

&amp; $PreReqSrc\\ADK\\adksetup.exe /features OptionId.ApplicationCompatibilityToolkit,OptionId.DeploymentTools,OptionId.WindowsPreinstallationEnvironment,OptionId.UserStateMigrationTool,OptionId.VolumeActivationManagementTool,OptionId.WindowsPerformanceToolkit,OptionId.SqlExpress2012 /ceip ON /norestart

Add-WindowsFeature BITS,BITS-IIS-Ext,BITS-Compact-Server, Web-Server, Web-WebServer, Web-Common-Http, Web-Default-Doc,Web-Dir-Browsing,Web-Http-Errors, Web-Static-Content, Web-Http-Redirect,Web-App-Dev,Web-Net-Ext,Web-Net-Ext45,Web-ASP,Web-Asp-Net,Web-Asp-Net45,Web-CGI,Web-ISAPI-Ext,Web-ISAPI-Filter,Web-Health,Web-Http-Logging,Web-Custom-Logging,Web-Log-Libraries,Web-Request-Monitor,Web-Http-Tracing,Web-Performance,Web-Stat-Compression,Web-Security,Web-Filtering,Web-Basic-Auth,Web-IP-Security,Web-Url-Auth,Web-Windows-Auth,Web-Mgmt-Tools,Web-Mgmt-Console,Web-Mgmt-Compat,Web-Metabase,Web-Lgcy-Mgmt-Console,Web-Lgcy-Scripting,Web-WMI,Web-Scripting-Tools,Web-Mgmt-Service, RDC -Verbose

Install-WindowsFeature -Name UpdateServices-Ui \[/code\]
