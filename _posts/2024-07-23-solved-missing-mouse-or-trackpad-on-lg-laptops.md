---
title: "Solved!  Missing mouse or trackpad on LG Laptops"
date: "2024-07-17"
redirect_from : 2024/07/23/2024-07-23-solved-missing-mouse-or-trackpad-on-lg-laptops
coverImage: \assets\images\2024\MissingMouse.jpg
categories: 
  - "troubleshooting"
excerpt: "Have you ever needed to do complex automation in Azure Devops?  Like retrieving a token for one service and handing it off to subsequent commands to use?  Then you might have been puzzled about the correct syntax to use.  In this post, I'll give you a working example of how the syntax should be used to hand variables between bash and PowerShell tasks in Azure Devops"
fileName: '2024-07-23-solved-missing-mouse-or-trackpad-on-lg-laptops'
---

![Header for this post, reads 'Handing off variables in ADO'](\assets\images\2024\MissingMouse.jpg)
## But first, a rant

LG, Do better.

It's not enough that the hardware is all controlled by an extremely lagging always running control center app, but troubleshooting it becomes a nightmare, as LG does not bother to write any TSGs or per device guidance.  

LG does not publish drivers either, so if you're looking to deploy en masse, you'll have to do the nasty of capturing reference drivers from a machine, so expect very tedious imaging as you build the needed drivers.  

You also *do need* to include the control center software too, or risk users ending up in this scenario I encountered.  

The user plugged their LG Gram into their husband's docking station with external monitors on a thunderbolt dock.  

When an external mouse is connected in such a manner, the touchpad is disabled for unknown reasons.  

The laptop went to sleep and was disconnected from the dock.  This left the user with no way to re-enable their touchpad, although at least the touchscreen still functioned.

## The fix
To fix this, look at Device Manager, in this scenario there was **no HID Driver Compliant Touchpad Driver** present on the device.

![Header for this post, reads 'Handing off variables in ADO'](\assets\images\2024\OIP.jpg)

There was however a Device which failed to start, called 'I2C HID Device' or something like that.  In our scenario, we uninstalled this device and then restarted the laptop.  

On reboot, the device worked again.  