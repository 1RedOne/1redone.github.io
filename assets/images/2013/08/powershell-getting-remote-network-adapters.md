---
title: "PowerShell - getting Remote network adapters"
date: "2013-08-30"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

Hi all,

Today I needed to get the remote network adapters for a group of computers, to determine if they all had a common issue.  Rather than RDP into 18 servers, a few characters of Powershell did all the work for me.

In my case, I needed the remote server name, and also the Caption for the NIC.

`$computername = "SERVER_1", "SERVER_2", "SERVER_3", "SERVER_4", "SERVER_5", "SERVER_6", "SERVER_7", "SERVER_8", "SERVER_9", "SERVER_10", "SERVER_11", "SERVER_12", "SERVER_13", "SERVER_14", "SERVER_15", "SERVER_16", "SERVER_17", "SERVER_18"`

$computername | % { Get-WmiObject Win32\_NetworkAdapter -ComputerName $\_ | \` ? {$\_.AdapterType -eq 'Ethernet 802.3'} | Select \_\_SERVER, Caption }

Here is an example of the output.

 

[![GetNetAdapters](http://foxdeploy.files.wordpress.com/2013/08/getnetadapters.png?w=440)](http://foxdeploy.files.wordpress.com/2013/08/getnetadapters.png)
