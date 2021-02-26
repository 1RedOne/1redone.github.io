---
title: "Solving SCCM Error ID 682, authentication key did not match"
date: "2013-10-07"
redirect_from : /2013/10/07/error-code-682-gathering-machine-names-from-sccm-status-messages
tags: 
  - "sccm"
  - "sql"
---

I ran into an issue at a client in which dozens of systems were not replicating their PKI key data up the hierarchy, thus causing the Central site to trigger critical alerts while processing the Data Discovery, Software Inventory and Hardware inventory records from these clients every night.  This bugged me, and I wanted an easy way to track down these systems.

The Error ID is 682.
<!--more-->

>Component Discovery\_Data\_Manager

>The data file "E:\\SCCM\\inboxes\\auth\\ddm.box\\5tn3ejdr.DDR" that was submitted by the client whose SMS unique ID is "GUID:", was rejected because the file was signed but the authentication key did not match the recorded key for this client.

However, the systems are not referred to by name in the status message reports, but rather by their SMSGuid.  By using this GUID with a few other table joins in SQL, I was able to get a list of all of the systems with invalid key data on the Central site.

I hope that this will be helpful to someone else.

**Edit: the instructions for the SQL code now live here [\[Get System Names from SCCM Status Messages, the easy way\]](/series/snippet-randomSql).**

The output is a nice and legible list of all of the systems currently mentioned in the Error Code above; you could easily tweak this by changing the error code, and get any systems listed in any status message. You could then use this to put them in a collection via direct membership  query, as described in a previous post) to run a group Data Discovery Record, or if need be, delete reinstall the clients with the `RESETKEYINFORMATION=TRUE` setting.

The goal is to garner human-understandable system names from the SMS Guid.   Once you’ve verified the records in SCCM you can then consider deleting these records from the Central site as mentioned in this article([http://blogs.technet.com/b/dominikheinz/archive/2010/09/29/clientkeydata-gets-corrupted-on-central-site-server.aspx?CommentPosted=true#commentmessage](http://blogs.technet.com/b/dominikheinz/archive/2010/09/29/clientkeydata-gets-corrupted-on-central-site-server.aspx?CommentPosted=true#commentmessage)), and allow the data to replicate back from the Child Primary sites.

This process should allow the SMS database to hopefully record the correct PKI data, so that the DDRs and other inventory data will be processed without throwing errors.
