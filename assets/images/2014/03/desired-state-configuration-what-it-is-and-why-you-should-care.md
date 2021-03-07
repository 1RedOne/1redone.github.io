---
title: "Desired State Configuration - What it is and why you should care"
date: "2014-03-10"
categories: 
  - "scripting"
tags: 
  - "dsc"
---

If you've been following Microsoft management news, you've no doubt heard of Desired State Configuration.  You might be wondering what it is.

Let's start with what it's not.  Many believe that DSC is a feature of PowerShell v4, but this is actually a misconception, as the feature really stems from the Windows Management Framework, but implemented using PowerShell, WMI and WMF.  You can use it on any OS compatible with WMF 4.0, which currently includes Server 2008 R2 SP1, Server 2012, 2012 R2, Windows 7 SP1 and Windows 8.1 but not Windows 8, for some reason.

### Well, what is it?

I hope to explain that and by the end give you a practical example that isn't the typical 'install a web server' sample you've probably seen elsewhere.   I'm writing this to expand my own knowledge, and to help share with any who may stumble upon this.  If you catch an error I've made, please let me know.

> \[Desired State Configuration is\] Microsoft's Fresh Start for Configuration… -Don Jones

When Don Jones makes a pronouncement like this, I tend to listen.  The idea behind DSC is to simplify the configuration of Windows, and to eliminate the overlap that exists between GPO, SCCM's Desired Configuration Manager, Logon Scripts, and other options, and to make it all easy.   In the end, ensuring your server configuration doesn't deviate away from the company standard should be easy, and should be reliable.

**Instead of having five or ten GPOs** to look through when trying to determine how a particular setting is being inherited, there is one configuration file.  This configuration file is an industry standard Managed Object Framework document, commonly referred to as a MOF file.  Reading and creating MOF files should be an easy and accessible task even for junior level IT people.

> It's as important as Group Policy - Don Jones

DSC extends very deeply into the operating system.  It is still quite new, so as time goes on the possibilities for configuration will become greater and greater.  Eventually you'll be able to configure your servers cradle-to-grave with DSC, and roll out complex products with it too.  Out of the box, you can use the following DSC Resources to control various aspects of your systems.

What do the default DSC Resources allow you to configure?

<table border="1" cellspacing="0" cellpadding="0"><tbody><tr><td>Registry</td><td>Ensure that a registry key is present, or not</td></tr><tr><td>Script</td><td>Provides a mechanism to run scripts and evaluate conditions</td></tr><tr><td>Archive</td><td>Zip or unzip files</td></tr><tr><td>File</td><td>Ensure files are present or not</td></tr><tr><td>WindowsFeature</td><td>Ensure that Windows Features are or are not present</td></tr><tr><td>Package</td><td>Install or remove an Application, MSI or Setup.exe</td></tr><tr><td>Environment</td><td>Set Environmental variables</td></tr><tr><td>Group</td><td>Make changes to localgroups</td></tr><tr><td>User</td><td>Make changes to local users</td></tr><tr><td>Log</td><td>Provides a mechanism to log changes enacted by DSC</td></tr><tr><td>Service</td><td>Ensures a service is or is not running</td></tr><tr><td>WindowsProcess</td><td>Ensures that a process is or is not running</td></tr></tbody></table>

In the last few weeks, the PowerShell team has been churning out more and more configuration possibilities.  Just two weeks ago, this [new Module hit TechNet](http://gallery.technet.microsoft.com/scriptcenter/xHyperV-Module-PowerShell-a646ad1a), allowing for the configuration of VHDs, VM switches and all aspects of Hyper-V.  If you'd like to see more, check out the [DSC Resource Kit Wave #2](http://www.powershellmagazine.com/2014/02/09/desired-state-configuration-dsc-resource-kit-wave-2/), which expands the options even further, allowing for the configuration of Domain Controllers, installation of SQL and much, much more.

## Stephen's Practical Example

Now that I've hopefully got some of the explanation out of the way, let's get into a practical example of the  power of DSC.

You need to install Bob's monitoring app on your servers, and it has a number of dependencies including BITS, Remote Differential Compression, and IIS. Also, some of these systems already have some or none of the prerequisites. Finally, a number of them were once Remote Desktop servers and have the RDS role installed.  If so, that should be removed.

Oh yeah, and you have to do it tonight and you have 60 servers. One last thing, the presence of Bob's Monitoring app is from this moment forward considered mission critical and must always be present.

#### Doing this the old way

Well, You could start off writing a number of declarative scripts saying if this then that if this; then this and on and on. This would quickly become quite a script to create.   Those comfortable with PowerShell can probably think of how to write such a script, I know that I could.  Then there's the thing about ensure that the setting persist, you might set up a scheduled task to rerun your complex script every so often, or do the same thing with a GPO.

What if you could just write up a list with your demands, just describing what you want this server to be, and then instruct these servers to just go out and make it so.

### Make it so

Yep, Star Trek. It's all about make it so. From Jeffrey Snover to Donn Jones, everyone is talking about Pickard.

In this scenario, we've got two machines, our desktop and a server.  This server is standing in for the farm of sixty I mentioned above, and has been configured to have RDS ahead of time.  I'll be showing a screen cap of my machine running the test for components and the monitoring app (7Zip is standing in for our bespoke monitoring app).  To start with, here's a screen shot of a few lines of code to get the status of a few windows features and the install status of an application.

![](http://foxdeploy.files.wordpress.com/2014/02/dsc_00_features_on_configure_me.png) Running from my machine, this shows that the target machine has RDS (which it shouldn't), and doesn't have the services it needs or our app installed.\[/caption\]

So, now to create our first configuration and then to enforce it.  The basic flow of this is to check for the roles that are needed using the WindowsFeature resource to name the roles that we need and then specify the value of 'present' for the  'ensure' parameter to make sure these things are there.  We'll then remove RDS if its present by specifying 'absent' for the same parameter for that.  Next, we'll test if the install files are there using the File resource, and if not put them there.  Finally, if the application hasn't been installed, we'll install it using the Package resource, which works for MSI and Windows Installer Setup.exe files.  We'll actually work our way back from the end, doing the file copy and package install first, then adding on the Role/Feature install and removal.

### Creating our First DSC Configuration

Creating our First Configuration is as simple as typing Configuration MonitoringSoftware {}.  I should mention that DSC brings a new keyword to PowerShell, Configuration.  The syntax is similar to a Function, you can define parameters and validation, and the overall flow looks very reminiscent of a Function, so it doesn't feel too out of place.  Of course, we'll need to fill this in with some content, so we'll start with a basic file copy.  We'd also like to be able to apply this configuration (in our example, we'll call this InstallMonitoringSoftware) to many machines at once, so we'll add the ability to specify parameters. 

Configuration MonitoringSoftware {  param(\[string\[\]\]$MachineName\="localhost") Node $MachineName { File MonitoringInstallationFiles {                 Ensure \="Present" SourcePath\="\\\\dc01\\Software\\Monitoring" DestinationPath\="C:\\Temp\\Monitoring" Type \="Directory" Recurse\=$true } } }

What this is doing is creating a new Configuration, that will be processed on the Node (system or system names provided), stating that for this configuration use the File resource, and Ensure that Destination Path exists.  If not, copy recursively the contents of SourcePath.

**Running this creates a .mof file, which the system will evaluate from now on.**

Once we run this, we'll have a .mof file--that is, the instructions of what the machine should look like, which we'll convey to the end machines through a number of methods-- created in C:\\Windows\\System32\\YourConfigurationName.  We can run this from the command line with the following command, in my example I'm running this on a VM titled 'ConfigureMe', though you could easily run this on five, twenty or more machines:

MonitoringSoftware \-MachineName ConfigureMe

If at this point you're running into this error message, make sure you've either specified an output directory or are running ISE as an Admin:

Write-NodeMOFFile : Invalid MOF definition for node 'localhost': Exception calling "ValidateInstanceText" with "1" argument(s)

Followed by:

PSDesiredStateConfiguration\\Configuration : Access to the path 'ConfigurationName' is denied.' errors)

This is because the ISE's default path is C:\\windows\\system32 path and if you don't specify an output directory when you run enact a Configuration, the file will be created in the current path.   To resolve this, either run ISE as an admin, or make sure to specify the output directory for the .MOF configuration files.

Now we have a .MOF configuration file created.  Running this command should Ensure that a directory exists at DestinationPath and that it contains the entire contents of SourcePath; if not, make it so.  We can enact this configuration on a computer by running the following command, you'll see the output below:

Start-DscConfiguration \-Path $env:windir\\system32\\MonitoringSoftware \-Wait \-Verbose \-Force 

! We need this so our install files will be where we need them for the next step.\[/caption\]

According to DSC, the files are there!  Let's confirm on the system itself.

!\[/caption\]

Now to install the program, we just add an extra configuration resource, specifying the type of Package.  This snippet will go right behind the Files resource in our configuration.

Package MonitoringSoftware { Ensure \="Present" \# You can also set Ensure to "Absent" Path \="$Env:SystemDrive\\Temp\\Monitoring\\7z920-x64.msi" Name \= "7-Zip" ProductId \= "23170F69-40C1-2702-0920-000001000000"             DependsOn\= "\[File\]MonitoringInstallationFiles"             }

Two things to note here, one we're using the DependsOn parameter as a method of chaining dependencies.  Pretty neat.  The syntax is "\[ResourceType\]Resourcename", , if you'd like to depend on multiple resources, simply place the resources in a here string like so: DependsOn= @("\[WindowsFeature\]HyperV", "\[File\]VHDFolder")\[Thanks to [Tore Goreng](https://twitter.com/ToreGroneng) for this tip!\].  Also, the ProductId, that value can be grabbed by installing the application and looking for the program GUID in the registry, or through Win32\_Product WMI class under IndentifyNumber:

IdentifyingNumber : {23170F69-40C1-2702-0920-000001000000} Name              : 7-Zip 9.20 (x64 edition) Vendor            : Igor Pavlov Version           : 9.20.00.0 Caption           : 7-Zip 9.20 (x64 edition)

Alright, now that we've added this, lets rerun the Configuration name (Command line : MonitoringSoftware -MachineName ConfigureMe) and then Start-DscConfiguration again  This time, it should ensure the files are there, and then install the application if its not there  Lets see what happens when its enacted.

!\[/caption\]

!\[/caption\]

Handling services is a bit easier, so I'll just paste one here as an example, this one ensures BITs is present, and if not, puts it there with IncludeAllSubFeature, to make sure it works.  I also gave the Resource a colorful name, to illustrate that you can do whatever you wish with resource names.

  WindowsFeature GotdemBITS #you can name these whatever you like,remember the best practices and pick a good name

 {

 Ensure \="Present"  Name \="BITS"             IncludeAllSubFeature\=$true          }

Because adding on the other Roles and Features gets to be quite repetitive, and the script and output take up a good bit of space, I'll spare you the suspense and show you the final script,  [available here](http://foxdeploy.com/code-and-scripts/dsc-script-and-output/ "DSC Script and Output").  After enacting this on our system running the test in PowerShell again should show all of the features are installed as they should be.

![](http://foxdeploy.files.wordpress.com/2014/02/dsc_05_configuration_gasm.png) Take this concept and scale it out over fifty servers and this becomes very compelling.\[/caption\]

Amazing.

And the best part? You can intentionally remove and delete the files or otherwise interfere with DSC and still the damage will be repaired when the configuration is applied again.  In a later post we'll get into how to configure your servers to either have DSC pushed to them (called…DSC push configuration) or to look to a particular place to pull down their configuration.  I'll also go into some more detailed real world scenarios, showing you how to install some very popular software.

One warning if you run into continual 'Errors occurred while processing configuration 'ConfigurationName' messages, check to ensure that you're listing the correct valid name of a Windows Feature or Registry key.  Also consider adding 'IncludeAllSubFeature=$true' to your configuration elements if the feature or role you're adding typically requires numerous dependencies.

### Going forward

If you'd like to learn some more about DSC, I recommend these resources.

[TechED - Talk by Ken Hansen and Jeffrey Snover](http://channel9.msdn.com/Events/TechEd/NorthAmerica/2013/MDC-B302#fbid=)

[Brad Anderson's Into the Cloud blog](http://blogs.technet.com/b/privatecloud/archive/2013/08/30/introducing-powershell-desired-state-configuration-dsc.aspx)

[Installing Package Reference](http://technet.microsoft.com/en-us/library/dn282132.aspx) 

[Keith Mayer's blog - Why R2?](http://blogs.technet.com/b/keithmayer/archive/2013/11/07/why-r2-automated-server-self-provisioning-and-remediation-with-desired-state-configuration-dsc-in-powershell-4-0.aspx#.UwvFpPldXEg)
