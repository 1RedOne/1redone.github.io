---
title: "Three tips for effectively using Try/Catch in PowerShell"
date: "2014-07-16"
redirect_from : /2014/07/16/three-tips-for-effectively-using-trycatch-in-powershell
coverImage: goes here...
categories: 
  - "scripting"
tags: 
  - "noscript"
  - "theory"
---

## Preamble

As my responsibilites have grown and I've found myself crafting tools not just for my own use, but that will outlive me at clients and within the firm, I've recently become a complete convert to using error-handling in my functions.

If you've ever been in a situation in which you're using someone else's tools and they don't account for common errors, I'm sure you understand the need for including common error-checking an validation in your own toolmaking. If you've never run into it yourself, maybe my tale can help you.

Long ago, in an SCCM migration project, I took over midstream for the build out of eighteen some-odd Secondary Site servers of an entrenched ConfigMan infrastructure. My task was to rebuild these Distribution Points (DPs) from 2003 to 2008 R2 Server, and to assist, a number of tools had been created. One streamlined the installation of prerequisites, while another--ExportPKGs--exported a list of all packages on the site as .PKG files I'd copy to the destination server. This tool also created a manifest of all of the packages found and included in the directory, ExportPKGs.txt. Finally, ImportPKGs would import those .PKG files directly into the target site server by means of automating the PreloadPkgOnSite.exe binary included in SCCM.

The issue that arose was that when using the ExportPKG, a log file was created which stored the status of each package on site. When I'd then run the ImportPkg tool, this same log file would be imported and the items enumerated, then fed into PreloadPkgOnSite.exe binary to import the package, thereby bypassing a lengthy copy operation from the primary to this new DP. When the Import tool ran, it would record a backup of the log file specified in the InputFile parameter, then overwrite the log file with its results.

Since these DPs were all over the world, I had to work some very odd hours (almost as odd as what I'm working right now from the East coast USA to migrate AD users in New Zealand in their own work hours) and during a particularly weird one, I flubbed the syntax of the command. This meant that the following files existed: • ExportPKGs - Now contained garbage, 0 length • BackupPKGs - Contained the previous content of ExportPKGs

Realizing my mistake, I then dilligently reread my syntax, then accidentally hit Up and then Enter into the command prompt. Both log files now contained garbage and I was no longer able to import the TXT file. To resolve the situation, I had to manually push all the likely packages from the 2007 Primary Site to this DP. What would have been a four hour decompress and import operation became a 28 hour slog of copy-decompress-import. It was a mild nightmare.

This issue clarified forever the need for good error proofing and validation in my tools. In my work, I've come up with the following tips for properly implementing Try/Catch in your PowerShell functions and tools.

![](../assets/images/2014/07/images/failsafe1.jpg)

## Tip 1 Be lazy

It's unpleasant to admit it, but we know that our users may not always be the most diligent about reading instructions. Yes, your elegantly crafted Word doc may go unperused, your beautiful Readme.txt may not be bookmarked and even your properly-implemented comment-based help may never be read. Trust on your users to skip all dialog boxes, dismiss all popups for credentials, and provide pure garbage for what mandatory parameters you do specify.

You can work around this by including parameter validation to ensure that your inputs really make sense for your process. Run through the tool, and try to imagine what mistakes a user might make. Maybe your parameter or switch names are too similar, or rely on easily confused nomenclature. Try to dismiss all credential, file-picker and other similar dialog boxes.

## Tip 2 Have a friend try your code

We know how our code should work, in fact, most of the time, we could do the process manually and are making tools to enable others to perform a subset of tasks with safeties in place, or to save our own time. Since we know what to do, we also know which parameters or switches really matter, and whether or not we're actually supporting pipeline input in our function. We know to provide data in a single-item per line form, not a comma separated value or Excel file!

Having a friend test your code will show you all of the ways you never thought to run your code. And adding the error handling for this will likely double the length of your functions if not more.  When you walk your tester through the process, begin with giving hardly any instruction at all.  Ideally, you'll catch a half-dozen or more instances in which you can better your coding through Error Checking.

On a recent project, it wasn't until I was scheduled to go on vacation and had to train someone else on one of the tools I created that I realized how many different ways he may innocently misuse the tool, and with potentially disastrous affect!

## Tip 3 Don't use a catch-all

This is the ostrich method to dealing with problems. If you set a single catch statement, or worse, use -ErrorAction SilentlyContinue, you're just denying problems and can end up deep into your tool with no real idea of what kind of input you're dealing with. You're setting yourself up for a resume generating event if you do this.

## Tip 4, Bonus tip: Fail safe

I said three tips, but I had to throw in this bonus. It's used in weapons systems, reactors, and automated investment platforms (well, sort of): fail safes.

If you're unsure of the quality of your Error Catching, try to ensure that under worse-case scenario circumstances, you don't pull an Emory or nuke your datacenter from orbit.

> Scripting can very easily turn one small problem into infrastructure wide outages, and turn you from being a respected automation engineer into that guy who accidentally nuked the CEO's Laptop

One method I like to use on my tools destined for others is to add a mandatory -WhatIf to very serious commands.  I effectively override ConfirmImpact settings to make my end-users confirm that they really want to move User A into Groups A-Z or likewise.  It's just one more click but adding a measure like this can ensure that your users are reading impact (for instance, you can use $Confirm = Read-Host "Type Confirm exactly as listed on screen to commit $action" or something similar as a method of shifting culpability to those who should know better).

An additional trick to failing safe it to set a subset of actions as Verboten and never allow them to execute.  If you have a Function which removes users from a Security Group, at no point should Domain Admins or Enterprise Administrators be allowed as acceptable input.
