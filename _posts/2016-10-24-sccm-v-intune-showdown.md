---
title: "SCCM v Intune Showdown"
date: "2016-10-24"
redirect_from : 2016/10/24/sccm-v-intune-showdown
coverImage: ../assets/images/2016/10/images/sccm.png?w=636
tags: 
  - "intune"
  - "mdm"
  - "sccm"
excerpt: "If you're an SCCM Administrator you've likely heard of InTune and might be wondering when to use it.

In this post, we'll cover how SCCM and Intune are able to manage Windows 10 full desktop computers (including laptops and Windows tablets like the Surface or Surface book.)"
---

![sccm](../assets/images/2016/10/images/sccm.png?w=636)

If you're an SCCM Administrator you've likely heard of InTune and might be wondering when to use it.

In this post, we'll cover how SCCM and Intune are able to manage Windows 10 full desktop computers (including laptops and Windows tablets like the Surface or Surface book.)

_If instead you're wondering about managing the Surface RT, lol, enjoy your metro cutting board._

![](../assets/images/2016/10/images/wp-1477150701888.jpg) Best use for a Surface RT in 2016

To understand where InTune really shines, let's think of where SCCM works best:

- known and defined network infrastructure
- well connected end-point devices (less of an issue today)
- standardized hardware models
- standardized, company owned hardware
- Active Directory Domain (all SCCM servers must be domain members)
- Managed machines are either domain joined, or need certificates (certs =PKI =Even more infrastructure and configuration)
- Wonderfully powerful imaging capabilities

It becomes pretty obvious, SCCM is for the big enterprise,  which its also expensive and has some serious requirements.

Now, let's contrast this to the management story we have from Intune:

- No requirement for local hardware or infrastructure
- No on premises Active Directory requirement
- Works very well with Azure AD
- Works great with user owned and heterogeneous devices
- Literally zero imaging options

For the rest of this post, I'll list the big capabilities of an Enterprise Client Management tool and contrast how each of these tools perform at that task, we'll cover:

- Enrollment
- Deploying Software
- Delivering Updates
- Imaging / Provisioning

Before we dig in, I'd like to call out one SCCM and Intune configuration, then I'll immediately throw it out and never mention it again. You can integrate SCCM with Intune, this makes your Intune managed mobile devices like cell phones and iPads (but not Windows desktop devices) appear in the SCCM console.

This elevates your SCCM to the single page of glass to manage all systems in the environment.

K, just wanted to mention that so I can say I covered everything.

> **One last thing**: this post is going to talk about Provisioning Packages a lot.  Never heard of them?  Here is [some additional reading for you](https://blogs.msdn.microsoft.com/beanexpert/2016/05/13/provisioning-packages-what-can-or-cannot-be-done/).

### Management Options

Management, it's the whole reason we bother with tools like Group Policy, Intune and SCCM.  At the end of the day, we want to standardize our machines and make it easier for our employees to get work done.  Let us never forget that these end-users are really the reason we're here in the first place.

It's like a bakery.  At a certain scale, they need delivery trucks, and probably mechanics.  You might work as a bakery mechanic and have plans for these trucks.  They're gonna get painted, they'll get some new tires, and you'll overhaul the engines.  So you decide to take all of the delivery trucks out of commission for a week to work on them.  Great, now you've got the prettiest trucks in the business, but the company has lost all of their customers because they failed to make deliveries on time!

Never be a bakery mechanic.  Wait, what was I talking about again.  Oh yeah, managing machines and how it differs from Intune and SCCM.  It's been like five hundred words again so I guess I need another graphic.

### ![management-1](../assets/images/2016/10/images/management-1.png)

**SCCM.**  ConfigMgr manages machines via a Client which must be present on all managed machines.  Most machines recieve the sccm client while imaging. If not, you as the administrator are in charge of deploying the agent and the user never knows most of the time. It's either pushed as a Windows Update through WSUS, or remotely installed automatically or manually from the SCCM console.

**Intune** when it comes to managing Windows 10 devices with Intune, you have two routes for management.

First, Intune offers it's own an client, which is an MSI, much like SCCM. This agent is deployed either via GPO, by sending users to portal.manage.microsoft.com, or you can download the msi from Intune, and either instruct users to install it or push it with whatever software distribution tool you have.

Windows 10 also introduced the capability to manage Windows machines via a built-in Mobile Device Management (MDM) client. This means no visible agent to the end user. Awesome!

> However, the management option you choose, Agent based or MDM, determines what you can manage.

Let's break it down further to help you determine which route is for you:

#### **Intune Agent**

you may be thinking 'oh, I know SCCM so this Intune agent must be the one-true-management option, right?'

Wrong. There are serious serious limitations to managing a machine via the Intune Agent.  In fact, for most scenarios, you will not want to go this route.

The Intune agent can manage the basics: software distribution, Firewall enabled and exceptions, turn on Windows Defender (this week's name for Windows built in anti-virus), and so on. You also have limited control over Windows updates for PCs as well.

You cannot enforce security settings like a screen lock or time out.

#### **MDM Management**

Managing our Windows desktops like they're a mobile a device, this is the new hot option available to us. Since Windows natively includes an MDM agent, we're now able to provision security like we never could before. Think of the types of security you can enforce on a mobile phone with Exchange ActiveSync or AirWatch, etc?

When managing your Windows devices like they're a mobile phone, you can control pretty much everything. Here is a [complete list of all features currently](https://docs.microsoft.com/en-us/intune/deploy-use/windows-10-policy-settings-in-microsoft-intune#general-configuration-policy-settings) manageable with InTune MDM enrollment.  It's almost all encompassing.

### Imaging / Provisioning

Here lies the single greatest difference between managing machines with SCCM versus Intune, how machines are imaged or provisioned to function with your workplace.

#### Imaging in SCCM

This is very well traveled ground, SCCM is simply the single most powerful and configurable system available to administrators to build and deliver a standardized image to hardware either via PXE boot or bootable thumbdrive.  If you know SCCM, you know how to do this, nothing has changed.

![dark-souls](../assets/images/2016/10/images/dark-souls.png)

#### Imaging with InTune

This is where things become VERY interesting and we have to start getting crafty, because...

> Intune cannot image PCs.  Fullstop.

Yep.  You are not going to be deploying images with InTune.  But you kind of don't really need to.

InTune is all about turning around our assumptions of what managing a machine truly means and requires.  If we think of why we typically image machines, it's because we want to deliver a standard set of software, ensure basic settings compliance, make sure they're getting updates and provide a standardized experience to our users, we may also want to make sure that they're running BitLocker and are on an appropriate and licensed version of Windows.

However, many companies deploying InTune may not have standardized hardware (if you do, I have something for you at the bottom of this section), or the users might be bringing in their own hardware with a BYOD model.  In this case, the machine is already running Windows, so instead we just need to find a way to manage those core usage scenarios.

We do all of this via Provisioning Packages.  You create one using WICD (Windows Image Configuration Designer), and it outputs a small .ppkg file.  Users double-click it and it allows the package to make a LOT of Windows changes.  You can:

- Change the edition of Windows, bringing them from Home to Enterprise, for instance, which is required for BitLocker
- Enroll the machines silently with InTune

That's really all we need to do.  With the version of Windows changed, we can now do everything else, from deploying software and updates, enforcing compliance and security settings, and even locking things down with Bitlocker, all using standard policies from the InTune console.

For many even enterprise management situations, this is truly 'good enough management' and greatly reduces our work as admins.

**"But mah standard image!"**  Worry not! If you must deploy a standard image but need to manage your machines with Intune, there is an answer for you.

I'm engaged in a project right now with a large food-services company.  We've built a standard image ISO with all the common software, and then created a Provisioning Package and baked it into the image.  We can then deploy this out to WDS for PXE booting, or deploy the image to our hardware vendor who will bake it into the machines before drop shipping them to our offices in the field.

In this manner, we are able to deploy a standard Golden Image to our machines, but still ensure management with them through InTune.  Covers all of our needs without the expense of SCCM.

### Deploying Software

SCCM provides very, very deep logging and a generally powerful and easy to use experience to deploy software.  There are guides and guides galore to cover this topic.

Intune provides a VERY minimalized set of options to managing software.  You either deploy a .msi or setup.exe with a limited set of install switches, provide a local path for the files and they get uploaded to Intune.  From there on, troubleshooting app installs is admittedly much harder from Intune than from SCCM.  With SCCM, you have extremely verbose, very detailed logging.

Not so with Intune.  You'll find _some_ logging within this log file:

%ProgramFiles%\\Microsoft\\OnlineManagement\\Logs

And that's about it.  If you're using a different MDM Platform, like Air-Watch....good luck.  Beyond these warnings, I'm really not going into to depth on this topic because it is covered in great detail on this channel 9 video.

[Deploying .MSI and Setup.exe installs with Intune](https://channel9.msdn.com/Series/How-to-Control-the-Uncontrolled/6--How-to-Deploy-MSI-Applications-to-Windows-10-Using-Intune-and-Mobile-Device-Management-MDM)

My core take-away is that while you can push software with Intune or other MDM management tools, it's much harder to do than with SCCM alone.  Keep this in mind and make sure you've got an absolutely bullet-proof package before trying to push it with Intune, to minimize tears.



### Delivering Updates

With SCCM, we can both control the Update Source and Frequency of Updates, as well as deliver them from an internal location.  We use the SCCM console to manage which updates are made available to users.  When we approve updates in SCCM, they're approved within SCCM's own instance of WSUS and delivered that way.

Conversely, we can control both update source (whether via an internal update source (WSUS) or through Windows Update over the web) and frequency for devices with InTune, but if we want to manage which updates devices receive, we have to manage them manually using our own WSUS instance.

This will become less of an issue, as there are no more individual updates released anymore, as of September 2016.

### Conclusion : who is Intune really for?

Microsoft has been the uncontested champion of enterprise and the workplace for the last two decades.  However, things change.  Schools are moving more and more to Google Apps, using GMail addresses for employees and the Google Apps suite of productivity tools for faculty and staff, and deploying comodity hardware Chromebooks to students. This has been the trend for almost ten years now.

These students grow up with an Android or iPhone, get a Chromebook or Macbook for school, and then go through college and graduate without ever touching many Windows machines.  It's pretty reasonable to assume that they'll then enter the workforce or start their own companies after that.

And when they do, they _are NOT_ going to think Microsoft as their first choice. They won't even be familiar with Windows Domains, Roaming Profiles, any of that.

For this new class of worker and this new workplace, we have Intune.  Sure, it's not as fully fledged as SCCM, but it doesn't need to be, since there probably won't be standardized hardware anyway.  These machines will probably be Azure AD Workplace Joined, which isn't as deep as Group Policy, but it handles most of the big asks without breaking a sweat.

Intune is the story of 'good-enough' administration.

It's not GPO, SCCM or even MDT but it doesn't have to be.
