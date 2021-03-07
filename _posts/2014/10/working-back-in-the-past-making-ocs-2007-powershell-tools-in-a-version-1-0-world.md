---
title: "Working back in the past: making OCS 2007 PowerShell tools in a Version 1.0 World"
date: "2014-10-03"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

Recently, I had to work on an environment with PowerShell v. 1.0 (and I couldn't upgrade it!) and Microsoft Office Communications Server 2007 (or OCS for those of us in the know).

Unfortunately for me, this became a journey of pain and discovery as I dove deep back into the dark annals of PowerShell history.

Here is a short list of things that did not work:

- My modern day approach to tool writing includes throwing in Confirm and WhatIf as a matter of course, especially with potentially harmful actions like stripping OCS attributes from an account. WhatIf and $PSCmdlett don't exist!
- I like to set my tools up to do one of the following actions: create, set, process, report on particular types of objects. This means that I make liberal use of \[Parameter\] declarations relating to Pipeline input and aliases, all standard advanced functions nowadays. Advanced functions weren't added until PS version 2.0!
- I think it is due dilligence to make help and documentation for our tools, especially if they may outlive you in an environment. So for each of my functions, I added Comment-Based help. Guess what? Comment-based help wasn't supported until PS version 2.0!
- Comment blocks? Nope, Version 2.0, so I hope you like Batch style walls of hash signs.
- \[CmdletBinding\] for -Debug or -Whatif? Nope, 2.0.
- Running remotely? Nah! Version 2.0 introduced this feature, so enjoy running these commands locally, or tunneled through PSExec.

In the end, the functions I was left with worked, but felt very…very basic. In any case, here are a set of tools to help you enable, process and disable OCS users with PowerShell.

Note that you need to run these commands from an OCS server itself if you're running PS 1.0. If you're on a newer version, feel free to adapt these to work with you.

Big credit to this blog post for showing me the original WMI class to query for OCS info - http://blog.insideocs.com/2009/01/16/189/

\[code language="powershell"\] #################################################################### # ----Name : OCS 2007 Account Manipulation tools # ---Author: Stephen Owen, 10/3/2014 # ----Ver 1: Release Version, all basic features provided but unfortunately advanced features like true whatif and true pipeline support won't work due to PowerShell limitations # Function : A set of tools based on this blog post to speed up Enabling and Disabling OCS accounts en masse - http://blog.insideocs.com/2009/01/16/189/ # ---Usage : Use Get-OCSUser to obtain a list of all user accounts in OCS, filter this using Where-Object commands or comparisons and pipe into Disable or Enable-OCSuser Cmdlettes ##########################################

Function Get-OcsUser{

#.Synopsis # A simpler wrapper for Get-WMIObject on the Microsoft SIPEUser Class #.DESCRIPTION # Long description #.EXAMPLE # To obtain a list of all OCS Users # # Get-OCSUser -Fi;; #.EXAMPLE # To obtain only the users from OCS which match those found in a text file # # Get-OCSUser | Where { (Get-Content C:\\temp\\DisableOCS.txt) -contains $\_.DisplayName}

param(\[switch\]$Full) if ($Full){ Get-WmiObject -class MSFT\_SIPESUserSetting } else{ Get-WmiObject -class MSFT\_SIPESUserSetting -Property DisplayName,Enabled,EnabledForEnhancedPresence,EnabledForFederation,UserCategory,PrimaryURI,InstanceID | Select DisplayName,Enabled,EnabledForEnhancedPresence,EnabledForFederation,UserCategory,PrimaryURI,InstanceID } }

Function Enable-OcsUser{ ## #.Synopsis # A wrapper for cretain WMI calls using Get-WMIObject on the Microsoft SIPEUser Class to enable users ##.DESCRIPTION ##Use this wrapper to ease the enablement of OCS Users using PowerShell. Be sure to see the Examples for usage notes, as #PowerShell v1 limitations force some peculiar usage steps. #.EXAMPLE ## Step 1 Obtain a list of all OCS Users and store in $OCS or a similar string ## ## $OCS = (Get-OcsUser) ## ## Step 2 Verify user to enable ## ## $OCS | Where-Object {$\_.PrimaryURI -eq "sip:Testy.McDelete@foxDeploy.com"} ## ## Step 3 ENABLE ## ##$OCS | Where-Object {$\_.PrimaryURI -eq "sip:Testy.McDelete@foxDeploy.com"} | ForEach-Object {Enable-OCSUser -PrimaryURI $\_.DisplayName} #.EXAMPLE ## To obtain only the users from OCS which match those found in a text file, then enable them. NOTE the usage of -WhatIf. ## ## Get-OCSUser | Where { (Get-Content C:\\temp\\DisableOCS.txt) -contains $\_.DisplayName} | ForEach-Object {Enable-OCSUser -PrimaryURI $\_.DisplayName -WhatIf} ## Param($PrimaryURI,\[switch\]$WhatIf) ForEach ($SIP in $PrimaryURI) { #get-wmiobject -class MSFT\_SIPESUserSetting | where-object { $\_.PrimaryURI -eq “sip:userid@SIPDomain” } | % { $\_.Enabled = $True; $\_.put() | out-null } if ($WhatIf){ "Safety enablied, Would be enabling $PrimaryURI" } ELSE{ "Safety released, actually enabling $SIP" Get-WmiObject -class MSFT\_SIPESUserSetting | Where-Object { $\_.DisplayName -eq $SIP } | ForEach-Object { $\_.Enabled = $False; $\_.put() Get-OcsUser | Where-Object {$\_.DisplayName -eq $SIP}} }

} }

Function Disable-OcsUser{ ## #.Synopsis # A wrapper for cretain WMI calls using Get-WMIObject on the Microsoft SIPEUser Class to disable users ##.DESCRIPTION ##Use this wrapper to ease the deletion of OCS Users using PowerShell. Be sure to see the Examples for usage notes, as #PowerShell v1 limitations force some peculiar usage steps. #.EXAMPLE ## Step 1 Obtain a list of all OCS Users and store in $OCS or a similar string ## ## $OCS = (Get-OcsUser) ## ## Step 2 Verify user to disable ## ## $OCS | Where-Object {$\_.PrimaryURI -eq "sip:Testy.McDelete@foxDeploy.com"} ## ## Step 3 DELETE ## ##$OCS | Where-Object {$\_.PrimaryURI -eq "sip:Testy.McDelete@foxDeploy.com"} | ForEach-Object {Disable-OCSUser -PrimaryURI $\_.DisplayName} #.EXAMPLE ## To obtain only the users from OCS which match those found in a text file, then disable them. NOTE the usage of -WhatIf. ## ## Get-OCSUser | Where { (Get-Content C:\\temp\\DisableOCS.txt) -contains $\_.DisplayName} | ForEach-Object {Disable-OCSUser -PrimaryURI $\_.DisplayName -WhatIf} ##> Param($PrimaryURI,\[switch\]$WhatIf) ForEach ($SIP in $PrimaryURI) { if ($WhatIf){ "Would be Disabling $PrimaryURI" } ELSE{ "Safety released, disabling $SIP" Get-WmiObject -Class MSFT\_SIPESUserSetting | Where-Object { $\_.DisplayName -eq $SIP } | ForEach-Object { $\_.Enabled = $False; $\_.put() Get-OcsUser | Where-Object {$\_.DisplayName -eq $SIP} } }

} }

\[/code\]
