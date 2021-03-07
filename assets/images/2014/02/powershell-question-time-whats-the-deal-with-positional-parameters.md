---
title: "PowerShell Question Time: Whats the deal with Positional Parameters?"
date: "2014-02-19"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

Hi guys,

Recently a colleague reached out to me with a question about PowerShell that I thought might benefit others.  I thought I'd share it with you here.

> Hi Stephen,
> 
> Get-ChildItem -filter \*.exe -Recure  -path c:\\windows Get-ChildItem -path c:\\windows -filter \*.exe -recurse
> 
> \-Path <String\[\]> Specifies a path to one or more locations. Wildcards are permitted. The default location is the current directory (.).
> 
> ```
> Required?                    false
> Position?                    1
> Default value                Current directory
> Accept pipeline input?       true (ByValue, ByPropertyName)
> Accept wildcard characters?  true
> ```
> 
> I'm confused in the two commands displayed at the top which both return the same value, how do they both work. If -path requires position 1 and in the first command its all the way at the end how can it be acceptable, or am I not seeing the information correctly. Perhaps this reads
> 
> Hopefully that made sense and hopefully I am assuming correctly.
> 
> Thanks.

Good question!  Well, first and foremost let me begin by saying that you should never use positional parameters, so just forget about them and move on! No, you're still here?  You clicked past the 'More' button?  Okay, fine I'll give a better explanation.

Simply put positional parameters only matter when you leave out the parameter name.

The reason you're getting the same result, is that you're explicitly specifying the parameter when you name it with its full or abbreviated name.   An argument is simply only assigned to a particular parameter by its position if you omit the parameter name.

That's why you can run :

```
Get-ChildItem C:\windows *.exe  
```

but you can't run

```
Get-ChildItem *.exe c:\windows.  
```

As the Positional parameter for position one for the command Get-ChildItem is 'Path', while Positional Parameter two is reserved for filtering operations.

So, don't get caught up on positional parameters, using them is EXPRESSLY a bad PowerShell practice for code simplicity and readability sake. You can always put all of your parameters in whichever order you want, and you should always write out your parameter names in entirety, which means that Positional Parameters aren't helpful whatsoever.
