---
title: "Windows 10 Must-have Customizations"
date: "2017-08-14"
redirect_from : 2017/08/14/windows-10-must-have-customizations
categories: 
  - "scripting"
tags: 
  - "sccm"
  - "windows10"
coverImage: "../assets/images/2017/08/images/essential-windows-10-customizations.png"
excerpt: "I've performed a number of Windows 10 Deployment projects, and have compiled this handy list of must-have customizations that I deploy at build time using SCCM, or that I bake into the image when capturing it.

Hope it helps, and I'll keep updating it as I find more good things to tweak."
---

![](../assets/images/2017/08/images/essential-windows-10-customizations.png?w=636)

I've performed a number of Windows 10 Deployment projects, and have compiled this handy list of must-have customizations that I deploy at build time using SCCM, or that I bake into the image when capturing it.

Hope it helps, and I'll keep updating it as I find more good things to tweak.

#### Remove Quick Assist

![](../assets/images/2017/08/images/quickassist.png?w=636)

Quick Assist is very useful, but also on the radar of fake-Microsoft Support scammers, so we disable this on our image now.

```powersherll
Get-WindowsPackage -Online | Where PackageName -like \*QuickAssist\* | Remove-WindowsPackage -Online -NoRestart
```

#### Remove Contact Support Link

![](../assets/images/2017/08/images/support.png?w=636)

Because we were unable to customize this one to provide our own internal IT information, we disabled this one as well.

```powershell
Get-WindowsPackage -Online | Where PackageName -like \*Support\*| Remove-WindowsPackage -Online -NoRestart 
```

#### Disable SMB 1

With the Petya and other similar scares, we also decided to just turn SMB off.  Surprisingly, almost nothing that we cared about broke.

```powershell
Set-SmbServerConfiguration -EnableSMB1Protocol $false -force Disable-WindowsOptionalFeature -Online -FeatureName smb1protocol -NoRestart
```

#### Disable People App

![](../assets/images/2017/08/images/people.png?w=636)

Users in testing became VERY confused when their Outlook contacts did not appear in the People app, so we got rid of it too.

```powershell
Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*people\*"} | Remove-AppxPackage 
```

#### Disable Music player

We deploy our own music app and were mistrusting of the music app bundled with Windows 10, so we got rid of this one too.

![](../assets/images/2017/08/images/music.png?w=636)

```powershell


Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*zune\*"} | Remove-AppxPackage


```

 

#### Disable Xbox App

![](../assets/images/2017/08/images/xbox.png?w=636)

Pretty silly that apps like this even get installed in the PRO version of Windows 10.  Maybe we need a non-shenanigan version of Win 10 ready for business...but...but I'll finish this SCCM issue after a quick romp through Skellige.

```powershell
Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*xboxapp\*"} | Remove-AppxPackage 
```

####  Disable Windows Phone, Messaging

![](../assets/images/2017/08/images/phone.png?w=636)

We honestly aren't sure who will want this or for what purpose this will fit into an organization.  Deleted.  Same goes with Messaging.

```powershell
Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*windowspho\*"} | Remove-AppxPackage Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*messaging\*"} | Remove-AppxPackage 
```

####  Disable Skype, Onenote Windows 10 App

![](../assets/images/2017/08/images/skype.png?w=636)

Sure, let's have a new machine deploy with FOUR different entries for Skype. No way will users be confused by this.  Oh yeah, and two OneNotes.  Great move.

```powershell
Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*skypeap\*"} | Remove-AppxPackage Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*onenote\*"} | Remove-AppxPackage 
```

####  Disable 'Get Office'

![](../assets/images/2017/08/images/getoffcie.png?w=636)

We already deploy Office!  This is one app that should automatically uninstall, in my opinion.  Windows 10 is FULL of cruft like this.

![](../assets/images/2017/08/images/FP3134.jpg)

```powershell
Get-AppxPackage -AllUsers | Where-Object {$\_.PackageFullName -like "\*officehub\*"} | Remove-AppxPackage | Remove-AppxPackage 
```

####  Disable a bunch of other stuff

At this point I kind of got bored with making screen shots of each of these.  I also blocked a number of other silly things, so if you got bored too, here is the full script.

```powershell 
#this runs within the imaging process and removes all of these apps from the local user (SCCM / local system) and future users
#if it is desired to retain an app in imaging, just place a # comment character at the start of a line
 
#region remove current user
$packages = Get-AppxPackage -AllUsers
 
#mail and calendar
$packages | Where-Object {$_.PackageFullName -like "*windowscommun*"}     | Remove-AppxPackage
 
#social media
$packages | Where-Object {$_.PackageFullName -like "*people*"}            | Remove-AppxPackage
 
#microsoft promotions, product discounts, etc
$packages | Where-Object {$_.PackageFullName -like "*surfacehu*"}         | Remove-AppxPackage
 
#renamed to Groove Music, iTunes like music player
$packages | Where-Object {$_.PackageFullName -like "*zune*"}              | Remove-AppxPackage
 
#gaming themed application
$packages | Where-Object {$_.PackageFullName -like "*xboxapp*"}           | Remove-AppxPackage
 
# photo application (many leave this app)
$packages | Where-Object {$_.PackageFullName -like "*windowspho*"}        | Remove-AppxPackage
 
#
$packages | Where-Object {$_.PackageFullName -like "*skypeap*"}           | Remove-AppxPackage
 
#
$packages | Where-Object {$_.PackageFullName -like "*messaging*"}         | Remove-AppxPackage
 
# free/office 365 version of oneNote, can confuse users
$packages | Where-Object {$_.PackageFullName -like "*onenote*"}           | Remove-AppxPackage
 
# tool to create interesting presentations
$packages | Where-Object {$_.PackageFullName -like "*sway*"}              | Remove-AppxPackage
 
# Ad driven game
$packages | Where-Object {$_.PackageFullName -like "*solitaire*"}         | Remove-AppxPackage
 
$packages | Where-Object {$_.PackageFullName -like "*commsphone*"}        | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*3DBuild*"}           | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*getstarted*"}        | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*officehub*"}         | Remove-AppxPackage
$packages | Where-Object {$_.PackageFullName -like "*feedbackhub*"}       | Remove-AppxPackage
 
# Connects to your mobile phone for notification mirroring, cortana services
$packages | Where-Object {$_.PackageFullName -like "*oneconnect*"}        | Remove-AppxPackage
#endregion
 
#region remove provisioning packages (Removes for future users)
$appProvisionPackage = Get-AppxProvisionedPackage -Online
 
$appProvisionPackage | Where-Object {$_.DisplayName -like "*windowscommun*"} | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*people*"}        | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*surfacehu*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*zune*"}          | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*xboxapp*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*windowspho*"}    | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*skypeap*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*messaging*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*onenote*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*sway*"}          | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*solitaire*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*commsphone*"}    | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*3DBuild*"}       | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*getstarted*"}    | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*officehub*"}     | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*feedbackhub*"}   | Remove-AppxProvisionedPackage -Online
$appProvisionPackage | Where-Object {$_.DisplayName -like "*oneconnect*"}    | Remove-AppxProvisionedPackage -Online
#endregion
 
<#restoration howto
To rol back the Provisioning Package removal, image a machine with an ISO and then copy the source files from
the c:\Program File\WindowsApps directory.  There should be three folders per Windows 10 app.  These need to
be distributed w/ SCCM to the appropriate place, and then run
    copy-item .\* c:\Appx
    Add-AppxProvisionedPackage -Online �FolderPath c:\Appx
 
    $manifestpath = "c:\appx\*Appxmanifest.xml"
    PS C:\> Add-AppxPackage -register $manifestpath �DisableDevelopmentMode
#>
 
#removes the Windows Fax feature but requires a reboot, returning a 3010 errorlevel.  Ignore this error
cmd /c dism /online /disable-feature /featurename:FaxServicesClientPackage /remove /NoRestart

```

####  Do you have any recommendations

Did I miss any?  If so, comment here or on [/R/FoxDeploy](http://www.reddit.com/r/FoxDeploy) and I'll add it!
