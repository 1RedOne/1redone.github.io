---
title: "Quickie - Join video files with PowerShell and FFMPEG"
date: "2018-10-29"
categories: 
  - "quickies"
  - "scripting"
tags: 
  - "ffmpeg"
  - "powershell"
---

![Caption Text says 'Join Video Files quickly, gluing stuff with PowerShell and ffMpeg', overlaid on an arts and craft scene of glues, papers, scissors and various harvest herbs](images/join-video-files-quickly1.png)

While I'm working on some longer posts, I thought I'd share a quick snippet I came up with this weekend as I was backing up a number of old DVDs of family movies.

FFMPeg has the awesome ability to join a number of video files together for you, but the syntax can be kind of strange.  Once I learned the syntax, I sought to make sure I never had to do it again, and created this cmdlet.

##### Usage notes

In this basic version, it will join every file in a directory, giving you `Output.mkv`.  Be sure your files in the directory are sequentially ordered as well, to control their position.

Ensure that FFMpeg's binaries are available in your Path variable as well.

Later on, I may add the ability to provide which specific files you want to join, if desired :)

Enjoy :)

https://gist.github.com/1RedOne/a486ac3e4ba5afa017eb190b5496b0d1
