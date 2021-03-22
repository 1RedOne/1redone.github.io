---
title: "Registering for WMI Events in PowerShell"
date: "2016-12-16"
redirect_from : /2016/12/16/registering-for-wmi-events-in-powershell
coverImage: "../assets/images/2016/12/images/registering-for-wmi-events.webp"
categories: 
  - "scripting"
tags: 
  - "pInvoke"
  - "powerShell Engineering"
  - "Consulting Tales"
---

![registering-for-wmi-events](../assets/images/2016/12/images/registering-for-wmi-events.webp)

An alternate title might be 'Running PowerShell Code ONLY when the power state changes', because that was the _very_ interesting task I received from my customer this week.

It was honestly too cool of a StackOverflow answer NOT to share, so here it goes, **[you can vote for it here if you thought it was worth-while](http://superuser.com/questions/121045/is-there-a-way-to-execute-a-program-on-power-events/1156961#1156961)**.

If you want your code to trigger only when the System Power State changes, [as described here](https://msdn.microsoft.com/en-us/library/windows/desktop/aa373223(v=vs.85).aspx), use this code.

```powershell

Register-WMIEvent -query "Select \* From Win32\_PowerManagementEvent" \` -sourceIdentifier "Power" \` -action { #YourCodeHere } 
```

Now, this will trigger whenever the power state changes, whether you plug the device in, OR unplug it. So you might further want to stop and pause to ask the question:

> Am I on power or not?

Fortunately we can use the WMI Class Win32\_BatteryStatus to detect if we're charging or not, so here's the full construct that I use to ONLY run an operation when a power event changes, and then only if I'm no longer on Power.

#### Locking the workstation when the system is unplugged

```powershell
Register-WMIEvent -query "Select * From Win32_PowerManagementEvent" `
  -sourceIdentifier "Power" `
  -action {
      if ([BOOL](Get-WmiObject -Class BatteryStatus -Namespace root\wmi).PowerOnLine ){
         #Device is plugged in now, do this action
         write-host "Power on!"
     }
    else{
        #Device is NOT plugged in now, do this action
        write-host "Now on battery, locking..."
        [NativeMethods]::LockWorkStation()
     }
```

If you're curious how this looks in real time
<blockquote class="twitter-tweet"><p lang="en" dir="ltr">Using PowerShell to register for a WMI event, to lock a workstation on power state change <a href="https://t.co/JtJWDosA4b">pic.twitter.com/JtJWDosA4b</a></p>&mdash; Stephen Owen 🦊Deploy (@FoxDeploy) <a href="https://twitter.com/FoxDeploy/status/809500159830818816?ref_src=twsrc%5Etfw">December 15, 2016</a></blockquote> <script async src="https://platform.twitter.com/widgets.js" charset="utf-8"></script>

#### Registering for device events

It can also be useful to have your code wait for something to happen with devices, such as running an action when a device is added or removed. To do this, use this code.

```powershell
#Register for power state change
#Where TargetInstance ISA 'Win32_Process'"
Register-WMIEvent -query "Select * From Win32_DeviceChangeEvent where EventType = '2'" `
-sourceIdentifier "Power" `
-action {#Do Something when a device is added
Write-host "Device added at $(Get-date)"
} 
```

You might also want to do an action if a device is removed instead, so use this table to choose which event is right for you. [Read more about it here.](https://msdn.microsoft.com/en-us/library/aa394124(v=vs.85).aspx)

| EventType | Id |
| --- | --- |
| ConfigurationChanged | 1 |
| Device Arrived | 2 |
| Device Removed | 3 |
| Device Docked | 4 |

#### What else can I wait for?

Not only these, but you can trigger your code to execute on a variety of useful WMI Events, all of which can be seen in this image below!

<table width="346"><tbody><tr><td width="278">ClassName</td><td width="68">Triggers when</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa394124(v=vs.85).aspx">Win32_DeviceChangeEvent&nbsp;</a></td><td>A device is installed, removed, or deleted, or the system is docked</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa394516(v=vs.85).aspx">Win32_VolumeChangeEvent</a></td><td>Something happens to your disk drives</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa394362(v=vs.85).aspx">Win32_PowerManagementEvent</a></td><td>Your device is plugged, unplugged or docked</td></tr><tr><td>Win32_ComputerSystemEvent</td><td>Something major happens to the system</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa394101(v=vs.85).aspx">Win32_ComputerShutdownEvent</a></td><td>The system is shutting down!</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa393039(v=vs.85).aspx">RegistryEvent</a></td><td>Anythign happens to the registry</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa393040(v=vs.85).aspx">RegistryKeyChangeEvent</a></td><td>A reg key you specify is changed</td></tr><tr><td><a href="https://msdn.microsoft.com/en-us/library/aa393042(v=vs.85).aspx">RegistryValueChangeEvent</a></td><td>A reg value you specify is changed</td></tr></tbody></table>