---
title: "SCCM - Updating all drivers after a migration"
date: "2016-01-20"
categories: 
  - "scripting"
tags: 
  - "configmgr"
  - "powershell"
  - "sccm"
---

Every time you migrate from one SCCM instance to another, or if you have to move your drivers around (for instance: you originally had your drivers placed on the c:\\ and want to mover them to another drive), you'll need to update the location not only of DriverPackages, but also of all drivers as well.

This has been something that I MIGHT have forgotten more than once.  More than twice even.

So I wrote up this script.

This script assumes that you've already moved your drivers from their original location to their final resting place.  It also supports adjusting the path based on driver folder as well.  I'm a firm believer that SCCM Drivers should be stored in as small a folder structure as is possible, here's how I normally layout my content for SCCM:

| Type Of Content | Location | Shared Path |
| --- | --- | --- |
| All SCCM Content | D:\\ContentSource | \\\\SCCM\\Content\\ |
| Drive Source Files | D:\\ContentSource\\Drivers | \\\\SCCM\\Content\\Drivers |
| Driver Packages | D:\\ContentSource\\DriverPackages | \\\\SCCM\\Content\\DriverPackages |

So when I saw that this instance of SCCM had the content in the C:\\ drive, and also had very long path names, I had to truncate things.  That's why in this script, you'll see separate logic for HP, Dell and Sony Drivers, as we needed to shorten those paths a bit.

| Original Path | New Path |
| --- | --- |
| Drivers\\HP Drivers | Drivers\\HP |
| Drivers\\Dell Drivers | Drivers\\Dell |
| Drivers\\Sony Drivers | Drivers\\Sony |

Assuming you're moving your drivers from one system, to another, simply update the path on lines 8, 16 & 24.  If you don't need to change folders, like I'm doing, then you can delete the three blocks and only use one.

Finally, this will take a LONG, LONG time.  We had ~3,000 drivers and it took about three hours or so.

Output looks like this:

[![IMG_3827](https://foxdeploy.files.wordpress.com/2016/01/img_3827.jpg?w=636)](https://foxdeploy.files.wordpress.com/2016/01/img_3827.jpg)

\[code language="powershell" highlight="8,16,24"\] Set-CMQueryResultMaximum -Maximum 5000

$drivers = get-cmdriver

foreach ($driver in ($drivers)) {

If ($driver.ContentSourcePath -like &quot;\*PackageSource\*hp drivers\*&quot;){ $newPath = $driver.ContentSourcePath -replace 'PackageSource\\\\Drivers\\\\HP Drivers','DriverPackages\\HP' Write-host -ForegroundColor Cyan &quot;Changing PkgSourcePath for $($driver.Name)...&quot; $newPath Set-CMDriver -Id $driver.CI\_ID -DriverSource $NewPath timeout 5 }

If ($driver.ContentSourcePath -like &quot;\*PackageSource\*dell\*&quot;){ $newPath = $driver.ContentSourcePath -replace 'PackageSource\\\\Drivers\\\\Dell Drivers','DriverPackages\\Dell' Write-host -ForegroundColor Cyan &quot;Changing PkgSourcePath for $($driver.Name)...&quot; $newPath Set-CMDriver -Id $driver.CI\_ID -DriverSource $NewPath timeout 5 }

if ($driver.ContentSourcePath -like &quot;\*PackageSource\*sony\*&quot;){ $newPath = $driver.ContentSourcePath -replace 'PackageSource\\\\Drivers\\\\Sony Drivers','DriverPackages\\Sony' Write-host -ForegroundColor Cyan &quot;Changing PkgSourcePath for $($driver.Name)...&quot; $newPath Set-CMDriver -Id $driver.CI\_ID -DriverSource $NewPath timeout 5 }

} \[/code\]
