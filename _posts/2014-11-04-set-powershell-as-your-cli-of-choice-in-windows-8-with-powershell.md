---
title: "Set PowerShell as your CLI of choice in Windows 8.  WITH POWERSHELL"
date: "2014-11-04"
redirect_from : /2014/11/04/set-powershell-as-your-cli-of-choice-in-windows-8-with-powershell
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "quickies"
  - "scripting"
tags: 
  - "command-prompt"
  - "powershell"
---

In a conversation on Twitter, I lamented with some friends that Hitting Windows+X in Windows 8 and above opens up the admin window, but still--In 2014--lists Command Prompt as the CLI.

![PowerShellWPowerShell](../assets/images/2014/11/images/powershellwpowershell.png) Maybe in Windows Vista this would have made sense...but PowerShell had already been out for SIX YEARS when Windows 8 shipped.

With one single line of PowerShell, we can right this grieveous wrong.

```powershell 
 Set-ItemProperty HKCU:\\Software\\Microsoft\\Windows\\CurrentVersion\\Explorer\\Advanced \` -Name "DontUsePowerShellOnWinX" -Value 0 
```

[![yoDawg](../assets/images/2014/11/images/yodawg.jpg)](../assets/images/2014/11/images/yodawg.jpg)

 

And to test it...

[![PowerShellWPowerShell1](../assets/images/2014/11/images/powershellwpowershell1.png)](../assets/images/2014/11/images/powershellwpowershell1.png)


![aaawwwyeah](../assets/images/2014/11/images/aaawwwyeah.jpg)