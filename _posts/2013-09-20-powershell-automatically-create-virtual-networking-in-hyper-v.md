---
title: "Powershell - Automatically Create virtual Networking in Hyper-V"
date: "2013-09-20"
redirect_from : /2013/09/20/powershell-automatically-create-virtual-networking-in-hyper-v
excerpt: "I've rebuilt my test lab a number of times and have gotten sick of setting up my NICs and VLANs, etc over and over in Hyper-V.  This Powershell script will build a virtual switch for each network device on your host system, binding physical adapters and needed, and then adds each VM to each switch.  Easy peasy!" 
categories: 
  - "virtualization"
tags: 
  - "hyper-v"
  - "powershell"
---

I've rebuilt my test lab a number of times and have gotten sick of setting up my NICs and VLANs, etc over and over in Hyper-V.  This Powershell script will build a virtual switch for each network device on your host system, binding physical adapters and needed, and then adds each VM to each switch.  Easy peasy!

```powershell
Function Build-Networks{ 
    $NetworkAdapters = Get-NetAdapter Get-NetAdapter | % {
        New-VMSwitch -Name ($_.Name + " External Connection") -NetAdapterInterfaceDescription $_.InterfaceDescription
    } 
}

Build-Networks

Get-VM | % {
    $vm=$_.Name; 
    Get-VMSwitch | % {
        Add-VMNetworkAdapter -ComputerName $vm -SwitchName $_.Name}} # add one nic per switch 
        Get-VM | Get-VMNetworkAdapter | ? SwitchName -eq $null | Remove-VMNetworkAdapter # remove null nic
```