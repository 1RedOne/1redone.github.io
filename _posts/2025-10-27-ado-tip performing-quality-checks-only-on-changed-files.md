---
title: "PostTitle"
date: "2025-10-27"
redirect_from : 2025/10/27/ADO-Tip---Performing-quality-checks-only-on-changed-files!
coverImage: \assets\images\2021\trackingStates.webp
categories: 
  - "scripting"
tags: 

 - "Azure DevOps" 
 - "Pipelines" 
 - "CI/CD" 
 - "Quality Checks"
excerpt: "In this post, we'll look at a way to optimize your Azure DevOps pipelines by only performing quality checks on files that have changed in a pull request."
fileName: '2025-10-27-ado-tip---performing-quality-checks-only-on-changed-files!'
---
If you've noticed the trajectory of my posts, you'll note that I've moved on to now automating things in the cloud, and shifted my focus a bit to the land of CI/CD.  

Recently, this issue popped up : 

## How do I make sure people change their content...in the right way

![Header for this post, reads 'How To Make GitHub Button'](\assets\images\2021\trackingStates.webp)

*Post Outline*

I'm working on a project now in which UX is created on the fly directly from some JSON content that partner teams provide to us.  It's very cool and fun work.

However...after some time has gone by I began to realize somethings...

1. We create UX on the fly from partner inputs
2. It requires a PR to update this content
3. I am not the only one allowed to approve PRs

What then would happen if someone alters a json content file after its been in use in testing for months and the new file breaks things?  I'll tell you what doesn't happen, people don't go to the author of the file and ask them why they made a change, no, they instead line up to ask me questions.  Me, the bozo who developed this platform and didn't think to check for things like that!  

## The problem

It's very simple to run a test against *all* of the code in a repo at check in.  We do this in the Azure world by creating a new pipeline that runs on a hosted pool and we set the input source to be the repo in question with the trigger type being `pr`, then at the end of the day, run a PowerShell script to perform your tests (I prefer to do this in Pester).

But I don't need to just test their *current version* of the file.  I need instead to compare the file to its previous state in `master`, otherwise I won't be aware of just how much its changed.  

I mean, I could know if I looked at the PR, but there are times when it's not possible to review every PR.  

## The Setup

We want to:

* Get a list of potential files to check `($allJsonFiles)`
* Retrieve a list of files changed in this PR `($allChangedFiles)`
* See if any of `$allJsonFiles` are in `$allChangedFiles`, and if so capture them as `$myChangedJsonFiles`
* Handle either 0 changed files or many files
* Do some quality checks
* Handling when I need a human set of eyes
* Call it a day and go get lunch. 

It was very easy to get the list of files I cared about, the interesting thing was seeing what changed in this PR:

```powershell
 $changedFiles = git diff --name-only master    
```

This will give you a list, in linux file format, of all files that changed in your commits/pr versus master.  

This actually failed aggresively, as it turns out that ADO pipelines will by default only include the dev branch and won't mirror master as well.  I added this to fix that particular issue.

```
 git fetch origin master
$changedFiles = git diff --name-only master    
```


From here, it was simple enough to compare `$allJsonFiles` against the list back from `$allChangedFiles` and filter things down.  I then ended the `BeforeDiscovery` block of my test by publishing `$myChangedJsonFiles`.  

Next up, it's very easy to hand a list of resources off to a `Describe` block and iterate over them, using this syntax:

```powershell
Describe "Catalog JSON File - <_.FullName>" -ForEach $jsonFiles {
    BeforeAll {
      #load the json file, convert from json, etc
```
## How to get a human to pay attention

I decided that certain values in a partner file need to be immutable after their first check in.  We could handle changes to them on a case by case basis, but enshrining this with checks would keep everyone safe.

I found that if I skip a test in ADO, this triggers a warning exit status, which helps to draw human eyes to reviewing the problem.  Here's how I did it.

```powershell
    if ($difference -ge 1) 
            {
                Write-Warning "WARNING - Detected $difference in status between this file and master.  Does this make sense?"
                Set-ItResult -Skipped -Because "Human Review Required - Significant change in 'ShouldNeverBeChanged' settings detected, with a count of $difference."
                return
            }

```

It was that easy!

Time for lunch.