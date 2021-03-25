---
title: "Part V - Introducing the FoxDeploy DSC Designer"
date: "2016-09-20"
redirect_from : 2016/09/20/part-v-introducing-the-foxdeploy-dsc-designer
coverImage: ../assets/images/2016/09/images/dsc-designer-3.png
categories: 
  - "scripting"
tags: 
  - "dsc"
  - "dsc-designer"
  - "gui"
  - "powershell"
  - "wmf"
---

[![Learning DSC Series](../series/images/series_dscsidebar.webp)](/series/LearningDSC)

This post is part of the Learning DSC Series here on FoxDeploy.com. To see the other articles, click the banner above!

* * *

For years now, people have been asking for a DSC GUI tool. Most prominently me, I've been asking for it for a longggg time!

My main problem with DSC today is that there is no tooling out there to help me easily click through creating my DSC Configurations, other than a text editor. For a while there, I was hoping that one of the tools like Chef or Puppet would provide the UX I wanted, to click my way through making a DSC Configuration for my machines...but after checking them out, I didn't find anything to do what I wanted.

So I made my own.

![](../assets/images/2016/09/images/dsc-designer-3.png)

### Release Version 1.0

[Get it here on GitHub!](https://github.com/1RedOne/DSC-Designer) 

### Want to contribute?

I've made a lot of PowerShell modules before but none of my projects have ever been as ambitious as this.  I welcome help!  If you want to rewrite it all in C#, go for it.  If you see something silly or slow that I did, fix it.  Send me Pull Requests and I'll merge them.  Register issues if you find something doesn't work.

I want help with this!

### Where will we go from here

This project has been a work-in-progress since the MVP Summit last year, when I tried to get MS to make this UI, and they told me to do it on my own!  So this is version 1.0.  Here's the planned features for somewhere down the road.

| Version | Feature | Completed |
| --- | --- | --- |
| 1.0 | Released! | ✔️ |
| 1.1 | Ability to enact the configuration on your machine |  |
| 1.2 | Button to jump to local dsc resource folder |  |
| 2.0 | Display DSC Configuration as a form |  |
| 2.? | render absent/present as radio button |  |
| ? | render multi-choice as a combobox |  |
| ? | render other options as checkbox |  |
| ? | render string as a textbox |  |
| ? | Display DSC Configuration as a form |  |
| ?? | Track configuration Drift? |  |

#### How was this made?

I thought you'd never ask.  C[heck out this link here to see how this app was made](https://foxdeploy.com/2016/09/20/part-vi-in-depth-building-the-foxdeploy-dsc-designer/).
