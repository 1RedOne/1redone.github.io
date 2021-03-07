---
title: "SCCM: Dealing with an out of sync child primary"
date: "2014-03-31"
categories: 
  - "sccm"
---

Hi all,

Recently I had a client in which one primary seemed to gradually fall behind in reporting on the central site.   Eventually, clients would be listed as 'Not Approved' in the Central Site, and this would cause advertisements and requests for policy to fail with frequent messages like this one:

Component: SMS\_MP\_CONTROL\_MANAGER

MP has rejected a policy request from GUID:XXXXX-XXXX-XXX-XXX-XXXXXXXXXXXXXX because it was not approved.

It's pretty straightforward here, advertisements from the central site will not register in many cases on these clients from the child primary sites.  In this case, this communication issue is serious.

There are many causes for situations like this, either an unreliable communication link to the primary, or address and sender settings being set too strictly.  Regardless, here is the method to fix this issue quickly.

1. Connect to the affected Child primary and make a backup of all of the files in the replmgr.box folder (in case they are needed). Then delete all of those items, getting rid of the backlog.  We don't need these files as we're about to instruct ConfigMan to seriously overshare and re-report pretty much everything.
    
    I'm actually not convinced you need to do this.  If your replication issue isn't fixed at first go, give this a shot and then repeat the remaining steps.
    
2. Next, connect to the central site, and from an administrative command prompt, browse to your SCCM install directory.  From there, browse to \\bin\\i3860000409\\ and run preinst.exe /SyncChild \[ChildSiteCode\]
3. Finally, connect back to the Child Primary site and runn preinst.exe /SyncParent

If all works as expected, grab some popcorn and then get ready for some excitement in the log files.  Open up sender.log/replmgr.log on the central site, as well as despool/replmgr.log on the Child, and you should see a flurry of replication activity.

When things settled down, refresh the SCCM console from the Primary, and all of the clients from the Child primary should now be listed as Approved.

Big thanks to [Xin](http://social.technet.microsoft.com/profile/xin%20%20guo/?ws=usercard-mini) from the MS forums for setting me on the appropriate path to solving this.
