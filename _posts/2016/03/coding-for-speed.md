---
title: "Coding for speed"
date: "2016-03-23"
categories: 
  - "scripting"
---

![CODING FOR SPEED](images/coding-for-speed.png)

In this post, we review some of the things we learned about coding for speed in the [Hadoop PowerShell challenge](http://foxdeploy.com/2016/03/01/powershell-challenge-beating-hadoop-with-posh/). The winners are at the end of this post, so zip down there to see if you won!

We'll use the post to cover some of what we learned from the entries here.  Here's our top three tips for making your PowerShell scripts run just that much faster!

### When searching through files, don't use Get Content

As it turns out Select-String (PowerShell's text searching cmdlet) is capable of mounting a file in memory, no need to gc it first. It's also MUCH slimmer too, and has speed for days.  Look at the performance difference in this common scenario, searching 10 directories of files using `Select-String` , and then stark contract compared to `Get-Content`.

\[code language="powershell"\] #Get-Content | Select-String example dir $pgnfiles | select -first 10 | get-content | Select-String "Result"

#Select-String Only example dir $pgnfiles | select -first 10 | Select-String "Result"

Testing GC | Select-String...3108.5527 MS Testing Select-String Only...99.1534 MS \[/code\]

**Using Select-String alone is a 31x Speed Increase!** This is pretty much a no-brainer.  If you need to look inside of files, definitely dump your `Get-Content`  steps.  Credit goes to [Chris Warwick](https://twitter.com/cjwarwickps) for this find.

https://twitter.com/cjwarwickps/status/706831084374327296

### $collection += $object is SLOW!

We see this structure a LOT in PowerShell:

\[code language="powershell"\]#init my collection $collection = @()

ForEach ($file in $pgnfiles) {

$collection += $file | Select-String "Result"

}

$collection\[/code\]

This structure sets up a 'master list', then does some processing for each object, eventually adding it to our master list, then at the end, display the list.

> _Why shouldn't I do this?_

PowerShell is based off of dotnet and **some dotnet variable types including our beloved string and array are immutable.**  This means that PowerShell _can't simply tack your entry to the end of $collection_, like you'd think.

No, instead PowerShell has to make a new variable equal to the whole of the old one, add our new entry to the end, and then throws away the old variable. This has almost no impact on small datasets, but look at the difference when we go through 100k GUID here!

\[code lang="powershell"\]Write-Output "testing ArrayList.."

(measure-command -ex {$guid = new-object System.Collections.ArrayList 1..100000 | % { $guid.Add(\[guid\]::NewGuid().guid) | out-null

}

}).TotalMilliseconds

Write-Output "testing \`$collection+=..."

(measure-command -ex {

$guid = @() 1..100000 | % { $guid += \[guid\]::NewGuid().guid }

}).TotalMilliseconds

testing ArrayList... 7784.5875 MS testing $collection+=...465156.249 MS\[/code\]

**Sixty times faster!!!** The really crazy part, you can watch PowerShell's RAM usage jump all over the place, as it doubles up the variable in memory, commits it, and then runs GarbageCollection.  Watch how the RAM keeps doubling, then halfing!



 

#### How do I not use $collection += structure in my code?

`ArrayList` will be your new best friend.

Array list is a bit different from a regular string; here's how you do it. First you have to make a new array list (which developers call instantiating an instance of a class, sounds so cool to say it!), like so:

\[code lang="powershell" light="true"\] $collection = New-Object System.Collections.ArrayList \[/code\]

Next, we iterate through each object, and here's the real difference.

We call the ArrayLists .Add() method, instead of using the += syntax. Finally at the end, we get the whole list back out by using return, or just putting the variable name in again.

\[code lang="powershell" light="true"\] ForEach ($file in $pgnfiles) { $result = $file | Select-String "Result" $collection.Add($result)

} return $collection \[/code\]

You might notice when you run this that you see something like this:



ArrayList is a bit weird.  when you add an entry to it, ArrayList responds back with the index position of the new item you added.  In some use case in the world, this might be helpful, but not really to us.  So, we just pipe our .Add() statement into null, like so:

\[code language="powershell" light="true"\]$collection.Add($result) | Out-Null\[/code\]

Some people put \[void\] on the front of the line instead, same result.

In one project we were migrating customers from two different remote desktop systems into one with some complex PowerShell code. There was a section of the code which built a list of all of there files and omitting certain ones. When we swapped out $string += for array list, we dropped out execution time from six minutes to only 20 seconds! A huge performance boost with this one tip!

### The fastest way to read a file, stream reader

I was simply astounded to see the tremendous speed difference between using PowerShell's `Get-Content` cmdlet versus the incredibly fast StreamReader.

Here's why Get-Content can be a bit slow.  When you're running Get-Content, or Select-String, PowerShell is reading the whole file into memory at once.  It parses it and dumps out a object for each line in the file, sending it on down the pipeline for processing.

This is VERY SLOW on big files.  If you'd like to know a bit more, read [Don's great post on Get-Content here](http://powershell.org/wp/2013/10/21/why-get-content-aint-yer-friend/), or [Keith's write-up here](https://rkeithhill.wordpress.com/2008/03/02/nothings-perfect-including-powershell/).

When we're working with large files, or lots of small files, we have a better, option, and that is the StreamReader from .Net. It IS fundamentally different in how it presents the content from the file, so here's a comparison.

\[code lang="powershell" collapse="true"\]#Working with Get-Content

#Read our file into File $file = Get-Content $fullname

#Step through each line foreach ($line in $file){ #Do something with our line here #ex: if($line -like "\[Re\*") { $results\[$line\]+=1 } } \[/code\]

And now, with StreamReader

\[code lang="powershell" collapse="true"\]#Same concept but with StreamReader

#Setup a streamreader to process the file $file = New-Object System.IO.StreamReader -ArgumentList $Fullname

:loop while ($true ) { #Read this line $line = $file.ReadLine() if ($line -eq $null) { #If the line was $null, we're at the end of the file, let's break $file.close() break loop } #Do something with our line here if($line.StartsWith('\[Re')) { $results\[$line\]+=1 }

}

\[/code\]

So, now that you've seen how it works, how much faster and better is it?

### Speed results

The numbers speak for themselves

<table style="table-layout:fixed;"><colgroup><col> <col> </colgroup><tbody><tr><th>Method</th><th>Time</th></tr><tr><td>Get-Content</td><td>3562 MS</td></tr><tr><td>&nbsp;StreamReader</td><td>&nbsp;133 MS</td></tr></tbody></table>

StreamReader is 26 times faster!

#### Wouldn't it be great to have a PowerShell snippet for StreamReader?

I thought so too! So here you go.  Load this into the ISE and run it once.  After that, you can hit `Ctrl+J` and have a nice sample StreamReader code structure.

\[code lang="powershell" collapse="true"\]$snippet = @{ Title = 'StreamReader Snippet' Description = 'Use this to quickly have a working StreamReader' Text = @" $fullname = #FilePathHere begin { $results = @{} }

process { $file = New-Object System.IO.StreamReader -ArgumentList $Fullname

:loop while ($true ) { $line = $file.ReadLine() if ($line -eq $null) { $file.close() break loop } if($line.StartsWith('\[Re')) { #do something with the line here $results\[$line\]+=1 } } } end { return $results } } "@ } New-IseSnippet @snippet\[/code\] This syntax comes to us by way of [u/evetsleep](https://www.reddit.com/user/evetsleep), [/u/Vortex100](https://www.reddit.com/user/vortex100) and Kevin Marquette, from [Reddit/r/powershell](http://reddit.com/r/powershell)!

### Other ways to speed up your code

I know I said my top three tips, but I also want to give a little extra.  Here are some extra BONUS TIPS for you.

**Runspaces are crazy fast** - Boe Prox turned in an [awesome example of working with RunSpaces, here](https://gist.github.com/proxb/eba9b262e1dcb593ec94).  If you'd like to read a bit more, check out his full write-up [guide here. This guide should be considered REQUIRED reading](http://learn-powershell.net/2012/05/13/using-background-runspaces-instead-of-psjobs-for-better-performance/), if speed is your game. Amazing stuff, and incredibly fast, much better than using PowerShell Jobs.

**Taking out your own Trash** - This cool tip comes to us from [Kevin Marquette](https://twitter.com/KevinMarquette).  If PowerShell has some monster objects in memory, or you just want to clean things up, you can call a System Garbage Collection method to take out your trash, like so:

\[code lang="powershell" light="true"\]\[GC\]::Collect()\[/code\]

**True Speed comes from going native** - The fastest of the fast approaches used native c# code which powershell has supported since v 3. Using this, you gain a whole slew (that's a technical term) of new dotnet goodness to play with. For examples of this technique, check out what [Tore](https://gist.github.com/torgro/4b8aa80ad5b9b2da351b), [Oysind](https://gist.github.com/gravejester/6c9a1bdd12ba413590c9) and [Mathias](https://gist.github.com/IISResetMe/1cb193f9473906d03277) did.

### Can PowerShell beat Hadoop?

From the original post that started this whole thing, [Adam Drake's Can command line tools be faster than your Hadoop cluster](http://aadrake.com/command-line-tools-can-be-235x-faster-than-your-hadoop-cluster.html)?

> \[using Amazon Web Services hosting...\] with 7 x c1.medium machine\[s\] in the cluster took 26 minutes...processing data at ~ 1.14MB/sec

All of these entrants can proudly say that their code DID beat the Hadoop cluster.  Boe Prox , Craig Duff, Martin Pugh, /u/evetsleep /u/Vortex100 and kevin Marquette, Irwin Strachan, Flynn Bundy, David Kuehn, and /u/LogicalDiagram from Reddit, and @IisResetme!  All eleven averaged a minimum of 10.76 MB/sec.  Their code all completed in less than six minutes, much faster than the 26 minutes of the mighty seven node Hadoop cluster!

## But can PowerShell beat Linux?

When I saw that Adam Drake, a master of the Linux command line and Bash tools, was able to process all of the results in only 11 seconds, I knew this was a tall order.  We gave it our all guys, there's no shame in...BEATING that time!

gAmazingly, our two Speed Demons,  Tore Groneng, and Øvind Kallstad, working in conjunction with Mathias Jensen, turned in a blazing fast time of eight seconds, each!  To be specific, Øvind's time was 8,778 MS, while Tore beat that by an additional 200 MS.   This represents a data throughput of 411.75 MB/s!  This is close to the maximum speed of my all SSD Raid-0, so they REALLY turned in quite a result!

360 times faster than the Hadoop cluster. Astounding!

### Winners!

I'm now pleased to announce the winners of the Hadoop contest.  I was so impressed with the entries that I decided to pick a bonus fourth winner.

_Speed King Winner_ - This one goes to [Tore Groneng](https://twitter.com/ToreGroneng).  He worked closely with Mathias Jensen, and turned out an incredible 8 second total execution.  For comparison, this is a **200x speed increase over the results of the Hadoop Cluster** from our original challenge.  He should be proud.

A close runner-up was [Øvind Kallstad](https://twitter.com/okallstad), with a very honorable time of 8778 MS.

_Most Best Practice Award_ - This one goes to Boe Prox, with a textbook perfect entry, including object creation, runspaces, and just plain pretty code.

Regex God - This award goes to [Craig Duff,](https://twitter.com/powershellish) who blew my socks off with his impressive Regex skills!

One-liner Champion - This award was well earned by [Flynn Bundy](https://twitter.com/bundyfx), who managed to turn out a very respectable time of two minutes, and did it all in a one-liner!  His code ALMOST fits in a single, tweet, in fact!  Only 216 characters!

If your name is mentioned here, send me a DM and we'll work out getting you your hard-earned stickers :)

| Name | Link | Time(ms) | Hours:Min:Sec | Winner |
| --- | --- | --- | --- | --- |
| Tore Groneng | https://gist.github.com/torgro/4b8aa80ad5b9b2da351b#file-get-chessscore-ps1 | 8525 | 00:00:08.7673.32 | Speed King! |
| Boe Prox | https://gist.github.com/proxb/eba9b262e1dcb593ec94 | 28274 | 00:00:28.25447.28 | Most Best Practice Award |
| Craig Duff | https://gist.github.com/duffwv/eaf16d733fdb00e4d6e8#file-beatinghadoop-ps1 | 39813 | 00:00:39.35832.08 | Regex God Award |
| Flynn Bundy | https://gist.github.com/bundyfx/1ef0455eb9bcbcc2d627 | 119774 | 00:01:59.107797.31 | One-liner Champion |

Thank you to everyone who entered. [ The leaderboards have been updates with your times](https://github.com/1RedOne/BlogPosts/blob/master/PoshHadoop-Leaderboards.csv), and I'll add your throughput when I get the chance this week!
