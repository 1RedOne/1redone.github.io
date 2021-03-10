---
title: "Recovering your Dedeuped Files on Windows 10"
date: "2015-07-31"
redirect_from : /2015/07/31/recovering-your-dedeuped-files-on-windows-10
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
  - "virtualization"
tags: 
  - "deduplication"
  - "hyper-v"
  - "powershell"
  - "storage"
---

Were you one of those who installed the server 2012 binaries into your Windows 8.1 to enable Disk Deduplication? Did you turn on dedupe on all of your drives, saving hundreds of gigs of storage space, then upgrade to Windows 10?

Upon boot, were you greeted with frequent 'the machine cannot access the file' errors? If so, then this is the guide for you!

This fixes the error 0x80070780: The file cannot be accessed by the system

## What happened to my stuff? Did I lose it all?

NO!  You did not lose your files.  What happened when you ran deduplication on your files, is that Windows gradually scrubbed all of the common elements out of many files in order to compress them, much like what happens when you put files into a .zip or .rar archive.

All of your files still live on that disk or volume, happily compressed in their Optimized state and sitting snuggled up to their brethren.  However, until you 'Unoptimize' them, or connect the disk to a system with Windows Server Deduplication enabled, you cannot access any items bigger than 32KB (the minimum size for block level dedupe).

## You have two methods to recover your files

These are both very similar, in the outcome, only the beginning differs.

### Method 1 - Move the disk to another computer

Physically take the disks that are hosed and attach them to another system with 'Data Deduplication' enabled, could be any OS which supports it, even 8.1.  Once you've done this, proceed.

### Method 2 - use Hyper-V to virtually move the disk

This is the method I used.

1. Stand up another VM (in my case Server 2016 Tech Preview, though you could use 2012, 2012 R2, or even Windows 8.1) and installed the Storage -> Data Deduplication role on it.  Make sure to add one or more SCSI Hard Drive Controllers, one for each drive you need to 'redupe'.**Dedupe/redupe is incredibly IO and memory intensive.  Bump up the VMs stats to super level if you want this to be done quickly.**
2. Take the disks you need to 'redupe' offline.  I then went to my affected volumes in Disk Manager on my local machine and took the disks offline.  This is necessary in order to make this physical drive a 'Passthru' disk, which essentially connects the spinning disk to your VM.
    
    ![Once the disk is offline, we can attach it to a VM.  Do NOT accidentally format your drive here.](..\assets\images\2015\07\images/redupe.png?w=636)
     Once the disk is offline, we can attach it to a VM. Do NOT accidentally format your drive here.
3. In Hyper-V, attach the disk to your VM, by attaching it as a physical disk.[![redupe2](..\assets\images\2015\07images/redupe2.png?w=636)]
4. Go into your VM and run Disk Management, and bring the disk online.  Do NOT accidentally format your disk here either.
    
    ![If you format your drive here, you'll now have even more problems.](..\assets\images\2015\07\images/redupe3.png?w=636)If you format your drive here, you'll now have even more problems.
5. Once the disks are all online in your VM, launch PowerShell as an admin and then run Get-DedupStatus to verify that all of your drives are listed.
    
    ![redupe4](..\assets\images\2015\07\images/redupe4.png)
     Say goodbye to all of this optimized space...
6. For each drive, run the following Cmdlet.
    

```powershell 
     Start-DedupJob -Volume "D:" -Type Unoptimization
```
    
If you only have one drive, run the cmdlet with -Wait so you can see how incredibly long this is going to take.


7. Wait forever.  It takes a REALLY, REALLY REALLY really super long time to 'redupe' your files.
    
    ![It's been stuck at 0% for ten minutes!](..\assets\images\2015\07\images/redupe5.png?w=636)
    It's been stuck at 0% for ten minutes!
    
    If you want to know how long it will take if you didn't run this in -Wait mode, you can run
    
```powershell 
    Get-DedupJob
```
    
    to see how long it will take, but don't sit around.  It will take forever.
8. Send Microsoft an e-mail or [vote for this issue on User Voice](https://windows.uservoice.com/forums/265757-windows-feature-suggestions/suggestions/6530781-put-data-deduplication-dedup-into-windows-client). 
 Seriously, Windows Desktop Enterprise and Pro could use some more distinguishing features.  Vote this up and hopefully we'll get Dedupe as a standard feature with Threshold in October.

Big thanks to fellow Microsoft MVP Mike F Robbins for his tweets and post on the matter, and to Microsoft Storage Program Manager Ran Kalanch for helping me to understand exactly what I'd done to my drives at midnight of the Windows 10 release.