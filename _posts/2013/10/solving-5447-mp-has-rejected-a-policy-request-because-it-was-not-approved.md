---
title: "Solving 5447, MP has rejected a policy request because it was not approved."
date: "2013-10-21"
tags: 
  - "sccm"
  - "sql"
  - "troubleshooting"
---

You may see the error message like this from time to time:

>  Component: SMS\_MP\_CONTROL\_MANAGER
> 
> MP has rejected a policy request from GUID:XXXXX-XXXX-XXX-XXX-XXXXXXXXXXXXXX because it was not approved.

This really means that the client…is not approved.  This can happen for a few reasons, but namely one.  If you set SCCM to Manual Approval mode at some point, be it for testing or troubleshooting, any clients that attempted to be approved at that time are marked as Unapproved, pretty much until the end of time.  You have to find these systems and mark them as approved.

If you use my method to[\[get system names from a status message](http://foxdeploy.com/code-and-scripts/get-system-names-from-sccm-status-messages-the-easy-way/ "[Get System Names from SCCM Status Messages, the easy way]")\], you can just run this on the status message Id of '5447' and see the computer names.  Now, just copy and paste these into the SCCM WQL query I've provided here [\[Where machine name is in this list of names\]](http://foxdeploy.com/code-and-scripts/where-machine-name-is-in-this-list-of-names/ "Where Machine Name is in this list of names"), approve them all and here you go, problem solved.
