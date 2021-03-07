---
title: "Upgrade your SCOM Notifications with PowerShell"
date: "2014-02-17"
redirect_from : /2014/02/17/upgrade-your-scom-notifications-with-powershell
categories: 
  - "scripting"
excerpt: "in this post, we talk about how to provide more detailed alerts in SCOM Messages.  This was for a project with a customer I've now forgotten, where we did a rip and replace of another product that I've also forgotten.  I bascally don't remember any of this... "
---

At a client recently for a proof of concept job, we implemented OpsManager to replace an existing monitoring product they were using in their environment.

Out of the gates, they loved it!  SCOM had out of the box management functionality for most the equipment in their environment, and with installing just a few quick management packs, they were able to monitor everything they wanted.  It was great, it was easy and everyone had that warm, fuzzy feeling of IT Project Satisfaction.

One of the major concerns we began to hear was that the out of the box alerts from SCOM weren't very informative.  For instance, an e-mail would tell you that an alert was triggered, and when and on which computer, but other than that, you were kind of on your own.

I was quickly volunteered eager to jump into the fray, employing two of my favorite tools to fix the issue, Orchestrator and PowerShell!

To start, here is the default notification:
```
\-->Alert: ConfigMgr 2007 Component Health:

SMS_PXE_SERVICE_POINT state

Source: sccmpr01

Path: sccmpr01.woodlawn.net

Last modified by: USA\\OPsmgr

Last modified time: 2/11/2014 10:41:32 PM Alert description: sccmpr01

           - ConfigMgr 2007 Component Health: SMS\_PXE\_SERVICE\_POINT state.

            The availability state for SMS component 'SMS\_PXE\_SERVICE\_POINT' in site WD1 changed from 'Online' to 'Failed'.  Its installation state is 'Installed'.  Its execution state is 'Hung'.  This component last provided a heartbeat at '02/11/2014 22:39:23'.  The next heartbeat is expected in '30' seconds from that time.

Alert view link: "[http://scom.woodlawn.net/OperationsManager?DisplayMode=Pivot&AlertID=%7b1\[...\]-aa489%7d]()"

Notification subscription ID generating this message: {6E14B614-838C-77E1-0176-3A369BC231C2}
```
 Yeah, pretty uninspiring.  There is a web link, which is nice, but we can't get to the meat of the issue.  They asked for something which I thought was quite reasonable: "For a disk space alert, why can't I see which disk and what threshold triggered the alert", or "For CPU Usage monitors, how come I can't see a listing of which application are pegging the CPU?".   Seemed pretty reasonable to me. 

So, here is what I did.  Using Orchestrator, I created a runbook that listens for a new Alert or Monitor being created.  For the next step of the runbook, a PowerShell script is run that reaches out using the Operations Manager module and gathers information about the event using various methods and properties.  This information is used to build an HTML e-mail, making liberal use of the Convert-ToHTML -Fragment and -As Table and -As List parameters.

We then run a snippet of code, based on the alert title to gather additional information.  For instance, if the alert is a 'disk space too low' monitor that is exceeded, we may run a WMI query and gather information about the hard drive space free based on the drive letter mentioned in the alert.

The key thing to realize here is that this example just uses a bit of PowerShell to pull out some interesting information already there in Operations Manager, and stores it in a variable which is then string-expanded into an HTML message body.  There are some typos in the text below, all of which stems from the Knowledge base and article info present in OpsMgr.

And here is our final result:

**Alert - NA-SCOM-01 - Logical Disk Free Space is low**

**Information**

This alert was triggered because the following monitor was exceeded:

**Logical Disk Free Space** - Monitor the percentage free space and number of free MBytes remaining on a logical disk. Only when both the low percentage free space threshold and low number of free MBytes threshold is the disk flagged as having low disk free space.

<table class="MsoNormalTable" style="border-collapse:collapse;border:none;" border="1" cellspacing="0" cellpadding="0"><tbody><tr><td style="width:1.15in;border:none;padding:4pt;" valign="top" width="110"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Name</span></b></p></td><td style="width:67.6pt;border:none;padding:4pt;" valign="top" width="90"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Drive Type</span></b></p></td><td style="width:83.65pt;border:none;padding:4pt;" valign="top" width="112"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Volume Name</span></b></p></td><td style="width:48pt;border:none;padding:4pt;" valign="top" width="64"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Name</span></b></p></td><td style="width:61.35pt;border:none;padding:4pt;" valign="top" width="82"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Size (GB)</span></b></p></td><td style="width:95.75pt;border:none;padding:4pt;" valign="top" width="128"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Free Space (GB)</span></b></p></td><td style="width:72.8pt;border:none;padding:4pt;" valign="top" width="97"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><b><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Percent Free</span></b></p></td></tr><tr><td style="width:1.15in;border:none;padding:4pt;" valign="top" width="110"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">NA-SCOM-01</span></p></td><td style="width:67.6pt;border:none;padding:4pt;" valign="top" width="90"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">3a</span></p></td><td style="width:83.65pt;border:none;padding:4pt;" valign="top" width="112"></td><td style="width:48pt;border:none;padding:4pt;" valign="top" width="64"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">C:</span></p></td><td style="width:61.35pt;border:none;padding:4pt;" valign="top" width="82"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">99.90</span></p></td><td style="width:95.75pt;border:none;padding:4pt;" valign="top" width="128"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">1.62</span></p></td><td style="width:72.8pt;border:none;padding:4pt;" valign="top" width="97"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">1.67</span></p></td></tr></tbody></table>

**Thresholds**

The following threshold criteria were evaluated during this alert:

<table class="MsoNormalTable" style="border-collapse:collapse;border:none;" border="1" cellspacing="0" cellpadding="0"><tbody><tr><td style="width:224.85pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Drive Warning MBytes Threshold:</span></p></td><td style="width:51.55pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">500</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:white;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Drive Warning Percent Threshold:</span></p></td><td style="width:51.55pt;border:none;background:white;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">10</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Drive Error Mbytes Threshold:</span></p></td><td style="width:51.55pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">300</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:white;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Drive Error Percent Threshold:</span></p></td><td style="width:51.55pt;border:none;background:white;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">5</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Non System Drive Warning Mbytes Threshold:</span></p></td><td style="width:51.55pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">2000</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:white;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Non System Drive Warning Percent Threshold:</span></p></td><td style="width:51.55pt;border:none;background:white;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">10</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Non System Drive Error Mbytes Threshold:</span></p></td><td style="width:51.55pt;border:none;background:#E7E6E6;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">1000</span></p></td></tr><tr><td style="width:224.85pt;border:none;background:white;padding:4pt;" valign="top" width="300"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Non System Drive Error Percent Threshold:</span></p></td><td style="width:51.55pt;border:none;background:white;padding:4pt;" valign="top" width="69"><p class="MsoNormal" style="margin-bottom:7pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">5</span></p></td></tr></tbody></table>

Click here to view the Alert: "[http://scom.ops.customer.net/OperationsManager?]()\[..\]"

Notification subscription ID generating this message: **Tier II Support - 8 hour Response SLA**

**Knowledgebase**

The following information has been provided to assist in addressing this matter:

**Summary**

The amount of free disk space on the logical disk volume has exceeded the threshold. System performance may be adversely affected and the ability to add or modify existing files on the logical disk volume may not be possible until additional free space is made available.

**Configuration**

The Logical Disk Free Space monitoring routine is a high configurable solution that enables Operators to set varying threshold values for system and non-system logical disk volumes. In addition separate threshold values can be set for Warning and Error states.

Since logical disk volumes may vary in size from a few gigabytes to many terabytes or more the Logical Disk Free Space monitoring routine requires that an Operator indicate both the Megabyte and Percentage based threshold values that must be passed before the Warning and Error thresholds reached. This means that in order for the threshold to be reached both the Megabyte and Percentage based threshold values for the System or Non-System Drive must be breached.

The default threshold values for the Logical Disk Free Space monitoring routine include:

System Drive Free Space Thresholds (Defaults)

Parameter

Default Value

<table class="MsoTableGrid" style="border-collapse:collapse;border:none;" border="1" cellspacing="0" cellpadding="0"><tbody><tr><td style="width:233.75pt;border:solid windowtext 1pt;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">System Drive Error Mbytes Threshold</span></p></td><td style="width:233.75pt;border:solid windowtext 1pt;border-left:none;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">100</span></p></td></tr><tr><td style="width:233.75pt;border:solid windowtext 1pt;border-top:none;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Drive Error Percent Threshold</span></p></td><td style="width:233.75pt;border-top:none;border-left:none;border-bottom:solid windowtext 1pt;border-right:solid windowtext 1pt;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">5</span></p></td></tr><tr><td style="width:233.75pt;border:solid windowtext 1pt;border-top:none;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">System Drive Warning Mbytes Threshold</span></p></td><td style="width:233.75pt;border-top:none;border-left:none;border-bottom:solid windowtext 1pt;border-right:solid windowtext 1pt;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">200</span></p></td></tr><tr><td style="width:233.75pt;border:solid windowtext 1pt;border-top:none;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">System Drive Warning Percent Threshold</span></p></td><td style="width:233.75pt;border-top:none;border-left:none;border-bottom:solid windowtext 1pt;border-right:solid windowtext 1pt;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">10</span></p></td></tr></tbody></table>

Non-System Drive Free Space Thresholds (Defaults)

Parameter

Default Value

<table class="MsoTableGrid" style="border-collapse:collapse;border:none;" border="1" cellspacing="0" cellpadding="0"><tbody><tr><td style="width:233.75pt;border:solid windowtext 1pt;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">Non-System Drive Error Mbytes Threshold</span></p></td><td style="width:233.75pt;border:solid windowtext 1pt;border-left:none;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">1000</span></p></td></tr><tr><td style="width:233.75pt;border:solid windowtext 1pt;border-top:none;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Non-System Drive Error Percent Threshold</span></p></td><td style="width:233.75pt;border-top:none;border-left:none;border-bottom:solid windowtext 1pt;border-right:solid windowtext 1pt;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">5</span></p></td></tr><tr><td style="width:233.75pt;border:solid windowtext 1pt;border-top:none;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">Non-System Drive Warning Mbytes Threshold</span></p></td><td style="width:233.75pt;border-top:none;border-left:none;border-bottom:solid windowtext 1pt;border-right:solid windowtext 1pt;background:#BFBFBF;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;background:silver;">2000</span></p></td></tr><tr><td style="width:233.75pt;border:solid windowtext 1pt;border-top:none;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">Non-System Drive Warning Percent Threshold</span></p></td><td style="width:233.75pt;border-top:none;border-left:none;border-bottom:solid windowtext 1pt;border-right:solid windowtext 1pt;padding:0 5.4pt;" valign="top" width="312"><p class="MsoNormal" style="margin-bottom:.0001pt;line-height:normal;"><span style="font-size:9pt;font-family:'Verdana', 'sans-serif';color:black;">10</span></p></td></tr></tbody></table>

Please note that Overrides can be used to change any of the threshold values that are defined above. In addition these thresholds can be applied to all logical disk volume instances in the management group or if needed separate threshold values can be defined for specific logical disk volume instances.

**Causes**

When existing files grow in size and the new files are added, the free space is taken up on a logical disk. When the amount of free space on the logical disk falls below the threshold, the state for the logical disk will change.

**Resolutions**

To increase the amount of available disk space, do one or more of the following:

· Run Disk Cleanup to gain more free space on the disk.

· Back up and remove files, or delete unnecessary files from the disk.

· Move files to another disk or to offline storage.

· Purchase additional storage or switch to a larger disk.

To view recent disk space history you can use the following view:

Start Disk Capacity View

* * *

This approach uses a runbook to gather the information needed to create this report, however the same could be done using a notification channel in SCOM for the clever.

Big thanks to Sean Duffey for his great blog post [Building a Daily Systems report email with Powershell](https://www.simple-talk.com/sysadmin/powershell/building-a-daily-systems-report-email-with-powershell/) for getting me started down this path.
