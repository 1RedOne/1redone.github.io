---
title: "Orchestrator: Solved 'Cannot invoke this function because current host does not implement it'"
date: "2015-03-30"
categories: 
  - "scripting"
tags: 
  - "opalis"
  - "orchestrator"
  - "scorch"
---

This is a very frustrating error in SCORCH, Opalis, Orchestrator, whatever you want to call it. Bring on SMA because I've had enough!

**Symptom** 

When running a PowerShell Script or an Exchange Administrative PowerShell Command in PowerShell, the activity will fail with:

> 'Cannot invoke this function because the current host does not implement it.'

**Cause**

The reason for this is that the command you're trying to run is trying to send confirmation back to the shell (end-user) to provide Confirmation before enacting a change.  The Orchestrator host doesn't have any mechanism to prompt for change, and thus the message we see.

As it turns out, the error message really was trying to help us, but just incredibly poorly written.

**Resolution**

There is a quick fix available for this, add either -Confirm:$false or -Force to your cmdlet, based on the command you're using.

Suggestion: replace this message with 'This cmd requires user feedbadk, and cannot be automated in it's current form. Try reading the Get-Help page for the cmdlet used, and consider adding -Force or -Confirm:$false if your cmdlet requires it'.
