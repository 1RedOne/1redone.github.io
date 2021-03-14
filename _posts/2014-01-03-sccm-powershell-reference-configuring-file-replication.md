---
title: "SCCM PowerShell Reference : Configuring File Replication"
date: "2014-01-03"
redirect_from : /2014/01/03/sccm-powershell-reference-configuring-file-replication
categories: 
  - "quickies"
tags: 
  - "powershell"
  - "sccm"
---
[![Depicts an image saying 'Scripting System Center Configuration Manager'](../series/images/series_sccm.png)](/series/LearningSCCM)

This post is part of the 'Scripting SCCM' series on FoxDeploy, click the banner for more!  

* * * 

This is a little quicky.  I've found the documentation both on TechNet and in PowerShell's in-line help to be very lacking for the new Configuration Manager Commandlettes, so I did the work to figure them out on my own and will post some of what I've learned here.  I recently needed to configure Bandwidth Control for a client and loathed manually setting these options on all of the servers, so I turned to PS.   In my example, I needed to restrict package transfer at certain times, and during those times, also control how much bandwidth was being used.

To limit package transfers between all servers to Medium and High priority between 6 and 5:00 (corresponding to the Schedule Tab under Administration|Hierarchy Configuration|File Replication)

```powershell
Get-CMFileReplicationRoute | Set-CMFileReplicationRoute -DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday -ControlNetworkLoadSchedule -TimePeriodStart 6 -TimePeriodEnd 17 -AvailabilityLevel MediumHigh
```

The Options for -AvailabilityLevel are :

- All - transfer all packages
- Closed - transfer no packages
- High - transfer only High Priority Packages
- MediumHigh - transfer Medium and High Priority Packages

Set the bandwidth consumed between all servers to 30% between 6 and 5:00 (Corresponding to options you would set on the 'Rate Limits' tab)

```powershell
Get-CMFileReplicationRoute | Set-CMFileReplicationRoute -Limited -LimitAvailableBandwidthPercentage 30 -LimitedTimePeriodStart 6 -LimitedTimePeriodEnd 17
```

Combining the two commands proved to be difficult, as PowerShell would get hung up on -Limited thinking it was an ambiguous parameter.  I ended up running them separately.  Hope this helps!
