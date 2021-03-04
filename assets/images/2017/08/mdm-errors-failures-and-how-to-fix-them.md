---
title: "MDM errors failures and how to fix them"
date: "2017-08-04"
categories: 
  - "sccm"
tags: 
  - "enrollment"
  - "mdm"
  - "troubleshooting"
coverImage: "enrollment-errors-and-how-to-fix-them.png"
---

Over the course of this many month Air-Watch MDM project I've been conducting, I have run into WAY more than my fair share of MDM enrollment related issues.

Troubleshooting MDM issues presents a whole new set of difficulties, because where SCCM provides glorious log files with tons of community engagement and answers, MDM gives you hard to locate Windows Event logs. Every SCCM error code is meticulously documented on the web, where MDM errors give you this result:

![](https://foxdeploy.files.wordpress.com/2017/08/errors01.png?w=636)

This is how you know you are WAY off the reservation!

Never fear though, for I have compiled the most common and frustating errors which I have painstakingly worked through into this, very originally named volume

![](images/enrollment-errors-and-how-to-fix-them.png)

#### Where to find enrollment errors

You can monitor the status of an enrollment in the Windows Event Viewer, under this area:

\[caption id="attachment\_5020" align="alignnone" width="636"\]![](https://foxdeploy.files.wordpress.com/2017/08/errorsevent.png?w=636) Microsoft-Windows-DeviceManagement-Enterprise-Diagnostics-Provider/Admin\[/caption\]

It is routine to see some errors here, so not all errors need to be solved, however when you're trying to troubleshoot why a machine won't enroll in MDM, then you should be looking here first.  

When you do find an error message, it's not going to look like 'Cannot find file', instead, it will look something like this:

\[code\]MDM ConfigurationManager: Command failure status. Configuration Source ID: (f5a99910-eb59-4f19-89d2-4cab0fa591b8),

Enrollment Name: (Provisioning), Provider Name: (Provisioning),

Command Type: (CmdType\_Add), CSP URI: ./Vendor/MSFT/Provisioning/Enrollments/staging@ITTT.com">./Vendor/MSFT/Provisioning/Enrollments/staging@FoxDeploy.com),

Result: (Unknown Win32 Error code: 0x80192ee7).\[/code\]

The error code at the very end is what we're looking for.

#### How to decipher most errors

 

You can always use the reliable and venerable SCCM Log File Viewer, CMtrace.exe to track down an error code. Simply open the app and hit Control+L

![](https://foxdeploy.files.wordpress.com/2017/08/errorscmtrace-e1501860787167.png?w=300)

This utility contains most Windows core error messages, and is particularly good when it comes to SCCM errors, but some are not documented here...

#### Err.exe, an oldie but goodie

This tool, also known as the Microsoft Exchange Server Error Lookup tool 2007 hearkens from an era in which Microsoft was still paid by the letter for application names, and we had tools with easy to say names like System Center 2012 R2 Configuration Manager with Service Pack 1 Cumulative Update 5.

The tool was deployed along with Exchange 2007, but is still awesome and amazingly useful. You [can download it here](https://www.microsoft.com/en-us/download/details.aspx?id=985).

Simply install it, and then add the folder to your path, or copy it into `C:\Windows\System32`. Then, call it like so

\[code\]err 80192ee7 # as an HRESULT: Severity: FAILURE (1), Facility: 0x19, Code 0x2ee7

\# for hex 0x2ee7 / decimal 12007 : ERROR\_INTERNET\_NAME\_NOT\_RESOLVED inetmsg.h ERROR\_INTERNET\_NAME\_NOT\_RESOLVED wininet.h # 2 matches found for "80192ee7"\[/code\]

#### For the REALLY tough errors

For the weirdest of the weird ones, you can search the header source symbols for Windows, which have kindly been placed online in this GitHub repo for the Windows Software Development Kit. Amazingly, I found answers to my issues here more often than I should have.

[Windows Software Development Kit GitHub Page](https://github.com/tpn/winsdk-10/blob/master/Include/10.0.10240.0/um/cfgmgr2err.h#L238)

Simply go there and Control+F your way to victory. There are also a lot of interesting tidbits to be found there as well.

### Common Enrollment Failure Codes and Resolutions

Now that I've covered how you can find your own answers, here are some of the most common MDM Enrollment errors I've encountered.  Often times, the first few characters of the code may be different.  The final five characters are most important:

#### 0x8004002 - File Not Found -

Something happened and the Provisioning Package file can't be read. We observed this happen when our antivirus blocked the Provisioning engine, Provtool.exe from, decompressing itself, or blocked a file copy operation.

If you're running the ppkg from a thumb drive or network drive, try to copy the file to the C:\\ and run instead.

Ensure Bit9, Microsoft Forefront, or Symantec isn't blocking the PPKG file.

#### 0x8004005 - Access Denied

This occurs when UAC is disabled, or when someone clicks 'No' at the MDM enrollment prompt

#### 0x8600023 - Already Imported this Package

This PPKG has been attempted before and failed.

Remove the PPKG file by navigating to PC Settings \\ Accounts \\ Access Work and School \\ Add Remove a provisioning Package. Click the Provisioning Package and choose Remove.

This UI often freezes in Windows 2016 LTSB.  If it does, close the Settings page and attempt to remove again.

If the PPKG is missing upon returning to this screen, attempt to run the PPKG again If the package fails again, you can remove all PPKG references within the registry by deleting all children from these two keys.

HKEY\_LOCAL\_MACHINE/SOFTWARE/MICROSFT/Enrollments HKEY\_LOCAL\_MACHINE/SOFTWARE/MICROSFT/EnterpriseResourceManager

#### 0x80180026 - Device is ExternallyManaged

This occurs when a device is locked in ProvisioningMode. Repair this by changing the following registry key:

`HKLM\Softrware\Microsoft\Enrollments\ExternallyManaged`, set the key equal to 0.

#### 0x80192ee7 - Network Name Not resolved

This one, which resulted in ZERO Google Results before, simply means that either DNS isn't available, or (more likely) that your machine does not have internet access.

Ensure your MDM target device has web access and relaunch the package and it should enroll again.

### Will Windows attempt to re-enroll?

If initial provisioning fails, the Provisioning Image will retry three times in a row.  If these attempts fail, a scheduled task will be created to retry four additional times in a decaying rate of time.

15 Minutes -> 1 hour -> 4 hours -> Next System Start

If this still fails, the machine will persistently attempt to re-enroll at each login, when idle.

I'll update this document as I run into additional errors.  Find an error that I haven't covered here?  Hit me up in the Comments or [/r/FoxDeploy!](http://reddit.com/r/foxdeploy)
