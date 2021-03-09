---
title: "Orchestrator and PowerShell - Solved: the execution of scripts is disabled on this system"
date: "2015-03-06"
categories: 
  - "scripting"
---

System Center Orchestrator (formerly Opalis Orchestrator) is a wonderful tool for automating heavy lifting in your environment, like managing Exchange server Windows Updates, while respecting DAGs, or other situations with repetitive tasks that can take a lot of manual labor, so long as the logic for responding to particular circumstances are well understood.

That being said, Orchestrator can be one of the most daunting and gotcha ridden programs for any System Center Devop and Wintel admin to wrap his head around.

Take this case, I have a straightforward task that involves running a PowerShell script, but every time I run a script, I run into this…

**Problem**

When using the Orchestrator commands for 'Run .Net Script', 'Run PowerShell Script', or 'Run Exchange Management Shell Cmdlet', the following error occurs, halting runbook.

**![PowerShell invoke error: There were errors in loading the format data file:  Microsoft.PowerShell, , .format.ps1xml : File skipped because of the following validation exception: File .format.ps1xml   cannot be loaded because the execution of scripts is disabled on this system](images/SCORCH.png)**

Text from error

>  PowerShell invoke error: There were errors in loading the format data file:
> 
> Microsoft.PowerShell, , .format.ps1xml :
> 
> File skipped because of the following validation exception: File .format.ps1xml
> 
> cannot be loaded because the execution of scripts is disabled on this system.

 

**Reason**

This seems fairly straight forward, there's a problem with the execution Policy, so I should go in and launch PowerShell as an administrator then run 'Set-ExecutionPolicy RemoteSigned' or unrestricted, right?

Well, there's a gotcha.  System Center Orchestrator was developed as an x86 program only.  This means that when it launches PowerShell, it also calls the 32-bit version of PowerShell too.  If you're running on a server 2008 and up, chances are you're running a x64 version of Server, and so when you launch PowerShell, by default you'll be running the 64 bit version.

PowerShell has separate execution policies for 32bit and 64bit mode.

**Solution**

Depending on whether you're running the Runbook tester, or if you're launching the Runbook from the Orchestration console:

If running the Runbook Tester: on the local system, launch PowerShell in x86 mode as an admin, and run Set-ExecutionPolicy RemoteSigned.

If launching the Runbook from the Orchestration Console: connect to the Runbook server (as PowerShell and all commands will be executing from there), launch PowerShell in x86 mode as an admin, and run Set-ExecutionPolicy RemoteSigned.

**Summary**

This is a reliatively simple problem, made more complex by the need to distinguish between where PowerShell is actually running, and also needing to know which version of PowerShell in which to make the change.

I hope this saves you some time, could have saved me about four hours today!
