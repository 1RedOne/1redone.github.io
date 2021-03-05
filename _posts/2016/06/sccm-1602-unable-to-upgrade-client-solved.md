---
title: "SCCM 1602 - Unable to upgrade client solved"
date: "2016-06-24"
tags: 
  - "sccm"
coverImage: "sccm03.png"
---

This was a bit tricky!  We completed an SCCM upgrade for one customer from SCCM 1511 to 1602, and made use of the nice pre-production client validation feature.

This allows you to specify a collection of test systems to receive the new SCCM client, for you to validate in your environment.

After a few days of validation, we were ready to pull the trigger and upgrade everyone. This is done under **Administration \\ Cloud Services \\ Updates and Servicing \\ Client Update Options**.  However, when we tried to do this, it was grayed out!

![sccm01](images/sccm01.png)

**Root Cause**

Before trying to upgrade the client, I thought we should un-check the pre-production Collection box in Hierarchy Settings.  This is done in **Administration \\ Sites\\ Hierarchy Settings**.

![sccm02](images/sccm02.png)

Don't do this!  If you uncheck this box, the SCCM ui will detect it, and gray out the SCCM won't display the UX we need to promote the SCCM client to production.

**Fix**

Make sure that you check the Pre-production client box.  If this isn't checked, SCCM doesn't know to show you the UI for upgrading the client across production!

![sccm03](images/sccm03.png)

Once this is done, you can go to Updates and Servicing, and click Client Update Options.

![sccm04](images/sccm04.png)

Complete this UI and SCCM will automatically uncheck the pre-production client for you as well.  Thanks SCCM!

![sccm05](images/sccm05.png)
