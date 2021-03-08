---
title: "Nomad Question : How do I push content out ahead of an advertisement?"
date: "2014-03-09"
redirect_from : /2014/03/09/nomad-question-how-do-i-push-content-out-ahead-of-an-advertisement
tags: 
  - "1e"
  - "nomad"
  - "sccm"
---

Hi all,

Recently I recieved a question about 1E Nomad that I wanted to answer.

>  _In SCCM, it is a common practice to distribute content to your DPs before creating an advertisement.  How do I do that with Nomad, considering that all of your Nomad clients as a whole act as kind of a pseudo-Distribution Point?  How do you distribute content without creating an advertisement?  How do you verify that content is there?_

With Nomad, content is only distributed to clients if an advertisement exists, so if you want to be certain the content will be present in an area before the clients begin to execute, you'd set an available date sufficiently in advance of the mandatory execution date for your advert.  In short, you have to create an advert to get content out to your clients when Nomad is used.

You can mandate that a number of packages, driver images, or boot images to be distributed out by creating a content pre-staging task sequence.  In this case, you'd add as many steps as needed for all of your content, and then advertise it to as many PCs as you want to distribute the content, with an available date of now, and an install date set to far, far in the future.  You can also place all of the content steps within a Task Sequence group that has a condition which would never evaluate to true, like "If ChasisType -equals SomethingUnlikely"

As for verifying the content is on the sites, installation of Nomad includes a number of reports that list package availability by subnet.  You can use this report to verify that content is available on a particular subnet.  If so, this would roughly correlate to a package existing on a DP in a traditional SCCM hierarchy.

These reports depend on some additions to SMS\_DEF and Configuration.mof files, which will increase the size of the files processed by your SCCM servers.  Watch out for an increase of data to be processed by your site servers, after importing these new definitions.  It can result in increased memory usage by WMI, and you may find 'Quota Exceeded 0x8004106c' errors in your SMS Provider log file.  If you run into this, increase the WMI memory quota.
