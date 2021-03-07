---
title: "Download all the PowerShell summit videos...with PowerShell"
date: "2014-10-16"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

This is just a rehash of a previous post of using YoutubeDL to parse playlists and download stuff, but here is doing it to download the European PowerShell Summit Videos.

\[code language="powershell"\] $url = "https://www.youtube.com/playlist?list=PLfeA8kIs7Coehjg9cB6foPjBojLHYQGb\_"

$playlisturl = $url

$VideoUrls= (invoke-WebRequest -uri $Playlisturl).Links | ? {$\_.HREF -like "/watch\*"} | \` ? innerText -notmatch ".\[0-9\]:\[0-9\]." | ? {$\_.innerText.Length -gt 3} | Select innerText, \` @{Name="URL";Expression={'http://www.youtube.com' + $\_.href}} | ? innerText -notlike "\*Play all\*" | ? innerText -notlike "\*Play\*"

ForEach ($video in $VideoUrls){ Write-Host ("Downloading " + $video.innerText) .\\youtube-dl.exe $video.URL } \[/code\]
