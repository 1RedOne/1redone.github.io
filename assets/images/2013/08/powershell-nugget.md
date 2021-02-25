---
title: "PowerShell Nugget"
date: "2013-08-22"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

Ever forget what kind of CPU you have?  Or Motherboard?  Or who produced your RAM?

You could dig around in systems inventory tools for hours...OR you could get the answer in a few keystrokes with PowerShell.

For Motherboard Manufacturer and other info:

> Get-WmiObject Win32\_BaseBoard

This will give a description of the Manufacturer, the Model, Name, Serial, SKU and Product Model of your motherboard.

For CPU and RAM information, look no further than Win32\_Processor and Win32\_PhysicalMemory.

To discover more helpful classes you can type the first few letters of a potential class and append an asterisk and the -List switch to get a list of the classes available.  Also, don't forget to pipe into the Format-List \* command to list all available properties of an object.  Finally, for readability, throw a '| more'  or 'Out-Host -Paging' to the end for /p like functionality.

> Get-WmiObject Win32\_P\* -List | Format-List \* | more

I hope this was helpful!
