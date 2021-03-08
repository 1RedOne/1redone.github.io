---
title: "One Inch of Power: Bulk file relocation"
date: "2014-09-30"
redirect_from : /2014/09/30/one-inch-of-power-bulk-file-relocation
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
tags: 
  - "one-inch-of-power"
---

Hi guys,

Back for another installment of One inch of Power. In this episode, I became sick of seeing my music folder full of folders for albums, each of which may only have a single file or two.

I wrote this one incher to grab all folders with less than three files and move them all into a single folder, for ease of sorting.

```powershell
"$HOME\Music" | gci |
   ? PSIsContainer -eq $true | % {
       if ((gci $__.FullName -recurse).Count -le 3){
          gci $__ -recurse *.mp3 | move-item -Destination $HOME\\Music\\misc 
          }
      } 
```

Here's the overall flow.  
1. Get Items from $HOME\\Music 
2. Filter down to only ones where PSIsContainer equals True, which returns only folders 
3. If the number of items in the folder is less than or equal to three… 
4. …get a list of all files in the directory 
5. Move all of those items into $Home\\Music\\Misc

Pretty amazing what one line of PowerShell can do.
