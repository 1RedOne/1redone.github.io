---
title: "DSC vs. GPO vs. SCCM, the case for each."
date: "2016-02-25"
redirect_from : 2016/02/25/dsc-vs-gpo-vs-sccm-the-case-for-each
coverImage: ../assets/images/2016/02/images/eva-post.png
categories: 
  - "consulting"
  - "scripting"
tags: 
  - "dsc"
  - "gpo"
  - "opinion"
  - "sccm"
excerpt: "This is the showdown, guys. In the world of Windows tooling, which tool do we use?

In this post, we'll cover the general benefits and pros and cons of SCCM vs DSC, and also consider GPO and MDT as well."
---
[![Learning DSC Series](../series/images/series_dscsidebar.webp)](/series/LearningDSC)
![EVA Post.png](../assets/images/2016/02/images/eva-post.png)

This is the showdown, guys. In the world of Windows tooling, which tool do we use?

In this post, we'll cover the general benefits and pros and cons of SCCM vs DSC, and also consider GPO and MDT as well.

Plenty of people have offered their take on this, including my sempai, Declarative Configuration trailblazer and King Chef of the Realm [Steven Murawski](http://stevenmurawski.com/). I completely respect his opinion on the matter and encourage you to read it.  [Murawski - DSC Which Direction Should we Go?](http://stevenmurawski.com/powershell/2016/02/what-direction-should-we-go/?utm_content=buffer7ef46&utm_medium=social&utm_source=twitter.com&utm_campaign=buffer).

My view differs slightly from my peers in that my background is in Enterprise Client Management, and I've been deploying SCCM since 2011 for customers into the tens of thousands of desktops and servers.

However, I also love to code, so maybe my perspective will help the concepts gel for you.

In my mind, this debate is not really about which tool is the one-true king to use in all cases, but rather about highlighting the strengths of each and noting when they should be used.  I'll also describe how you deploy operating systems using each product as well.

> It's all about the evolution of tooling

## First the Earth cooled, then we got GPO

For all practical purposes, the first true large scale management tool we had for Windows systems in the modern era was Group Policy, or GPO as it is commonly truncated.  This stemmed from Local Security Policy, which is a fancy GUI to control system settings via special registry keys which are locked down from general user editing. Local Security Policy could be shared among systems in a Workgroup which was a big improvement from setting the same configuration on each system.

Then with the advent of Active Directory Domain Services, we gained the ability to organize users and computers into a hierarchy and tier the application of these same policies to craft very granular configurations of machines based on who is logging on to which computer, and where those objects were placed in the directory. Join a machine to a domain, and bam, it gets the default policy, and then you can move the computer to the right folder (or organizational Unit, OU) to put the right amount of lock-down on the node.

People used it for everything, including installing software! It was later made possible to have multiple GPOs affect a computer like you can with collections in SCCM, using WMI Filters which execute on the machine to determine which GPOs should apply, but it's much harder to get right, and there's no easy mechanism to view which computers would be affected.

### A GPO by any other name is a registry key…

The thing about GPO is that you need to have Active Directory in place.  This means Infrastructure, and suddenly, when all we wanted to do was configure certain settings across our environment, we're now staying up late at night worrying about things like disks and server uptime and we now need a Sysadmin to run it all. Each of these steps in complexity is adding cost to the company which might not do much if anything to increase earnings.

Where GPO gets murky is that it's kind of onerous when trying to assign multiple different sets of policy to machines based on many different conditions (imagine multiple departments, with different applications and settings for each). Additionally, it ain't exactly quiet.  In big organizations who haven't optimized their application of policy, it's not uncommon to see multi minute long log in times, and unconstrained Windows Update installs rebooting computers during the middle of the day.

![Mess up your GPO and people will be seeing this](../assets/images/2016/02/images/gpo.jpg?w=636)

In my day job, I still see people struggling with Group Policy, years after its release.

### GPO, what is it good for?

With an Active Directory Domain, you can configure almost anything about the settings of Windows Computers, like what users are allowed to do, who is permitted to logon, setup Windows Updates and even install software. And if you have more than ten computers, you probably already have a Domain, so you kind of 'get it for free'.

**Group Policy is THE tool for configuring user experience and locking down PCs.**

GPO is AWESOME for configuring desktop applications, like Microsoft Office and Chrome, and for configuring the user's experience.

#### When to avoid GPO

It's not good for installing software, it's intrusive to users and if you mess up, it will be very public, potentially causing long log in times.

The very nature of hierarchical tiering of configuration also leads to great complexity. If you want to apply certain user settings only when they log on to particular machines it gets even harder. There are plenty of solutions, but that is some hard stuff to get right.

Additionally, it's not great for configuring or installing server features, nor is it really made to ensure features and roles stay installed, like ensuring that IIS is installed and stays running. Etc

It's also not lightweight, as you'll need Domain Controllers and probably need people to run them for you, and if your organization is large, you'll need to worry about network topology as well.

#### I only have AD and GPOs, what do I need to start imaging?

There is an imaging story for native Active directory tools and it involves using Windows Deployment Services to install a sysprepped image using PXE booting. This is not a good developer experience though, as we have to spend a lot of time with complex tools to save all of our imaging settings into an image, and can't tailor the image to fit computers in certain regions, for instance.

Comparatively, SCCM and MDT allow us to we import an image from a Windows install disk and then run dozens of individual steps which are customized based on the target machines platform, model, office location and other factors. The sky is the limit.

## GPO is hard, enter SCCM

To serve other configuration needs, Microsoft released their product 'System Management Server', which was eventually rebranded as System Center Configuration Manager.

Whereas GPO is something we get 'for free' when computers are a member of a domain, SCCM depends on an agent being installed on every computer you want to manage.  Big difference.

This tool adds an extra level of abstraction to Active Directory, sniffing for users and computers in a domain and then allowing an SCCM admin to organize them into collections.

These are one of the defining characteristics of SCCM, these groups which can be either manually created in a drag and drop fashion, or created automatically based on common factors, like a computers distinguished name (good for organizing based on active directory OU), or users department, OS Version, etc.

If you can think of a common factor of a group of systems or people in your firm, you can target them for applications or security policies using SCCM.  Collections solve the difficult problem of assigning policy based on logical placement of computers and users within AD.

#### SCCM excels with bare metal

You also gain the option of having cradle to grave control over systems too, as SCCM supports laying down an operating system to bare metal (industry term for brand new computers).

SCCM is easily the best imaging experience you can get with Microsoft tools. I've tried the other options as well, like Dell Kace (which is actually pretty good, if limited in comparison to the power of SCCM), but they're simply not as good as SCCM.

#### The king of software deployment and user migration

If you're upgrading OSes, deploying Windows Updates or software, SCCM is king.  You have limitless control over how to install applications, what the user sees and doesn't see, and most importantly of all, none of your configurations will impact their login time like GPO does.  SCCM is the best at what it does.

### Probably not the tool for ensuring compliance, however

SCCM DOES have a module called Desired Configuration Management, which kind of sounds like Desired State Configuration, but it relies on machines having an agent, being in a domain, etc. While you can ensure compliance with SCCM, it is a complex answer to a complex question relying on the SCCM admin to write complex tests to check for conditions and also provide remediation steps as well.

It works, but there are much easier ways to ensure system compliance than rolling SCCM.

### SCCM is not lightweight

**SCCM completely depends on Active Directory.**  All site servers (all SCCM servers) must be members of a Domain, full-stop.

This means SCCM actually adds more complexity to AD.

You need your whole AD Infrastructure, plus at least one or two likely hefty servers to run SCCM too.  There is a lot of complexity in SCCM and a quick Google will show thousands of posts on the web of people asking for help with it. You'll also need agents installed on every system you want to manage, need to pay attention to the network topology of your organization.

Finally, you will also need to be careful in your configuration, or you could nuke your whole company.

![](../assets/images/2016/02/images/road-paving.jpg) Don't do this to your environment!

Seriously, [people have paved over](http://myitforum.com/myitforumwp/2012/08/06/sccm-task-sequence-blew-up-australias-commbank/) their [entire infrastructures before with SCCM](http://windowsitpro.com/windows-7/aggressive-configmgr-based-windows-7-deployment-takes-down-emory-university).

I make my living helping companies recover from SCCM disasters or get started using it the right way, and so do hundreds of my peers. It is not easy.

## DSC = Easier, safer, more lightweight configuration

So long as you're running newer operating systems, we do have another option.

Rather than needing agents on machines and infrastructure like AD (which, frankly, is very much a typical Operations or Infrastructure approach to solve the problem of machine management), we have something wholly new, birthed from our developer brothers on the other side of the glass.

I'm not going to re-explain DSC here, [as I've already done it in a previous post](http://foxdeploy.com/resources/learning-dsc-series/), and others have as well , but there is a LOT of excitement in the industry about this notion of treating our servers like cattle. One of the biggest mobile carriers in the world operates on this premise:

> Servers only ever exist in a given state. If they deviate or we make changes, we refactor and redeploy. DSC drives it all and the machine will be up and running on a new OS, with data migrated in a matter of minutes.

Paraphrased from [Jason Morgan](https://jasonspowershellblog.wordpress.com/about/) in [his awesome talk on Monitoring in the Enterprise at The PowerShell Summit last year.](https://www.youtube.com/watch?v=qcbjgtAFjjI&list=PLfeA8kIs7CochwcgX9zOWxh4IL3GoG05P&index=7)

Microsoft was very much a 'Fast-Follower' in this regard, jumping onto the trail that folks like Chef and Puppet blazed, all chasing this idea of simple to read, text-file driven configuration management.

### Core Benefits of DSC

In my mind, DSC excels in a few use cases: • You need lightweight configuration for dev/test • You need to be able to revert to old builds or test new builds quickly, with A/B testing • You're primarily interested in Server Management • You want a system to be Self-healing • You'd rather have a one-page Build config instead of a 40 page 'runbook' of screenshots and aren't afraid of code.

#### Lightweight

DSC only requires that your target operating systems be capable of running PowerShell v4 for most features. There is no domain pre-requisite, nor do you need to worry about imaging machines. It lends itself to environments with spend in virtualization, because you can easily build a template machine on a workgroup, pre-create an admin account and save it as a template.

Need to spin up some new test machines? Fire off a few templates and then describe what you want them to do in your DSC Configuration and Apply-DSCConfiguration. After maybe one or two reboots, you'll be good to go. No lengthy builds or service requests, process flows. Quick, fast and in a hurry.

#### Configuration Reversion

Since you're describing the full build-out of your application or Service in a handfull of DSC files, and rebuilding these machines is possible very quickly, you're now trending towards checking in your server builds themselves as artifacts in your code versioning system. No longer do you need to spend an hour or five clicking your way through wizards to get a machine or upgrade ready. Instead, you can swiftly code-test-revert-repeat until your little snowflake is perfect.

Use the built-in DSC Resources to spin up domains, users, SQL, IIS, or roll-your own scripts for the last mile of config and just pull down the version of the environment you want and hit f5.

For developers, DSC is a godsend. You can ensure that your dev/test/prod environments are the same and avoid those awkward all-IT bridge calls where people try to figure out why a simple Exchange DB Update took down e-mail for hours.

#### Server Management

DSC CAN manage desktops. You can also pound nails with your screwdriver.

I must say that DSC on the desktop is a bit of an afterthought, and if you want to deeply provision or lock-down your desktops, you'll end up resorting to Local Security Policy or Group Policy, because GPO has pretty much covered everything you could ever need for desktop configuration.

#### Self-healing

The really beautiful thing about DSC is that when you tell a machine to ensure that something is there, it's going to do so, and KEEP doing so. DSC is wonderful for controlling configuration drift in your environment. By default, your machine is going to verify that it is in the Desired State every fifteen minutes. This is glorious, and means that your end-users really can't break things too badly, most of the time. If they do, DSC will heal itself in less time than it takes to go grab a coffee.

#### Infrastructure as Code

For one, you get to say your infrastructure is code. I mean, how cool is that?!? It's like the future!

![This came up when I googled 'infrastructure as code .gif'](../assets/images/2016/02/images/future_technology1.jpg?w=300)]

This came up when I googled 'infrastructure as code .gif'

For another, within about a minute, pretty much anyone can figure out what this is going to do:

```powershell
  WindowsFeature ADDSInstall
    {
        Ensure = 'Present'
        Name = 'AD-Domain-Services'
        IncludeAllSubFeature = $true
    }
 
    WindowsFeature RSATTools
    {
        DependsOn= '[WindowsFeature]ADDSInstall'
        Ensure = 'Present'
        Name = 'RSAT-AD-Tools'
        IncludeAllSubFeature = $true
    }
```

This will ensure that a machine has AD Domain Services installed (basically prepping it to be a domain controller) and then make sure the RSAT tools are present as well. To walk someone through getting this configuration working in words, you might easily have a page (or three, if you're including screenshots)

#### I've got SCCM, should i replace it with DSC?

If your company already has SCCM installed, I would direct you to make use of the investment your organization has made there, but keep in mind the opportunity to reduce complexity in your environment with Desired State Configuration.

You should consider the strengths of DSC (easy transition from dev to prod, easy rollback, store configurations in a repo, 15 minute or faster self-healing) and ask yourself these questions:

• Instead of assuming I need AD, SCCM, and GPO, what's the minimum viable configuration I can do for this service? •  What if we didn't have Active Directory, could this system work without it? •  Are there any features of this configuration that would benefit from being enacted and stored as Source Code, rather than an inherently wasteful 'click-click-finish' configuration?

### Closing things out here

 

So I hope I've summed up the relative merits of each tool, and when to use them. If you think I overstate, or understate your favorite tool, let me know in the comments below.
