---
title: "Hyper-V, fixing moved VHD files"
date: "2013-09-04"
categories: 
  - "virtualization"
tags: 
  - "hyper-v"
  - "powershell"
---

Here is a scenario for you: some lowly admin thinks he will free up space by moving a VHD file, or perhaps you add more storage to your home test lab, and move your VHD files to the new drive.  If you tried this operation while the VM is running, the file copy will fail.

If you try this on saved or shut down VMs, you can definitely move the virtual hard drive (.vhdx file) which will cause the VM associated with it to rather predictably fail when powered on, as seen below.

\[caption id="" align="alignnone" width="440"\][![1](images/11.png "An error occurred while attempting to start the selected Virtual Machine")](http://foxdeploy.files.wordpress.com/2013/09/11.png) Failed to restore with error The System cannot find the file specified.  
Attachment .vhdx not found. The System cannot find the file specified.  
The hard disk image file does not exist.\[/caption\]

Lets verify by going to the path specified.

\[caption id="" align="alignnone" width="440"\][![2](images/21.png)](http://foxdeploy.files.wordpress.com/2013/09/21.png) Sure enough, there is no VHD file at the path listed.\[/caption\]

Now, lets determine where the VHD file went off to.  Lets use Powershell to track down the VM's ID.

\[caption id="" align="alignnone" width="440"\][![3](images/31.png)](http://foxdeploy.files.wordpress.com/2013/09/31.png) Here we are searching for VMs that match the name specified, and then selecting the VM id and the VM Configuration File storage Path (E:\\) in the screenshot above.\[/caption\]

Using this [excellent blog post](http://blogs.msdn.com/b/virtual_pc_guy/archive/2010/03/10/understanding-where-your-virtual-machine-files-are-hyper-v.aspx) by Ben Armstrong I determined that the VM configuration files are stored in the Virtual Machines folder on the path specified in the Powershell output (you can also check this using the Hyper-V console)

\[caption id="" align="alignnone" width="440"\][![4](images/41.png)](http://foxdeploy.files.wordpress.com/2013/09/41.png) Sure enough, we see a Virtual Machines folder in the path specified.\[/caption\]

Earlier, we saw that the VM ID was 6D68E..., lets open the configuration file associated with it.

 

[![5](images/5.png)](http://foxdeploy.files.wordpress.com/2013/09/5.png)

 

Search for the VHD path we gathered from the earlier error message.  You should find this under the <controller#> <drive#> tags in the XML.  Replace the incorrect path with the correct path.  Be sure to omit any single or double quotes.

[![6](images/6.png)](http://foxdeploy.files.wordpress.com/2013/09/6.png)

 

Now save the file, and try to restart the VM again with Hyper-V or Powershell.

\[caption id="" align="alignnone" width="1036"\][![7](images/7.png)](http://foxdeploy.files.wordpress.com/2013/09/7.png) If all went well, you should now see the VM started successfully!\[/caption\]

I hope this helps you!
