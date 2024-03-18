---
title: "PowerShell Easy Caching"
date: "2021-03-01"
layout: post
redirect_from : 2021/03/01/powershell-easy-caching
coverImage: ..\assets\images\2021\Caching-For-Speed.webp   
categories: 
  - "scripting"
tags: 
  - "caching"
  - "powershell"  
excerpt: "The other day I answered a question on StackOverflow about how to cache the results of slow running operations easily in PowerShell.  I thought it had the makings of a good blog post so here we go!"
---

## PowerShell Easy Caching


![](..\assets\images\2021\Caching-For-Speed.webp)

The other day I [answered a question on StackOverflow](https://stackoverflow.com/questions/65959734/i-want-to-implement-a-cache-storage-on-my-powershell-for-quicker-runtime-on-next/65960196#65960196) about how to cache the results of slow running operations easily in PowerShell.  

In answering it, I was reminded that this problem occurs all the time in automation, like when you:

* need to work with a big dataset
* have a very slow external dependency
* your queries impact the environment
* have a rapid automation task which can still function with semi-stale data

As always, we will approach this with Progressive Automation, step-by-step adding complexity and features till we get something we're really proud about.  So first we'll look at Caching calls just for this instance of PowerShell.   Then we'll build in complexity and add a more persistent cache.

One new thing: I'm going to try to start sprinkling in some more deliberate career / workplace advice throughout my posts, hope you like it.  If you hate it, feel free to contact me for a refund. 

*Outline*

* Question Background
* Identify key places to add caching
* Add a soft-cache (memory caching)
* Generalize to be used anywhere
* A Great Use for PowerShell Classes is found! 
* Upgrade to disk backed cache 

## Question Background

[For the question on Stack](https://stackoverflow.com/questions/65959734/i-want-to-implement-a-cache-storage-on-my-powershell-for-quicker-runtime-on-next/65960196#65960196), the user wanted to cache a call to Get-ADGroup for some automation at her workplace.  Also, it was good enough to cache the membership when PowerShell opened up.  So we started with looking at her code.

She already had a function called `Get-AdUsers`, which wrapped around the normal `Get-AdGroup` and `Get-AdUser` cmdlets, I'll post a snippet here.   The gist of this function was to retrieve all nested group members from a parent group. 

```powershell
function Get-ADUsers { 
    param ( 
        [Parameter(ValuefromPipeline = $true, mandatory = $true)][String] $GroupName
    ) 
    [int]$circular = $null

    # result holder
    $resultHolder = @()
        $table = $null 
        $nestedmembers = $null 
        $adgroupname = $null     

        # get members of the group and member of
        $ADGroupname = get-adgroup $groupname -properties memberof, members

        # list all members as list (no headers) and save to var
        $memberof = $adgroupname | select -expand memberof 
       
        if ($adgroupname) {  
            if ($circular) { 
                $nestedMembers = Get-ADGroupMember -Identity $GroupName -recursive 
                $circular = $null 
            } 
            else { 
                $nestedMembers = Get-ADGroupMember -Identity $GroupName | sort objectclass -Descending
            }
        }
        #...code continued...
```

She was looking for some place to cache hits to LDAP.  Two lines jumped out at me.

```powershell
13: $ADGroupname = get-adgroup $groupname -properties memberof, members
20: $nestedMembers = Get-ADGroupMember -Identity $GroupName -recursive 
```

The top line is good to cache if we want this cmdlet to be fast when someone looks at multiple groups in a session.
The bottom line is good to cache when we want fast results when the parent group often contains the same nested groups.  

## Business Moment: Coding for Impact

You might wonder at this point

> why bother analyzing the problem, I wanna code!

This sort of analysis is good to perform before you just start coding. Ideally, our work should be done as part of a team, identifying pain-points and spending our efforts meaningfully.  

You want at the end of the week, month and year to have a list of your achievements, and speeding up or improving the performance of something critical and meaningful will help you give your boss the ammo she needs to argue for a higher raise or promotion for you.

BusinessImpact image

TL/DR: Don't waste engineering hours automating something painless or that no one cares about.  Your efforts should be apparent and yell from the roof top "Yo, this Engineer is AWESOME, give him a raise!"

### InMemory : Good Enough Caching 

We will begin by caching the nested hits, line 20.  Most organizations go BONKERS nesting groups inside groups inside groups, so if we can mitigate some of those greedy LDAP hits to use our speedy, snappy cache will have an immediate speed boost.

```powershell
20:  $nestedMembers = Get-ADGroupMember -Identity $GroupName -recursive 
```

We'll do this by replacing this function call with another call.  We'll name this `Get-CachedADGroupMember`

```powershell
function Get-CachedADGroupMember($groupname){
   $groupName = "cached_member_$($groupName)"
   $cachedResults = Get-Variable -Scope Global -Name $groupName -ErrorAction SilentlyContinue
   if($null -ne $cachedResults){
    "found cached result"
    return $cachedResults
   }
   else{
    "need to cache"
    $results = get-adgroup $groupname -properties memberof, members
    Set-CachedGroupMembership -groupName $groupName -value $results
   }
}
```

This is pretty straightforward.  The code builds the name of a variable and then checks the environment to see if it exists.  If it does, that variable is returned.  If not, then we execute the operation and hand off the results to another cmdlet just to store the results.  The storage command is very simple.  (Hint: it will become less simple once we add storage to disk!)

```powershell
Function Set-CachedGroupMembership($groupName,$value){
    Set-Variable -Scope Global -Name $groupName -Value $value
    return $value
}
```

Already, this will become noticably faster because of all the cache hits. However, what if our cache becomes stale and we need to update it?  

We can provide this feature by just passing a $boolean value of -Update in, by adding this to our cmds params.

```powershell
function Get-CachedADGroupMember([string]$groupname, [switch]$update){
   #...
   if(($update) -and ($null -ne $cachedResults)){

```

Then, to force an update of the Cache, we simply append `-Update` to our function.

Easy peasey!  

## Work.Select(x=>x.Specialize.Generalize()) 

Time to modify this function and remove the inherent AD Based focus, and turn it into a modular tool that could work to cache *anything*.

Some small edits is all we need!

```powershell
function Get-CachedOperation([String]$Name, [ScriptBlock]$command, [Switch]$Force){
   $CommandName = "cached_$($Name)"
   $cachedResults = Get-Variable -Scope Global -Name $CommandName -ErrorAction SilentlyContinue
   if($force -or $null -eq $cachedResults ){
    "need to cache, evaluating..."
    $results = $command.Invoke()
    
    New-Variable -Scope Global -Name $CommandName -value $results -Force
   }
   else{
    
    "found cached result"
    return $cachedResults
   }
}
```

To actually use it, we use the following

```powershell
>Get-CachedOperation -Name SlowCommand -command ([ScriptBlock]::Create({start-sleep 2;return 5}) ) | tee-object -var result

>$result.Value
5
```

One downside to our code as written is that there is no logic to rerun if the results get too stale

## Always Fresh PowerShell

To add time awareness, the quickest way is to make a custom type that has the command name, scriptblock, results and an automatic timestamp.  This is actually a perfect use case for PowerShell classes, which past me from like four years ago completely couldn't understand.  Aww, see how cute I was?

Link to my old post 

So, here's the class.  We could make a new one if we wanted by running the bottom line.  


```powershell
class CachedOperation
{
   # Automatic TimeStamp
   [DateTime] $TimeStamp;

   # Command Nickname
   [string] $Name;

   # Command Instructions
   [ScriptBlock] $Command;

   # Output, whatever it is
   [psCustomObject] $Value;

   #Constructor
   CachedOperation ([string] $name, [ScriptBlock]$scriptblock)
   {
       $this.TimeStamp = [DateTime]::UtcNow
       $this.Name = $name;
       $this.Command = $scriptblock
       $this.Value= $scriptblock.Invoke()
   }

}
```


Now to modify the function to work with this class.

```powershell
function Get-CachedOperation([String]$Name, [ScriptBlock]$Command, [Switch]$Force){
   $CommandName = "cached_$($Name)"
   $cachedResults = Get-Variable -Scope Global -Name $CommandName -ErrorAction SilentlyContinue | Select -ExpandProperty Value
   if($force -or $null -eq $cachedResults ){
        Write-Verbose "need to cache, evaluating..."
        $CachedOperation = [CachedOperation]::new($Name, $command) 
        New-Variable -Scope Global -Name $CommandName -value $CachedOperation -Force
        $cachedResults = $CachedOperation
   }
   else{ 
        Write-Verbose "found cached result"
   }
   return $cachedResults.Value
}
```
And in action:

```

Get-CachedOperation -Name MySlowCommand -command ([ScriptBlock]::Create({start-sleep 1;return 6}) ) 
VERBOSE: need to cache, evaluating...
6

PS C:\Users\Stephen> Get-CachedOperation -Name MySlowCommand -command ([ScriptBlock]::Create({start-sleep 1;return 6}) ) 
VERBOSE: found cached result
6
```
So in the last step, no value was created.  We were merely setting up the scaffolding for the next, actually cool step.  

Seems silly to have intermediate steps but in the real world, you'll probably be following a flow like this, creating the scaffolding and supporting functions and then submitting them with their unit tests.  Then once that passes muster, you introduce the small feature flag PR that flips things around and starts using that new code.

## Adding Staleness Check

To actually do something useful, let's add the time check to see how old the results are.

This is pretty easily done, when we retrieve a cached result, we'll check to see how old it is and if more than 30 minutes, we'll rerun the operation.  
```

function Get-CachedOperation([String]$Name, [ScriptBlock]$Command, [Switch]$Force){
   $CommandName = "cached_$($Name)"
   $cachedResults = Get-Variable -Scope Global -Name $CommandName -ErrorAction SilentlyContinue | Select -ExpandProperty Value
     
   if($force -or $null -eq $cachedResults -or ($cachedResults.TimeStamp -le [DateTime]::UtcNow.AddMinutes(-2))){
        if($cachedResults.TimeStamp -le [DateTime]::UtcNow.AddMinutes(-2)){
            Write-Verbose "Results are too old, reevaluating..." 
        }
        else{
            Write-Verbose "need to cache, evaluating..."
        }
        $CachedOperation = [CachedOperation]::new($Name, $command) 
        New-Variable -Scope Global -Name $CommandName -value $CachedOperation -Force
        $cachedResults = $CachedOperation
   }
   else{ 
        Write-Verbose "found cached result"
   }
   return $cachedResults.Value
}

```


## To Disk, and Beyond*

<Sad Buzz Lightyard>

*We will not actually be going beyond in this post

Like this post?  Great!  Join us next time where we'll persist the results to disk!