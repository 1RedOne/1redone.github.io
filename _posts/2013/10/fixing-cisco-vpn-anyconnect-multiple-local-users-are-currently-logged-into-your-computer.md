---
title: "Fixing Cisco VPN AnyConnect \"Multiple Local users are currently logged into your computer\""
date: "2013-10-10"
categories: 
  - "quickies"
---

Since I've rebuilt my home testlab as a Server 2012 R2 box, I've been unable to connect to my companies VPN, which has caused me a world of...well, minor inconveniences. This will not do!

The message I would get upon connection was:

> AnyConnect profile settings mandate a single local user, but multiple local users are currently logged into your computer.  A VPN connection will not be established. AnyConnect was not able to establish a connection to the specified secure gateway. Please try connecting again.

I was befuddled, as I was clearly the only logged on user (or so I thought).  After digging in deeply, I noticed in my Get-Process list that in addition to Session 0 (Kernel.Services) and my own home Session 1, there was an interloper!   I determined this by launching PowerShell and checking for open sessions. I used `Get-Process | Select SessionID -Unique`

I didn't take a screen shot at the time, but the output was this, with one extra entry, a Session 2.

\[caption id="" align="alignnone" width="585"\][![vpn0](http://foxdeploy.files.wordpress.com/2013/10/vpn0.png?w=585)](http://foxdeploy.files.wordpress.com/2013/10/vpn0.png) Imagination time, envision a very guilty and yet innocuous looking Session # 2 listed here.\[/caption\]

I then launched "query session" (or qwinsta, as it is commonly refered to for some reason, probably an old OS2 joke), and noted the below!

\[caption id="attachment\_246" align="alignnone" width="585"\][![vpn1](http://foxdeploy.files.wordpress.com/2013/10/vpn1.png?w=585)](http://foxdeploy.files.wordpress.com/2013/10/vpn1.png) SMOKING GUN! Actually, pretend there Is a session 2 listed here.\[/caption\]

The problem was that I’m running Hyper-V (not the issue) with Remote Desktop Services Virtualization Host (the problem) enabled as well

What happens when you enable Virtualization host is that the Remote Desktop Session Host service launches as Session 2 and above, so you’d have

Session 0 – Services,

Session 1 – Console/User,

Session 2 – RDSH.

It doesn’t run many process or anything very incriminating other than an instance of CSRSS and some other base services, but that alone running will register as an additional Session, which is enough to give sadness to the VPN Client.  You can see what processes are run by the Session if you'd like using the following command:   `Get-Process | Where SessionId -eq '$Interloper_id_from_above'`

I ended up fixing it by using Remove-WindowsFeature PowerShell commandlette to remove the Remote Desktop Services roles, as Add Windows Features in Server Manager will not allow you to remove certain RSDH roles. The command to remove it was:

`Remove-WindowsFeature Remote-Desktop-Services, RDS-Virtualization`

The issue impacted Cisco VPN AnyConnect versions 2.4x, 2.5x and 3.1.01065.
