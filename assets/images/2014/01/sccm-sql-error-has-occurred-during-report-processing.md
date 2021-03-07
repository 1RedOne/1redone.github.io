---
title: "SCCM SQL Reports fail with 'An Error has occurred during report processing'"
date: "2014-01-23"
tags: 
  - "sccm"
  - "troubleshooting"
---

Recently at a client, we encountered this lovely error message when launching a Configuration Manager (ConfigMgr) report from the webconsole:

"An error occurred during client rendering. An error has occurred during report processing. (rsProcessingAborted) Cannot impersonate user for data source 'AutoGen\_\[GUID\]\_'. (rsErrorImpersonatingUser) Log on failed. (rsLogonFailed) For more information about this error navigate to the report server on the local server machine, or enable remote errors "

Additionally, we witnessed a similar message with stack trace info in the SCCM console itself.

Such a great way to start your day, eh?

The fix for this error is one of two things:

1. Ensure that you're using a service account to access the SCCM Data Source, this is configured under Administration -> Site Configuration ->Servers and Site Roles->Site Server Running Reporting->Reporting Services Point.
    
    Double-check that a local user account with a changing user account IS NOT being used.
    
    If these credentials are valid, move on to #2.
2. Connect to the reporting service point with an account that has administrative rights from a web console.  Click your SQL Reporting instance and go to Security.  Ensure the account above has at least SQL Reporting Administrator rights.
    
    If this is set, move on to #3.
3. Launch Reporting Services Configuration Manager and connect to the server running your SQL Reporting Instance.  Ensure that the same account above is listed as the Execution Account.

We detected that the issue was caused by an administrators account being used for the above fields (it was set during installation before the service account was ready), and the password recently changed.  Hope this helps!
