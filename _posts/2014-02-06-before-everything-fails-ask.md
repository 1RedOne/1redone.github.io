---
title: "Before everything fails, ask."
date: "2014-02-06"
redirect_from : /2014/02/06/before-everything-fails-ask
tags: 
  - "consulting"
  - "other"
---

This was a definite learning experience.

At a client recently for a side-by-side 2012 R2 SCCM migration, I was testing image build on desktop and laptop models, and noticed that some 2007 clients were able to detect the 2012 MP and were trying to download content from them!  That was very undesired, and so we delved into AD Sites and Services and discovered that some of the subnets in a particular site were more expansive than previously thought.  We then noticed a perfectly innocuous looking Site, 'CompanyLocation\_TestLab' and found that this corresponded to a switch in a testing area nearby.  Perfect!  I quickly edited the boundaries and set them to this new AD Site and resumed image testing.

And so began the slow. Image transfer, and content download dropped to a standstill, even though I applied the slow OSD KB to the boot images, CAS and DPs.

I finally asked if there was some sort of traffic bandwidth management/shaping protocol in affect on the testlab subnet. Well, turns out there was!! There was a bandwidth shaping device in place for this subnet that has transfers throttled down to much slower than t1 speeds, in order to test remote office performance for the slowest of remote sites. It made copying a 3 GB image take an astounding 13 hours.

All of this could have been avoided had I asked the right questions from the beginning.  It was a very teachable moment.

Before everything fails, ask.