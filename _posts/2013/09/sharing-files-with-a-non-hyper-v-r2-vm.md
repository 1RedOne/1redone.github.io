---
title: "Sharing files with a Non Hyper-V R2 VM"
date: "2013-09-23"
categories: 
  - "virtualization"
---

Hi all,

 

Recently I got sick of constantly having to break my scripts down into 512 character chunks ([here is a great work-around if you want to increase the amount](http://social.technet.microsoft.com/Forums/windowsserver/en-US/3973d9be-e2c6-4535-a0cf-b4db19423002/workaround-pasting-text-to-hyperv-guests-sometimes-results-in-garbled-characters) ) I decided to come up with a--what I feel-- is clever work-around to this problem.

 

1. First, from the parent partition, create a new VHDx file.  Mount this to your host OS.
2. Copy any scripts, files, etc you'd like to share with the guest it into the file
3. Mount this VHDx on the SCSI controller of your VM (to get live access to it)
4. Enjoy!

 

In order to copy back and forth, you'll need to take the vhd offline from Disk Manager on the host machine, and likewise for the guest, but it is a work-able work-around.
