---
title: "Using Powershell Internet Explorer Object automation to save work!"
date: "2013-08-23"
redirect_from : /2013/08/23/using-internet-explorer-object-automation-to-save-work
excerpt: "At one client, I had to use the Microsoft Baseline Security Analyzer to obtain a list of locally installed patches on all workstations.  This application runs a check for installed patches on target workstations, and returns the output of a .CSV file (I'm leaving out some steps, but this is close enough.)  However, this list leaves a lot to be desired, namely what the patches or KBs were meant to address, among other issues.  As the clients wanted to review over and approve each update before proceeding with the project, I had to do something about this."
categories: 
  - "scripting"
tags: 
  - "mbsa"
  - "powershell"
---

Hi all,

At one client, I had to use the Microsoft Baseline Security Analyzer to obtain a list of locally installed patches on all workstations.  This application runs a check for installed patches on target workstations, and returns the output of a .CSV file (I'm leaving out some steps, but this is close enough.)  However, this list leaves a lot to be desired, namely what the patches or KBs were meant to address, among other issues.  As the clients wanted to review over and approve each update before proceeding with the project, I had to do something about this.

I could have manually googled each KB to see what the article said about them, but that would take way too much time, as there were hundreds of individual updates installed around the environment.

To solve this problem I used Powershell to create this function which reads the KB numbers from the CSV file, automates an invisible Internet Explorer object, and then reads the page title from each article (which, fortunately enough, contained a nice summary of the purpose of each KB!) to fill in the missing information.

I've since reused this at other clients and saved countless hours of manual work, I hope it will help you!

```
$ie = new-object -com “InternetExplorer.Application”
$i=$null 
$entries = (Import-Csv ‘F:\Consulting Tools\MBSA\_desktop_installed_patches.csv’).Count

$values = Import-Csv ‘F:\Consulting Tools\MBSA\_desktop_installed_patches.csv’ | % { 
    $i++; 
    Write-host “$i out of $entries” 
    if ($_.Description.Length -le 2){
        $kbNo = $_.ServicePackInEffect.Replace(“KB”,””) 
        $ie.navigate(“http://support.microsoft.com/kb/$kbNo”) 
        while($ie.busy) {
            Write-host “Loading…“;
            start-sleep -Milliseconds 25
        } #$ie.LocationName
    $_.Description = $ie.LocationName 
    $kbNo ; 
    $_.Description }

} |	Export-Csv ‘C:\temp\_desktop_installed_patches_converted.csv’
```

