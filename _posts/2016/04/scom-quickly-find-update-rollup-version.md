---
title: "SCOM: Quickly find Update Rollup Version"
date: "2016-04-06"
categories: 
  - "quickies"
  - "scripting"
tags: 
  - "powershell"
  - "scom"
---

It's SO tedious to track down the update rollup version of SCOM, as the SCOM console still doesn't have this information available (only major releases!), so you end up looking through the registry or digging into files trying to look at the file version manually.

I wrote this little script in PowerShell. Simply CD into the drive where SCOM is installed and it will track down the SCOM install directory for you, then pull out the Update rollup version and return it to screen.

[Download](https://gist.github.com/1RedOne/3e1599cb78e893cec9c374f985d4ccbd)
