---
title: "Part IV - DSC - One-Click Domain Controller"
date: "2015-06-11"
redirect_from : /2015/06/11/part-iv-one-click-domain-controller
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
tags: 
  - "dsc"
  - "powershell"
coverImage: "domainjoinomg.jpg"
---

[![IntroToDsc](../series/images/series_dscsidebar.webp)](/series/LearningDSC)


**This post is part of the Learning PowerShell DSC Series, here on FoxDeploy. Click the banner to return to the series jump page!**

* * *

Hey guys, I haven't forgotten about you, but it's been a very busy month here, with me traveling to Redmond for some exciting Microsoft meetings and then back and forth to Minneapolis for a new client!


* * *

I've been receiving your messages and have now released the final step in this one-click Domain controller DSC Build. To recap, we left off with a DSC Config that would make our machine a domain controller, but that was it.

We didn't have functional DHCP for clients to find us, or any other bells and whistles. In this post, we'll be **adding on DHCP** so clients can get an IP address, as well as **DNS** to help our Machines **Domain Join** to our new DC. If you tried Domain Joining with our build from last time, you would have been quite disappointed. Not this time!

### What has to go :

Previously, we had a single config file that did some really good stuff for us, setting up a workgroup and then making a new local admin. We're going to gut all of that stuff, because setting up a system with a DSC Config needs to be idempotent. That means that the config needs to be able to run over and over without breaking stuff, and the previous build would do just that. If we draft a config that will result in changes every time the config is validated, we've created a problem.

The issue in our last config stemmed from the fact that it would change the system's name and also add it to a work group. Then, later in the config we make it a domain controller. What would happen if the DSC config were re-evaluated is that the machine would throw an error when it got to the portion of the .mof telling it to join a workgroup. Domain Controllers can't leave a domain until they've lost all of their FSMO Roles, so this is an invalid config. Bad Stephen!

As it is, that bit about joining a workgroup turned out to be wasted space, so we'll remove that too. The full code is available below, as well as here [on my GitHub site](https://github.com/1RedOne/BlogPost_DSCpt4).

### What's new and what does it do

For this post, you'll need the xNetworking Resource, found here

- https://gallery.technet.microsoft.com/scriptcenter/xNetworking-Module-818b3583

As well as the xDHCPServer Resource, found here

- https://gallery.technet.microsoft.com/xDhcpServer-PowerShell-f739cf90#content

You'll also need the xComputerManagement and xActiveDirectory Resources, which can be found here:

- https://gallery.technet.microsoft.com/scriptcenter/xActiveDirectory-f2d573f3
- https://gallery.technet.microsoft.com/scriptcenter/xComputerManagement-Module-3ad911cc

Prepare your DSC Target Node by copying the folders in the zips to the Modules folder, in this path

```
$env:ProgramFiles\\WindowsPowerShell\\Modules
```

The big new steps we're adding are the following:

#### Set a Static IP Address

The end goal of this whole shebang was to have a working DHCP server, and DHCP can't give out IP Addresses unless they have a fixed IP themselves. In this config block , we set a Static IP of 10.20.30.1 and rename the Adapter along the way.

```powershell   
xIPAddress NewIPAddress { 
  IPAddress = "10.20.30.1" 
  InterfaceAlias = "Ethernet" 
  SubnetMask = 24 
  AddressFamily = "IPV4"
}
```

#### Enable the DHCP Windows Feature

This one was kind of a pain, as it was hard to figure out what the name was of the DHCP Server Role! Turns out it's DHCP not DHCPServer (as it is listed in Get-WindowsFeature). All we do here is make sure that the DHCP server is installed, and we do it after configuring the IP address to prevent an error which would shut down our config.

```powershell   
WindowsFeature DHCP { 
  DependsOn = '[xIPAddress]NewIpAddress' 
  Name = 'DHCP' 
  Ensure = 'PRESENT' 
  IncludeAllSubFeature = $true
}
```

### Enable the DHCP Address Scope

You can get super complex with Windows Server Networking using DHCP and DNS, but I always like to keep things simple, especially in my testlab. This configuration resource essentially runs us through the DHCP Wizard and ensures that a DHCP Scope Exists, giving out IP addresses from 10.20.30.5 all the way up to 250.

```powershell   
xDhcpServerScope Scope
     {
      DependsOn = '[WindowsFeature]DHCP'
      Ensure = 'Present'
      IPEndRange = '10.20.30.250'
      IPStartRange = '10.20.30.5'
      Name = 'PowerShellScope'
      SubnetMask = '255.255.255.0'
      LeaseDuration = '00:08:00'
      State = 'Active'
      AddressFamily = 'IPv4'
     } 

```

#### Specify the DNS server for DHCP clients to use

If you don't get this part, your DNS Clients will throw up an ' ERROR: Could not join to the domain VAS\_ERR\_DNS: unable to lookup any DNS SRV records for', which should be your clue to ensure that you've specified option 6 in your DNS settings

```powershell   
xDhcpServerOption Option
     {
         Ensure = 'Present'
         ScopeID = '10.20.30.0'
         DnsDomain = 'fox.test'
         DnsServerIPAddress = '10.20.30.1'
         AddressFamily = 'IPv4'
     }
```

### The Complete Config

If you're following from home, go ahead and delete everything from the last DSC post from line 29 to 54.

Or, if you're laz--uh, more efficiently minded, copy and paste this code instead.

{% gist ac6d38a116933bb4de7113eaf427eafe %}

Now that we know what we're doing, let's give it a whirl!

### Testing it out

My network is laid out like this

[![Layout](../assets/images/2015/06/images/layout.png?w=423)](../assets/images/2015/06/images/layout/)

I've got my future DHCP Server and a random client Windows 10 VM both sitting on the same network. Now we're going to enforce the configuration on my DSC Client, and then watch and see my workstation pull down a DHCP Address!

You might be thinking:

> 'Hey Stephen, why not just copy the files down with DSC!'

and that's a great question. As it turns out, you can do something like that by using what's called a DSC Partial Configuration…which I'm still figuring out. Once I understand it, I'll write a post about it. The long and short of it now is that you can't reference a resource and also copy a resource within the same config because...uh...reasons.

### You're boring me, let's get to it!

The only thing that's left is to hit F5 and watch as my machine gets config'd! First we apply the new computer name… which needs a reboot

[![SetComputerName](../assets/images/2015/06/images/setcomputername.gif)](../assets/images/2015/06/images/setcomputername.gif/)

Now, we reboot and just relaunch the configuration. We could just wait…but it's more fun to hit -Force and watch the whole thing happen in real time

[![MakingaDC](../assets/images/2015/06/images/makingadc.gif)](../assets/images/2015/06/images/makingadc/)

If all of this worked (and it looks like it did!) we should now be able to go over to our test machine and run a DHCP /renew and see an IP address come over.

[![DHCP worked!](../assets/images/2015/06/images/dhcp-worked.png?w=636)](../assets/images/2015/06/images/dhcp-worked/)

An important piece of getting this Domain Controller accepting domain joins is to make sure that new PCs to the domain can find the DC. This means that they need to ask a DNS server for the SRV record of a Domain Controller holding the Global Catalog role. We'll run a ipconfig /all and see if our DNS Server setting is registered.

[![DNS server came alone](../assets/images/2015/06/images/dns-server-came-alone.png?w=636)](../assets/images/2015/06/images/dns-server-came-alone/)

Now is where I started to get excited. See, my whole reason for going down this path is that I think making a domain controller in a Lab environment can be very daunting for first-timers, and wanted to help lower that barrier to entry. If my client machine can see the DC, then it should be able to Domain Join now. So the moment of truth...

[![MomentOfTruth](../assets/images/2015/06/images/momentoftruth.png/)](../assets/images/2015/06/images/momentoftruth.png/)

Now...to hit OK...

![Welcome to the FoxDeploy Domain!!!](../assets/images/2015/06/images/beautiful.png) 
Welcome to the FoxDeploy Domain!!!

### Wrapping it up

I will admit, I jumped up and down when I got this part to work. We now have a one-click, single-stop Domain Controller build, perfect to use a stepping stone into whatever else you'd want to do on a domain controller. It really is kind of amazing to me that this all works, knowing how hard it would be to do this level on configuration using something like SCCM/Configuration Manager.

From here? The next step in our series will have us joining clients to this domain as well, and from there, we can do whatever you'd want to do with DSC. If you've got an idea or a situation from work, send me a message, and you might just be the next blog post here in this series.
