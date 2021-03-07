---
title: "Slide Deck, photos and resources from my Session at ATLPUG"
date: "2014-09-26"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

\[gallery type="slideshow" ids="791,792,795,794,793"\]

The Atlanta PowerShell User's Group first meeting at iVision went off wonderfully! We had a solid turn out, plenty of pizza and soda, and talked a whole lot about PowerShell, what's new, and whats coming.

\[scribd id=241068447 key=key-Rf46i7r4iJhMfkpy9oNR mode=scroll\]

\[scribd id=241068446 key=key-M4GZHi81cibuisMLkDF7 mode=slideshow\]

Here's the demo I worked through exploring features using the ISE  Props to Mike Robbins for showing me this technique!

\[code language="powershell"\] #Check our Version, needs to be greater than 5.0. version 9814 is the most up to date version (September preview) Get-host | Select-Object -Property Version

#region Working with Archives Set-location C:\\Demo

#Something to do with Archives, so lets look for ZIP Get-Command \*-Zip

Get-Command \*-Archive

Compress-Archive -Path C:\\demo -DestinationPath c:\\demo\\Files.zip -CompressionLevel Optimal #mkdir Unzipped

#endregion

#region Modules #Find-module #xActiveDirectory, xJea,

Find-Module

#endregion

#region #ONEGET

#One-Get is Apt-Get come to Windows. It is awesome!

#Import the Module Import-Module OneGet

#List all commands for the module, will prompt to install nuget Get-Command -Module OneGet

#Search your repo's for packages available DONT RUN! $OriginalPackages = Find-Package

#Number of packages Find-Package | Measure-Object | Select -Property Sum

#Not that many apps, where'd they all go? Let's check our package Sources Get-PackageSource

#by default, we only have PSGallery and MSPSGallery as sources...let's add Chocolatey. Previously this was Add-PackageSource, it's changed! $PackageSourceLocation = "http://chocolatey.org/api/v2" Register-PackageSource -ProviderName PSModule -Name Chocolatey -Location $PackageSourceLocation -Trusted -VERBOSE

#After adding Chcolatey DONT RUN! $FullPackages = find-package

#Total count of packages now ~ Find-Package | Measure-Object | Select -Property Sum

find-package evernote

#Search for apps with a summary that mentions PDF find-package | Where Summary -like "\*pdf\*"

find-package evernote | install-package -force #endregion

#region Convert-FromString $TraceRT = tracert -h 6 -w 45 microsoft.com #hops 6, -waiting 45 milliseconds

$TraceRT\[(3..12)\] #Skip the first few lines

$TraceRT\[(3..12)\] -replace "^\\s+" | ConvertFrom-String -PropertyNames Hop,Latency1,Latency2,Latency3,ServerName,ServerIP #Props to Francois Xavier Cat for this regex and general idea

$TraceRT\[(3..10)\] -replace "^\\s+" -replace 'ms','' -replace '\[ \\t\]+$','' | ConvertFrom-String -PropertyNames Hop,Latency1,Latency2,Latency3,ServerName,ServerIP

#endregion

#region DSC Stuff #Remove-item $env:windir\\system32\\MonitoringSoftware -Confirm -Force

Configuration InstallXMLNotePad { param(\[string\[\]\]$MachineName="localhost")

Node $MachineName { File InstallFilesPresent { Ensure = "Present" SourcePath = "\\\\localhost\\Installer" DestinationPath = "C:\\Demo\\InstallFiles" Type = "Directory" Recurse=$true # can only use this guy on a Directory }

Package XMLNotePad { Ensure = "Present" # You can also set Ensure to "Absent" Path = "C:\\Demo\\InstallFiles\\XmlNotepad.msi" Name = "XML Notepad 2007" ProductId = "FC7BACF0-1FFA-4605-B3B4-A66AB382752D" DependsOn= "\[File\]InstallFilesPresent" }

}

}

InstallXMLNotePad

Start-DscConfiguration -Path InstallXMLNotePad -Wait -Verbose -Force #endregion

#Cleanup Demo Unregister-PackageSource -ProviderName PSModule -Name Chocolatey \[/code\]

Here's the function we created on stage, which recieves and parses output from Trace Route using Convert-FromString.

\[code language="powershell"\] function Test-Route{ param( $ServerName='microsoft.com', $Hops=6, $Wait=45 )

Write-Host "Tracing Route from localhost to $Servername, capturing $Hops Hops and waiting $Wait MS" $TraceRT = tracert -h $Hops -w $Wait $ServerName #hops 6, -waiting 45 milliseconds

$TraceRT\[(3..10)\] -replace "^\\s+" -replace 'ms','' -replace '\[ \\t\]+$','' | ConvertFrom-String -PropertyNames Hop,Latency1,Latency2,Latency3,ServerName,ServerIP } \[/code\]
