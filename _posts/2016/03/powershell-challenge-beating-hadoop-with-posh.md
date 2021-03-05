---
title: "PowerShell Challenge - Beating Hadoop with Posh"
date: "2016-03-01"
categories: 
  - "other"
  - "scripting"
tags: 
  - "powershell-challenge"
---

### Update

Read [the follow-up with in-depth analysis](https://foxdeploy.com/2016/03/23/coding-for-speed/) for many of the techniques used by our combatants!

* * *

 

### Premise

Saw this super interesting read online over the weekend:

[Command line tools can be 235x faster than Hadoop](http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html)

In this post, the author posits that he can crunch numbers from the Linux command line MUCH faster than Hadoop can!

If he can do that, surely we can also beat the Hadoop Cluster...then I started wondering how I would replicate this in PowerShell, and thus this challenge was born...

**Challenge**

- **[Download the repo here](https://github.com/rozim/ChessData) (2gb!), unzip it and keep the first 10 folders**
- This equates to ~3.5 GB, which is roughly the same data size from the original post
- Be sure to only parse the first 10 folders :)
    
    
- Iterate through all of those Chess Record files it contains(\*.pgn) and parse each record out.  We need to return a total count of black wins, white wins and draws.  To read a PGN:

> We are only interested in the results of the game, which only have 3 real outcomes. The 1-0 case means that white won, the 0-1 case means that black won, and the 1/2-1/2 case means the game was a draw. There is also a _\-_ case meaning the game is ongoing or cannot be scored, but we ignore that for our purposes.

- Use solid PowerShell best practices, pipelines or whatever you want to beat the Hadoop cluster's time of 26 minutes!

**To enter**

Post your comment with a link to a [Github Gist](https://help.github.com/articles/creating-gists/#creating-a-gist) or the code you used to solve this problem.  Have it in by March 19th.

Winners will be determined by my decision, one from each of these categories:

- Creative Coder Award- could be tersest, most 'Dave Wyatt', or the most dot net
- Most 'Best Practice' award- if you're emitting objects and embracing the teachings of Snover, you're in the running
- The So Fast Award- fastest wins, bar none

Remember, OP from the other thread did this all in a pipeline of Linux. PowerShell is all about the pipeline. So embrace it to win!

Here's how this will work. Once the time is up, I'll take everyone's final submission and then script them to run one after the next with a console reset in between. I'll run them on my pc with a newer i7 and put the input files on a ramdisk.

This will decide the speed winner. The other two will be hand selected, by me. I'll write up a short post with the findings and announce the winners on the 20th.

**The luxurious prizes**

Winners will get their pick from this pile of github and PowerShell stickers!

[![image](images/wp-1456789783952.jpg "wp-1456789783952")](http://foxdeploy.files.wordpress.com/2016/02/wp-1456789783952.jpg)

I'll mail it to you unless you live in the middle of nowhere Europe and shipping will kill me.

**Have your entry in by March 19th!**

I'll post my best attempt once the entries are in!
