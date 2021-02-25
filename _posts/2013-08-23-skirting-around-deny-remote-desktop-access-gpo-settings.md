---
title: "Skirting around 'Deny Remote Desktop Access' GPO Settings"
date: "2013-08-23"
redirect_from : /2013/08/23/skirting-around-deny-remote-desktop-access-gpo-settings
excerpt : "From time to time, I'll encounter this issue.  You're troubleshooting an issue and need to Remotely log-on to a workstation.  You've effectively got the keys to the kingdom, and yet a desktop workstation GPO prevents you from logging on remotely.  Such a bummer!  Fortunately, if we know how GPO works...we can hack our way around it! "
categories: 
  - "other"
tags: 
  - "bypass"
  - "gpo"
  - "security"
---

From time to time, I'll encounter this issue.  You're troubleshooting an issue and need to Remotely log-on to a workstation.  You've effectively got the keys to the kingdom, and yet a desktop workstation GPO prevents you from logging on remotely.  Such a bummer!

Fortunately, if we know how GPO works (mostly by applying registry settings under the `HKEY\_Current\_User\Software\Policies and HKLM:\Software\Policies` trees among other places) we can work around this, assuming the appropriate levels of permission.

First, Connect to the Remote Workstation using Computer Manager.  Browse to Services and enable the Remote Registry and Remote Desktop Services.

Next, open Regedit and Connect to Remote Registry Hive or the target workstation.  Browse to `HKLM:\System\CurrentControlSet\Control\Terminal Server` and change the `Reg_DWORD` value of fDenyTSConnection to 0 (or 0x00000000 if you love hex).

You should now be able to remote desktop into the workstation.  Depending on how the policies are applied in your domain, this will only last as long as the next policy application period, however.  Normally you'll get at least one logon out of it.
