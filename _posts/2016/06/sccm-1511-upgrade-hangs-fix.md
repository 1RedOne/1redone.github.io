---
title: "SCCM 1511 Upgrade Hangs Fix"
date: "2016-06-10"
tags: 
  - "sccm"
---

Recently for a customer, we ran into an issue in which the SCCM 1511 upgrade was hanging at the following screen.



If we open the SCCM install log file on the primary site, found at C:\\ConfigMgrSetup.log, we will see the following message:



This step should only take a few minutes to complete, if you've waited a while, like 20 minutes for us--then go ahead and help SCCM out.

It's trying to kill the SMS Component Manager service, and the SMS Exec service. If you've got a complex environment, it can take a long time to complete this step. Go ahead and stop the services manually using the task manager.

If this doesn't work (it didn't work for me, the services hung at 'stopping'), you can use powershell to kill the service instead.

From the Task manager, look at the process ID for your SMS component manager service, and then run

[![ohno5](https://foxdeploy.files.wordpress.com/2016/06/ohno5.png?w=636)](https://foxdeploy.files.wordpress.com/2016/06/ohno5.png)

`Stop-Process -ID SMSExecID,SMS_SITE_COMPONENT_MGRID`

And your install should proceed with no issues!
