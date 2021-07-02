---
title: "Got messy Ifs? Guard Clauses to the Rescue!"
date: "2021-07-02"
redirect_from : 2021/07/02/got-messy-ifs-guard-clauses-to-the-rescue/
coverImage: \assets\images\2021\Guard-Clauses.png
categories: 
  - "scripting"
tags: 
  - "programming"
  - "PowerShell"
excerpt: "Revisiting PowerShell after mostly writing nothing but c# for years, I'm finding lots of useful programming practices can make my code easier to read.  In this post, we'll talk about guard clauses and how they can make your code easier to read!"
fileName: '2021-07-02-got-messy-ifs-guard-clauses-to-the-rescue'
---
Revisiting PowerShell after mostly writing nothing but c# for years, I'm finding lots of useful programming practices can make my code easier to read.  In this post, we'll talk about guard clauses and how they can make your code easier to read!

![Header for this post, reads 'Protecting your code with guard clauses'](\assets\images\2021\Guard-Clauses.png)

This is another one of those posts inspired by a Stack Overflow question (these things just write themselves!).  [Here's the post that inspired it.](https://stackoverflow.com/questions/68210680/powershell-multiple-parameters-conditions/68211807#68211807)

*Post Outline*

* What are guard clauses?

In programming, imagine you have some function like this which could presumably bail early if it's not going to be able to do the work you need done.  

```
public void SomeMethod<T>(string var1, IEnumerable<T> items, int count)
{
    if (string.IsNullOrEmpty(var1))
    {
        throw new ArgumentNullException("var1");
    }

    if (items == null)
    {
        throw new ArgumentNullException("items");
    }

    if (count < 1)
    {
        throw new ArgumentOutOfRangeException("count");
    }

    ... etc ....
}
```

There a lot of reasons we could bail, and the code looks pretty messy because of it. 

We can introduce a guard clause here, and the technique works in PowerShell or C#, to contain all the messy "stuff that makes my function die" logic.  

We can also use them to make our `ifs` easier to read too!

# Stuff that makes you go die

Some places write `Ensure` methods to handle bailing on certain conditions, like this.

```
   public static class Ensure{
	   public static void IsNotNull(object val, string arg)
	   {
		   if (value == null)
            throw new ArgumentNullException(argument);
	   }
   }
```

You'd then modify the code to consume it like so:

```
public void SomeMethod<T>(string var1, IEnumerable<T> items, int count)
{
    Ensure.IsNotNull(var1);
	Ensure.IsNotNull(items);
```

You can even go farther and just stuff all of your 'sadpath' logic into one guard.

```
public static class Ensure{
	   public static void CanProcess(object val, string arg)
	   {
		   	if (val == null)
            	throw new ArgumentNullException(argument);

			if (val.GetType().IsArray && val.Count < 1 )
				throw new ArgumentOutOfRangeException("count");
	   }
   }
```

Then you just bail out early and easily, shortening your code.

```
public void SomeMethod<T>(string var1, IEnumerable<T> items, int count)
{
    new [] {var1, items, count}.ForEach(x=>Ensure.CanProcess(x));
	... etc ....
}
```

>But Stephen, can't we just use parameter validation for these?

Sure, you can and should use parameter validation to ensure your function can work, but there are loads of common scenarios when you will have special handling for special combinations, and guard clauses are an awesome tool for simplifying that logic.

Which brings us to...


# Simplifying my Ifs

![The 'protector meme' with complex if statements being blocked and a nice 'ShouldProcess()' guard clause coming out](\assets\images\2021\guardCluase_srGrfo.png)

In PowerShell specifically, we already have parameter validation, so most people can and should use that to clean up and help our function not have to worry about the sad paths out there.  

For PowerShell, I love the use case of using these little guard functions to instead return `true` or `false` and then we just plop them directly into an `if` statement.

These are great because...

# Guard clauses help us to express ourselves through code

Imagine a function like this, which wraps a call to `Write-Host` (thank you to [@IISResetMe](https://twitter.com/IISResetMe) for the sample).

```powershell
#updating Mathias to add calling the guard clauses
function Write-CustomHost {
  param(
    [Parameter(Mandatory = $true)]
    $Object,

    [Parameter(Mandatory = $false)]
    [ValidateSet('Red','Green')]
    [string]$ForegroundColor
  )

  Write-Host @PSBoundParameters  
}
```

Now, imagine we needed some special handling when we got in a Process object, or, for simplicities sake, an `[int]` object.

We *could* write this kind of an if clause.

```powershell
if (($object -is [int]) && $foreGroundColor -eq 'red'))
```

Which maybe isn't too hard to read.  But what about when we need even more complex behavior, like handling combinations of params coming in?  

Cases like these, where our `ifLogic` goes into a simple function to give a `[bool]` response save the day.

```powershell
#guardClause setup

function isRed {
    param([string]$ForegroundColor)
    $ForegroundColor -eq 'Red'
}

function isInt {
    param($object)
    $object -is [int]
}

```
We don't need much logic at all, just a simple PowerShell comparison statement.  Now, we go back to our custom host and....

```
#updating Mathias to add calling the guard clauses
function Write-CustomHost {
  param(
    #...
  )
  
  if (isRed $ForegroundColor -and isInt $Object){
    return "this is a red Int, so lets do special handling here"
  }
  
  Write-Host @PSBoundParameters
}

Write-CustomHost -Object 1 -ForegroundColor Red
```

![The 'protector meme' with complex if statements being blocked and a nice 'ShouldProcess()' guard clause coming out](\assets\images\2021\guardCluase_example.png)

## Do I really NEED to write tests for these?

**Yes of course you do**.  If code is worth writing, it's worth testing.  These are especially easy to test, but proper testing should include a test for both possible conditions for each clause.  

At a minimum, there should be:

```powershell
Describe GuardCluases{
    It "IsInt should return true when an int" {
		IsInt 4 | should -be $true
	}
    
    It "IsInt should return false when not an int" {
		IsInt "ok" | should -Be $false
	}
}
```

