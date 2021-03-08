---
title: "Using Try/Catch efficiently over a large list of commands"
date: "2014-07-16"
redirect_from : /2014/07/16/using-trycatch-efficiently-over-a-large-list-of-commands
coverImage: goes here...
categories: 
  - "scripting"
---

If you want to try catch over multiple commands, try this. We’re using the Invoke character to run a number of commands through a single try/catch block because frankly we can’t be bothered to type that much!

```powershell
#Invoke-Expression errors are considered non terminating, which means Try/Catch won't natively work.  You need to set 

# errorActionPreference = 'Stop' in order to force this behavior, to allow try/catch to do its job 
$ErrorActionPreference = 'Stop' 
$com =@" Get-ChildItem c:\\drivers, Get-ChildItem hklo:, Get-ChildItem c:\\temp "@

$com.Split(',') | ForEach-Object {

try { Invoke-Expression $\_ -ErrorAction Stop }

catch { "Something went wrong" }

} 
```

 

First off, we set $ErrorActionPreference = ‘Stop’, as Invoke-Expression errors are considered non-terminating for the interests of robust script execution. This means that if an error is encountered, it will be written out to screen and the show will attempt to go on, the script will continue running, etc. A terminating error, by comparison, will stop the show and display its output to the screen. In order to coerce PowerShell into exploring our Catch scripting block, we need to set the $ErrorActionPreference to Stop, so PowerShell will treat this seriously. If you want to see this principle in action, try running the above from the console with $ErrorActionPreference = “Continue”. You’ll notice that the error is displayed on screen and the Catch is never initiated! For this reason, we’re setting the value to ‘Stop’. Don’t worry though, if you run this in a script, the default ErrorActionPreference setting of Continue will be reinstated after the script runs. Speaking of which, be careful in the ISE, as variables set there tend to stick through your whole session.

So, $com contains all of our commands we want to run. We’re splitting the array at the comma to get a number of commands, then ForEach invoking the contents of the variable (ForEach stores the current object in a group of objects within the $\_ special variable). IF there is an error, we’re catching it. This is not ideal, as sometimes we want to only catch certain types of errors. You could create special catch commands for each type of error, as shown.

 

```powershell
$com.Split(',') | ForEach-Object {

try { Invoke-Expression $\_ -ErrorAction Stop }

catch \[System.Management.Automation.DriveNotFoundException\]{ "Double check that drive letter..." }

catch { "Something else went wrong" } } 
```

In this case, we specifically catch for errors of the type ‘System.Management.Automation.DriveNotFoundException’, and then redirect all other output to a generic catch block.

If you’d like more information about catching specific errors, check Ed’s post here : [http://blogs.technet.com/b/heyscriptingguy/archive/2010/03/11/hey-scripting-guy-march-11-2010.aspx](http://blogs.technet.com/b/heyscriptingguy/archive/2010/03/11/hey-scripting-guy-march-11-2010.aspx)
