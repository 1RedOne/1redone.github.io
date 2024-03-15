$base = @"
---
title: "PostTitle"
date: "calculatedPostDate"
redirect_from : calculatedRedirect
coverImage: \assets\images\2021\trackingStates.webp
categories: 
  - "scripting"
tags: 
calculatedPostTags
excerpt: "calculatedPostExcerpt"
fileName: 'calculatedFileName'
---
calculatedPostExcerpt

![Header for this post, reads 'How To Make GitHub Button'](\assets\images\2021\trackingStates.webp)

*Post Outline*

* What were WordPress Stats?
* Finding a way to satisfy my ego
* Automatically adding it below posts in Jekyll
* How does this compare to Google Analytics?
"@

function New-BlogPost{
param($postTitle,$postDate, $postExcerpt,$postTags)
    $postContent = $base 
    $calculatedPostTitle= $postTitle -replace " ","-"
    $redirectformat = "$(get-date $postDate -UFormat %Y/%m/%d)/$($calculatedPostTitle)"
    $calculatedPostDate = $postDate
    $calculatedRedirect = "$redirectformat"
    $calculatedPostTags = $postTags |% {"`n - `"$_`""}
    $calculatedFileName = "$($postDate)-$($calculatedPostTitle.ToLower())"
    $calculatedPostExcerpt = $postExcerpt

    ForEach ($var in Get-Variable -Name calculated*){
        $postContent = $postContent -replace $var.Name, $var.Value
    }

    $postContent -replace "postTitle", $postTitle
    "would be created as $calculatedFileName.md"
}

$targetDate =  get-date ([DateTime]::Now.AddDays(-1)) -UFormat %Y-%m-%d

New-BlogPost -postDate $targetDate `
    -postTitle "Got messy Ifs Guard Clauses to the Rescue" `
    -postExcerpt "Revisiting PowerShell after mostly writing nothing but c# for years, I'm finding lots of useful programming practices can make my code easier to read.  In this post, we'll talk about guard clauses and how they can make your code easier to read!" `
    -postTags ham,onionions,cheese,foxes | clip