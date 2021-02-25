---
title: "PowerShell Data deduplication commandlette Job types"
date: "2013-08-23"
redirect_from : /2013/08/23/powershell-data-deduplication-commandlette-job-types
excerpt: "In this post, we dive into some of the options for the dedupe cmdlets in PowerShell, so you can nuke your HomeLab too (foreshadowing...👻) "
categories: 
  - "scripting"
tags: 
  - "dedup"
  - "powershell"
---

In case you wondered what the various job types are for the Powershell Start-DedupJob and other commandlettes, here is the description from the TechNet developers reference.

The type of data deduplication job.

| Value | Meaning |
| --- | --- |
| 
**Optimization**

1



 | This job performs both deduplication and compression of files according data deduplication policy for the volume. After initial optimization of a file, if that file is then modified and again meets the data deduplication policy threshold for optimization, the file will be optimized again. |
| 

**GarbageCollection**

2



 | This job processes previously deleted or logically overwritten optimized content to create usable volume free space. When an optimized file is deleted or overwritten by new data, the old data in the chunk store is not deleted right away. Garbage collection is scheduled to run weekly by default and is recommended to run only after large deletions have occurred. |
| 

**Scrubbing**

3



 | This job processes data corruptions found during data integrity validation, performs possible corruption repair, and generates a scrubbing report. |
| 

**Unoptimization**

4



 | This job undoes deduplication on all of the optimized files on the volume. At the end of a successful unoptimization job, all of the data deduplication metadata is deleted from the volume. |

[http://msdn.microsoft.com/en-us/library/windows/desktop/hh769309(v=vs.85).aspx](http://msdn.microsoft.com/en-us/library/windows/desktop/hh769309(v=vs.85).aspx)
