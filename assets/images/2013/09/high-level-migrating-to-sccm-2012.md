---
title: "High-level : Migrating to SCCM 2012"
date: "2013-09-20"
tags: 
  - "sccm"
---

High level steps:

- INSPECT AND THINK ABOUT YOUR DESIGN - if you are building your 2012 layout the same way that you did your 2007, you are doing it wrong!
    - BIG CHANGES: Role Based Access Control makes it very easy to delegate permissions, and hides things that a user cannot access or change.  Makes it easy to resolve the political reasons to keep infrastructure distinct
    - CLIENT SETTINGS: No longer need separate primaries for different client settings.  This alone will remove the need for distinct primaries for various regions.
    - DPs can now control bandwidth much better than before.
- Have to be SCCM 2007 SP2 or higher.  Being R2 or R3 is immaterial.
- Move packages from drive letter to server share/UNC Path
- Separate user and devices in collections (if any collections contain mixed membership, they can't be migrated and neither can any collections referencing them)
- Build SCCM 2012 Infrastructure
- Enable Migration role in SCCM 2012
- Begin migrating things over
- Distribute SCCM 2012 client
    - SCCM 2012 Client depends on .Net 4 FW, which take a long time to install, deploy ahead of time!!
- Begin testing functionality with pilot group
- Inspect legacy packages and determine which are good candidates for being made into Applications
    - For instance, multiple packages or programs for the same app based on different architectures or things like that are a great candidate for Applications with different Deployment types
    - Very simple applications or scripts may be better served staying as a legacy Program
- Can run the two side-by-side and the process is not destructive to 2007 in any way (except needing to reinstall clients). So for DR/Fail-back could keep 2007 around if desired.

 

 What will not migrate:

- Custom reports (in SCCM) will not migrate.  The only way to migrate these is to set up SSRS for SCCM and export your custom reports as .rdl files.  They will be imported into SCCM 2012's SQL Reporting Instance
- SCCM Queries also do not migrate
- All inventory data is reset.  You cannot migrate the old inventory info from 2007 to 2012
