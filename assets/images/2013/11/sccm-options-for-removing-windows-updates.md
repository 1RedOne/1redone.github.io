---
title: "SCCM - Options for Removing Windows Updates"
date: "2013-11-21"
tags: 
  - "sccm"
---

Recently, a client had an issue with a particular patch to Office interfering with a line of business application.  The patch in particular was KB 2826026 - Office 2010 update: October 8, 2013.  Normally the procedure to uninstall a patch is to use Group Policy or SCCM to push out the following Windows Update Stand Alone tool command:

`WUSA /uninstall /kb:2826026`

However this only works with Windows Operating System Updates (which are deployed in the MSU format).  When dealing with a software product update like this one for Office, the correct answer is to look in the registry for information about the update.

Browse to: `HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\`, and then search for the KB number of the update you need to remove.  Once found, look at the Uninstall String, and you'll see a value like this:

`"C:\Program Files\Common Files\Microsoft Shared\OFFICE14\Oarpmany.exe" /removereleaseinpatch "{90140000-0011-0000-0000-0000000FF1CE}" "{D7D96A96-F61F-48AD-B2DC-4F4B6938D2AB}" "1033" "0"`

This command will remove the offending patch, but requires manual intervention (clicking Yes) and then will force a restart.  You can use these values with an MSIexec command though to run the removal of the patch through Windows Installer, which will allow for logging and standard reboot controls, etc.

Use this example to help you create your MSI command:

`msiexec /package {90140000-0011-0000-0000-0000000FF1CE} MSIPATCHREMOVE={D7D96A96-F61F-48AD-B2DC-4F4B6938D2AB} /qb /norestart /l+ c:\windows\system32\ccm\logs\KB2826026_unins.txt`

This may force the shutdown of Office, and will not complete until the system has restarted, however.
