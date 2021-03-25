---
title: "SCCM 1602 Query - All Online Machines"
date: "2016-06-24"
redirect_from : 2016/06/24/sccm-1602-query-all-online-machines
tags: 
  - "sccm"
coverImage: "../assets/images/2016/06/images/t01.png"
---

### Quickpost: SCCM 1602 Query - All Online Machines

With the Advent of client activity indicators in SCCM 1606:

![t01](../assets/images/2016/06/images/t01.png)

We can now see which machines are online at a given time.  I love these green checkboxes.

I thought it would be cool to try to make a collection of only currently online machines.  So, into the query editor we go!  We'll add a new query rule, and then use the wizard to add a new value.  This is all that you need to grab only the currently online systems.

![t02](../assets/images/2016/06/images/t02.png)

This collection works VERY well for Incremental Updates.  However, Scheduled Updates don't make much sense

And the end result:


