---
title: "Solved - Orchestrator 'Unexpected token '' in expression or statement'"
date: "2016-02-28"
categories: 
  - "scripting"
---

Boy oh boy,this is probably the single cause of most of the worlds Orchestrator frustration...and I think we've narrowed it down to a solution!

### Problem

When running a runbook, you encounter strange error messages like the following.



### Cause

Orchestrator runs afoul of unescaped quotes marks all the time.  Simply put, if you're running into messages like this one, look at the data in your Orchestrator pipeline for any instances of the following characters

> Single quotes '
> 
> Double quotes "
> 
> Backticks \`
> 
> Other Windows reserved characters, like asterisks \*

In our case, we were asking Orchestrator to connect to OpsMgr (SCOM), and pull the Alert Details.  We decided to hunt through the details of a few of our open alerts, looking for the number '30'.  And sure enough, we found it, wrapped in quotes!



### Solution

Especially if you're running PowerShell scripts in Orchestrator, make sure to sanitize your inputs, and ESPECIALLY do so if you're working with Subscribed Data.

In our case, we were unioning data from one of four different branches in our runbook, using a PowerShell script. This weird syntax you see below is parsed by SCORCH and replaced with data when the script runs

\[code language="powershell"\] #alert could be in one of four subscribed data variable, grab them all, and only select the ones with a value $AlertDescription = "\\\`d.T.~Ed/{7A0178D7-4832-42E4-89B5-CDE1D78DAA21}.ManagementGroup\\\`d.T.~Ed/", "\\\`d.T.~Ed/{464D77D7-C726-4391-855D-EA601A859AD0}.ManagementGroup\\\`d.T.~Ed/", "\\\`d.T.~Ed/{D9229F99-59FE-4F00-9274-E13A1205D388}.ManagementGroup\\\`d.T.~Ed/", "\\\`d.T.~Ed/{5F4E8FAA-B737-4DEB-973D-09A6C4E5D8C2}.ManagementGroup\\\`d.T.~Ed/" | ForEach-Object {if ($\_) {$\_}} \[/code\]

Since the data being dropped in would have a double quote in it, this would break out of the string we're defining here.

The workaround is to use here-strings to encapsulate the whole body of the string. Here-strings start with an AT Sign followed by a quote. PowerShell ignores all formatting characters within the text that follows, until it runs into a new line starting with a quote, followed by an AT sign. Like so.

\[code language="powershell"\] @" Put anything here, and PowerShell will respect white-space and ignore special characters, like single or double quotes "@ \[/code\]

We used this technique and encapsulated each of our four values in here-strings. Problem solved.

\[code language="powershell"\] #alert could be in one of four subscribed data variable, grab them all, and only select the ones with a value $AlertDescription = @" \\\`d.T.~Ed/{7A0178D7-4832-42E4-89B5-CDE1D78DAA21}.Description\\\`d.T.~Ed/ "@, @" \\\`d.T.~Ed/{464D77D7-C726-4391-855D-EA601A859AD0}.Description\\\`d.T.~Ed/ "@, @" \\\`d.T.~Ed/{D9229F99-59FE-4F00-9274-E13A1205D388}.Description\\\`d.T.~Ed/ "@, @" \\\`d.T.~Ed/{5F4E8FAA-B737-4DEB-973D-09A6C4E5D8C2}.Description\\\`d.T.~Ed/ "@ | ForEach-Object {if ($\_) {$\_}} \[/code\]

\[tweet https://twitter.com/FoxDeploy/status/666362240598212610\]
