---
title: "Use PowerShell to take automated screencaps"
date: "2017-09-10"
redirect_from : /2017/09/10/use-powershell-to-take-automated-screencaps
coverImage: ../assets/images/2017/09/images/unattendedsnapshot_loop.gif
categories: 
  - "scripting"
excerpt: "I saw a post on Reddit a few days ago, in which a poster took regular screenshots of weather radar and used that to make a gif tracking the spread of Hurricane Irma.  I thought it was neat, and then read a comment asking how this was done.

IT-WAS-MANUAL!"
---

![](../assets/images/2017/09/images/unattendedsnapshot_loop.gif)

I saw [a post on Reddit a few days ago](https://www.reddit.com/r/TropicalWeather/comments/6yyx7i/i_created_an_animation_of_irma_since_it_was_a/), in which a poster took regular screenshots of weather radar and used that to make a gif tracking the spread of Hurricane Irma.  I thought it was neat, and then read a comment asking how this was done.

> How did you do this? Did you somehow automate the saves? Surely you didn't stay up all night?

_[/u/Sevargmas](https://www.reddit.com/user/sevargmas) - [Comment Link](https://www.reddit.com/r/TropicalWeather/comments/6yyx7i/i_created_an_animation_of_irma_since_it_was_a/dmrh0y3/)_

It brought to mind the time I used PowerShell four years ago to find the optimal route to work.

### Solving my lifelong issues with being on-time

You ever notice how if you leave at 6:45, you'll get to work twenty minutes early. But if you leave at 6:55, more often than not you'll be late? Me too, and I hated missing out on sleep!  I had a conversation with my boss and was suddenly very motivated to begin arriving on time.

I knew if I could just launch Google Maps and see the traffic, I could time it to see the best to time to leave for work.  But if I got on the PC in the morning, I'd end up posting cat gifs and be late for work.

Of course, Google Maps now provides a built in option to allow you to set your `Arrive By` time, which removes the need for a tool like this, but at the time, this script was the bees-knees, and helped me find the ideal time to go to work.  It saved my literal bacon.

There are many interesting uses for such a tool, like tracking the progress of a poll, tracking satellite or other imagery, or to see how a page changes over time, in lieu of or building on the approach we covered previously in [Extracting and monitoring for changes on websites using PowerShell](http://foxdeploy.com/2017/03/30/extracting-and-monitoring-web-content-with-powershell/), when we learned how to scrape a web page.

### How this works

First, copy the code over and save it as a .PS1 file.  Next, edit the first few lines

```powershell
 $ie = New-Object -ComObject InternetExplorer.Application 
 $shell = New-object -comObject Shell.Application 
 $url = "http://goo.gl/1bFh5W" 
 $sleepInt   = 5 
 $count      = 20 
 $outFolder  = 'C:\temp' 
```

Provide the following values:

```
$url      = the page you want to load 
$sleepInt = how many seconds you want to pause 
$count    = how many times you'd like to run $outFolder= which directory to save the files 
```

From this point, the tool is fully automated. We leverage the awesome `Get-ScreenShot` function created by Joe Glessner of http://joeit.wordpress.com/.  Once we load the function, we simply use the `$shell` .Net instance we created earlier to minimze all apps, then display Internet Explorer using the `$ie` ComObject.  We navigate to the page, wait until it's finished loading, and then take a screenshot.

Then we un-minimize all apps and we're set.  Simple, and it works!

Hope you enjoy it!

```powershell
$ie         = New-Object -ComObject InternetExplorer.Application
$shell      = New-object -comObject Shell.Application
$url        = "http://goo.gl/1bFh5W"
$sleepInt   = 45
$count      = 20
$outFolder  = 'C:\temp\WhenToGoToWork'
 
#region Get-Screenshot Function
   ##--------------------------------------------------------------------------
    ##  FUNCTION.......:  Get-Screenshot
    ##  PURPOSE........:  Takes a screenshot and saves it to a file.
    ##  REQUIREMENTS...:  PowerShell 2.0
    ##  NOTES..........:
    ##--------------------------------------------------------------------------
    Function Get-Screenshot {
        <#
        .SYNOPSIS
         Takes a screenshot and writes it to a file.
        .DESCRIPTION
         The Get-Screenshot Function uses the System.Drawing .NET assembly to
         take a screenshot, and then writes it to a file.
        .PARAMETER <Path>
         The path where the file will be stored. If a trailing backslash is used
         the operation will fail. See the examples for syntax.
        .PARAMETER <png>
         This optional switch will save the resulting screenshot as a PNG file.
         This is the default setting.
        .PARAMETER <jpeg>
         This optional switch will save the resulting screenshot as a JPEG file.
        .PARAMETER <bmp>
         This optional switch will save the resulting screenshot as a BMP file.
        .PARAMETER <gif>
         This optional switch will save the resulting screenshot as a GIF file.
         session.
        .EXAMPLE
         C:\PS>Get-Screenshot c:\screenshots
 
         This example will create a PNG screenshot in the directory
         "C:\screenshots".
 
        .EXAMPLE
         C:\PS>Get-Screenshot c:\screenshot -jpeg
 
         This example will create a JPEG screenshot in the directory
         "C:\screenshots".
 
        .EXAMPLE
         C:\PS>Get-Screenshot c:\screenshot -verbose
 
         This example will create a PNG screenshot in the directory
         "C:\screenshots". This usage will also write verbose output to the
         comsole (inlucding the full filepath and name of the resulting file).
 
        .NOTES
         NAME......:  Get-Screenshot
         AUTHOR....:  Joe Glessner
         LAST EDIT.:  12MAY11
         CREATED...:  11APR11
        .LINK
         http://joeit.wordpress.com/
        #>
        [CmdletBinding()]
            Param (
                    [Parameter(Mandatory=$True,
                        Position=0,
                        ValueFromPipeline=$false,
                        ValueFromPipelineByPropertyName=$false)]
                    [String]$Path,
                    [Switch]$jpeg,
                    [Switch]$bmp,
                    [Switch]$gif
                )#End Param
        $asm0 = [System.Reflection.Assembly]::LoadWithPartialName(`
            "System.Drawing")
        Write-Verbose "Assembly loaded: $asm0"
        $asm1 = [System.Reflection.Assembly]::LoadWithPartialName(`
            "System.Windows.Forms")
        Write-Verbose "Assembly Loaded: $asm1"
        $screen = [System.Windows.Forms.Screen]::PrimaryScreen.Bounds
        $Bitmap = new-object System.Drawing.Bitmap $screen.width,$screen.height
        $Size = New-object System.Drawing.Size $screen.width,$screen.height
        $FromImage = [System.Drawing.Graphics]::FromImage($Bitmap)
        $FromImage.copyfromscreen(0,0,0,0, $Size,
            ([System.Drawing.CopyPixelOperation]::SourceCopy))
        $Timestamp = get-date -uformat "%Y_%m_%d_@_%H%M_%S"
        If ([IO.Directory]::Exists($Path)) {
            Write-Verbose "Directory $Path already exists."
        }#END: If ([IO.Directory]::Exists($Path))
        Else {
            [IO.Directory]::CreateDirectory($Path) | Out-Null
            Write-Verbose "Folder $Path does not exist, creating..."
        }#END: Else
        If ($jpeg) {
            $FileName = "\$($Timestamp)_screenshot.jpeg"
            $Target = $Path + $FileName
            $Bitmap.Save("$Target",
                ([system.drawing.imaging.imageformat]::Jpeg));
        }#END: If ($jpeg)
        ElseIf ($bmp) {
            $FileName = "\$($Timestamp)_screenshot.bmp"
            $Target = $Path + $FileName
            $Bitmap.Save("$Target",
                ([system.drawing.imaging.imageformat]::Bmp));
        }#END: If ($bmp)
        ElseIf ($gif) {
            $FileName = "\$($Timestamp)_screenshot.gif"
            $Target = $Path + $FileName
            $Bitmap.Save("$Target",
                ([system.drawing.imaging.imageformat]::Gif));
        }
        Else {
            $FileName = "\$($Timestamp)_screenshot.png"
            $Target = $Path + $FileName
            $Bitmap.Save("$Target",
                ([system.drawing.imaging.imageformat]::Png));
        }#END: Else
        Write-Verbose "File saved to: $target"
    }#END: Function Get-Screenshot
#endregion 
 
for ($i=0;$i -le $count;$i++){
 
    $ie.Navigate($url)
    $shell.MinimizeAll()
    $ie.Visible = $true
    start-sleep 15
    Get-Screenshot $outFolder -Verbose
 
    "Screenshot Saved, sleeping for $sleepInt seconds"
    start-sleep $sleepInt
 
    $shell.UndoMinimizeALL()
    }
```

When this runs, you'll have a moment or two to rearrange the screen before the first screen capture is taken. While executing, should leave the computer unattended, as we're simply automating taking a screencap. If you're using the computer, it will attempt to minimize your windows, display IE, SNAP, then restore your programs. If you have other windows up, they could be mistakenly included in the screen shot.

Afterwards, you will find the files in whichever path you specified for `$outFolder`.

Pro-tip, you can exit this at any point by hitting `CONTROL+C`.

Photo credit: [Nirzar Pangarkar](https://unsplash.com/@nirzar?utm_medium=referral&utm_campaign=photographer-credit&utm_content=creditBadge "Download free do whatever you want high-resolution photos from Nirzar Pangarkar")
