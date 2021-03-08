---
title: "Question Time: when I want a property, PowerShell gives the whole object!"
date: "2014-11-13"
redirect_from : /2014/11/13/question-time-when-i-want-a-property-powershell-gives-the-whole-object
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
tags: 
  - "powershell"
---

I'm posting today on a topic I see over and over again in the forums, on reddit, and have run into myself numerous times. Every person I've ever taught PowerShell runs into it too, and most authors have covered this at some point, including Don Jones in ['The big book of PowerShell Gotchas'](https://onedrive.live.com/?cid=7F868AA697B937FE&id=7F868AA697B937FE%21112).

It always happens, and can take a while to troubleshoot.  The problem boils down to this:

> In my Script, for some reason when I call $object.Property within double quotes, PowerShell dumps the whole object with all of its properties! How do I get just one value?

And inevitably this leads to ugly, ugly string concatenation like this:

```powershell  
Write-host ("Operation completed on: " + $object.Property + " at " (Get-Date))
```

It's ugly and a bad way to do things. You can end up with strange errors too, when objects of a different type are shoved into one another.

So, even though everyone has had a crack at answering this one, I took my own shot at it.  I'll show you how you should do this, by merit of explaining it to someone else.

### "What's going on here?"

> I've been scripting for years in both BASH and Batch but I'm new to Powershell and object-oriented languages. I want to make sure I understand this before moving on with my script. This is the input csv file: FirstName,LastName,ID,Dept,Flag First,Last,5403,Accounting This works:
> 

```powershell  
$inputfile = Import-Csv "\\\\san\\inputfile.csv" ForEach ($user in $inputfile) { If (Get-ADUser -Filter "mobile -eq $($user.ID)") {Echo $user.ID} }

```

> This doesn't work:
> 

```powershell   
$inputfile = Import-Csv "\\\\san\\inputfile.csv" ForEach ($user in $inputfile) { If (Get-ADUser -Filter {mobile -eq $user.ID}) {Echo $user.ID} } 
```
> 
> What is it about the syntax in the first one that makes it work? From <[http://www.reddit.com/r/PowerShell/comments/2lzxgm/new\_to\_powershell\_why\_does\_this\_work\_and\_this\_not/](http://www.reddit.com/r/PowerShell/comments/2lzxgm/new_to_powershell_why_does_this_work_and_this_not/)\>

* * *

 

### The Reason Why you're getting too much; PowerShell just wants to help

Here's the reason why you're getting that output. It all has to do with the String! When you put a variable in quotes and in paranthesis, PowerShell will pull out only that single property when evaluating the string. In your first example, you can see this in action, this is what PowerShell is really doing, I'm only going to include the bit on line 3.

```powershell   
ForEach ($user in $inputfile){Write-Host "(Get-ADUser -Filter mobile -eq $($user.ID))"}
```

(Get-ADUser -Filter mobile -eq 5403)

So, Powershell reads through the line, sees the $variable marker in front of paranthesis, then treats the contents of it as a string. Here, it pulls out only the ID property in that case, because it respects the order of operations. Now compare this to your Example 2, and look at what is happening

```powershell   
ForEach ($user in $inputfile){Write-Host"Get-ADUser -Filter {mobile -eq $user.ID}" }


Get-ADUser -Filter {mobile -eq @{FirstName=First; LastName=Last; ID=5403; Dept=Accounting; Flag=}.ID}
```
 

See that? PowerShell is reading the characters after the -Filter, and gets to $user and then just dropping in the value for the $user, which includes all of these properties. At the end of the contents of User, it then lamely appends '.ID' to the end.

Nice try, PowerShell, you did your best.

So, the real problem here is that if you want to pull out a single property of an object within full quotes, you need to use $($variable.Property) syntax.

* * *

 

Oh, and in case you're wondering how I did the PowerShell console output in my post? I used an HTML block and figured out using mspaint that the hex color for the PowerShell window is RGB #013686.

```xml
<div style="padding: 12px; background-color: #013686; line-height: 1.4;"> <span style="color: #ffffff;"> #YourConsoleOutput here </span> </div>
```

Results in

#YourConsoleOutputHere
