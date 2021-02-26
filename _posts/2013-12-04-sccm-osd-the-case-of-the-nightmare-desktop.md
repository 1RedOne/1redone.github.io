---
title: "SCCM OSD: The case of the nightmare desktop"
date: "2013-12-04"
redirect_from : /2013/12/04/sccm-osd-the-case-of-the-nightmare-desktop
tags: 
  - "osd"
  - "sccm"
  - "troubleshooting"
---

Recently, a client has been mentioning some issues they've had when doing image testing on a new desktop model.  I came in to help sort out the issue, and it was quite an experience!  We received all sorts of errors, many were quite puzzling.  In the end, this desktop (the HP ProDesk 6oo G1 SFF / Small Form Factor) and the issues around it tested every element of my SCCM OSD Troubleshooting knowledge. 

Now that the matter has been solved, I'll detail out the symptom and cause of each error:
<!--more-->
### On PXE Booting, the Task Sequence window never loads

Whenever a new model comes in to the environment, we always check to see if the machine can boot off of the drivers already imported into the wim.  In this case, the tech burned a disc using the old WIM, and once WinPE started, we were unable to connect to the SCCM Policy Provider to see what advertisements are available.

_Test via_: launching a command prompt (F8 if enabled on the WinPE WIM) and check to see if the system has an IP Address

### When a Task Sequence is selected, it immediately fails

Once we fixed the previous issue, Advertisements were now listed!  However, clicking one the TS would immediately fail.  This was because the Boot Image associated with that Task Sequence was not pushed to any distribution point.

_Test via_: Check the Task Sequence Properties and see if the associated boot image is available on a relevant DP given your testing.

### Domain Join begins to fail with no apparent cause

This was a strange one.  Checking the logs after a failure, I noticed Domain Join failing.  It turns out this was related to the wrong network driver being applied.

_Test via:_ Launch a command prompt and see if you can ping a domain controller.  If so, use runas to test your Domain Join account to ensure that everything is copacetic.

### TS Fails with error 80004004, Operation Aborted while on 'Copy logs on error' step

Another red-herring / network related failure.  The TS failed an earlier step and then skipped to the TS Error Steps. If something basic like this is failing, check your driver packages to see if the right driver pack for your model is being published.

### Fails with error 80070002, File not found on 'Use Toolkit Package Step'

After the Setup Windows Step of the Task Sequence (when the drivers are installed and Windows is booted for the first time), a reboot is initiated.  After the reboot, the computer couldn't find the MDT Toolkit anymore!

This was also traced to a network issue.

### At some point in the TS, Mouse and Keyboard become nonresponsive

Very very strange.  The TS hung after 'Setting up Windows for first use', and the Keyboard and mouse were completely nonresponsive.  I restarted the PC and checked the logs in the Task Sequence, noting that SetupAct.log completed without any errors, but the system wasn't able to see its drives.  At this point, I became very concerned.

### Task Sequence stops updating Status Messages with many instances of 80072ee7,

Again, network issue.

Given the two issues with networking and driver weirdness, I decided to double check everything the technician did.  The root cause was immediately apparent, and boiled down to two major issues:

1. The tech failing to specify the correct boot.wim for a task sequence caused a number of issues.
2. The task sequence in the post-install step featured a number of 'apply driver' steps.  When I reviewed the WMI queries, I found the query for apply driver package In the end, issue caused by two major issues, wrong boot.wim being used, and the wrong driver package being applied, creating a lot of troubleshooting work.  The tech who created the new boot.wim made Boot Task Sequence media using the correct boot.wim, but then never updated the test TS to reflect new boot image, meaning after the new TS was chosen, the boot.wim for that TS was downloaded, which didn't have the right drivers).

### Final Resolution

After spending a few hours trying to troubleshoot these symptoms, my troubleshooting instincts kicked into high-gear and told me to look outside the box for a shared potential cause of all of these symptoms.  Listing the facts helps a lot:

- The Tech involved in creating this driver package often requests assistance for these requests, but wanted to handle this one on his own.  There is nothing wrong with this behavior, but he tends to copy & paste quite often, particularly with WMI or SQL queries.
- The Task Sequence involved lays down driver packages based on a WMI query.
- After a few days left to his own devices modifying the Task Sequence I setup initially, we received reports that imaging of this particular model worked at one point, but then stopped, leading me to believe a change in the TS caused the current weirdness.

I opened up the Task Sequence and checked the apply drivers package step.  There, clear as day, was the cause of all of the above problems.  He copied the apply drivers step from another model and changed the WMI Query, but forgot to select the correct driver package.

**Moral of the story:** When things get REALLY weird, double-check the simple things.  Like the Russians and Reagan say:

_'doveryai no proveryai'_ Trust, but verify.
