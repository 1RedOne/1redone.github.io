---
title: "Set PowerShell as your CLI of choice in Windows 8.  WITH POWERSHELL"
date: "2014-11-04"
categories: 
  - "quickies"
  - "scripting"
tags: 
  - "command-prompt"
  - "powershell"
---

In a conversation on Twitter, I lamented with some friends that Hitting Windows+X in Windows 8 and above opens up the admin window, but still--In 2014--lists Command Prompt as the CLI.

![PowerShellWPowerShell](images/powershellwpowershell.png) Maybe in Windows Vista this would have made sense...but PowerShell had already been out for SIX YEARS when Windows 8 shipped.\[/caption\]

With one single line of PowerShell, we can right this grieveous wrong.

\[code language="powershell" light="true"\]Set-ItemProperty HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced \` -Name "DontUsePowerShellOnWinX" -Value 0 \[/code\]

![](https://foxdeploy.files.wordpress.com/2014/11/yodawg.jpg)

 

And to test it...

![](https://foxdeploy.files.wordpress.com/2014/11/powershellwpowershell1.png)

 

![aaawwwyeah](images/aaawwwyeah.jpg)
