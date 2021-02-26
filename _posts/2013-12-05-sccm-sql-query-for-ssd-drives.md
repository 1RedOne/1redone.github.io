---
title: "SCCM SQL Query for SSD Drives"
date: "2013-12-05"
redirect_from : /2013/12/05/sccm-sql-query-for-ssd-drives
categories: 
  - "sccm"
  - "sql"
---

Recently at a client, a need arose to provide a report listing whether a workstation had an SSD or a spinning disk.

Unfortunately, Windows does not concern itself with noting whether or not a disk is spinning or solid state, and thus the information is not in the registry or WMI for us to collect with SCCM.

However, most manufacturers stick to a naming convention, and with a little bit of elbow grease, you can expand this to work in your environment too.  In this format, you'll get 'Known SSD Drive' if the drive model or naming is captured in the CASE filter of query, or the drive model if not.

Jump here for the code : [Detect SSD Drive](/series/snippet-randomSql)

