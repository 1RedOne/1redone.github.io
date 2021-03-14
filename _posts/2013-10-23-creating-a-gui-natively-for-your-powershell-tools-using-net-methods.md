---
title: "Creating a GUI Natively for your PowerShell tools using System.Windows.Forms"
date: "2013-10-23"
redirect_from : /2013/10/30/continued-creating-a-gui-natively-for-your-powershell-tools-using-net-methods
coverImage: ../series/images/series_gui.png
categories: 
  - "scripting"
tags: 
  - "powershell"
excerpt: The first post in the FoxDeploy GUI Creating series, this post is focused on making a GUI using Windows Forms!
---
[![Learning PowerShell GUIs](../series/images/series_gui.webp)](/series/LearningGUIs)


**This post is part of the Learning GUI Toolmaking Series, here on FoxDeploy. Click the banner to return to the series jump page!**

* * *

**Update: this post was previously titled 'Creating a GUI Natively for you PowerShell Tools using .Net Methods', it has been renamed to make more sense.**

I know, scary title, Right!?  Trust me, it isn't so bad!

My standard methodology around the office is to find a common problem that I can solve using a repeatable method,  I then turn this into a tool I give to my help desk or clients and move on to the next interesting problem.

While you or I might be comfortable in a console or digging deep into systems settings and can turn a PC with an issue in practically no time, others on our team or that we support might want the process to be more approachable, and have more automation.  This also means, to an extent, that it should be made into a tool.

So, lets say in your environment you've located an issue (for the sake of this example, computers not responding to ping indicating some problem) and need a mechanism to test whether a machine is connected to the network using a Ping operation, we could do this with just an easy command line entry, but lets build a full graphical tool around this that anybody could use, in order to teach the procedure.

Alright, here we go: a simple ping testing tool.

```powershell
$ComputerName = read-host "Enter Computer Name to test:" if (Test-Connection $ComputerName -quiet -Count 2){ Write-Host -ForegroundColor Green "Computer $ComputerName has network connection" } Else{ Write-Host -ForegroundColor Red "Computer $ComputerName does not have network connection"}

```

And to test it:

![](../assets/images/2013/10/images/pingtool_01.png)

So we know our base code is working.  Now to create the outline of the GUI we want.

First and foremost, in order to have access to the Systems.Windows.Forms .NET elements we need to draw our GUI, we have to load the assemblies.  This is done with the following two lines, added to the top of our script.

```powershell
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") 
[void][System.Reflection.Assembly]::LoadWithPartialName("System.Drawing")
```

Void is a casting (converts whatever output came before it) that tells the method here to do the operation but be quiet about it.

Next, we will define the basic form onto which our application will be built, calling it $form, and then setting properties for its title (via the .Text property), size and position on screen.

```powershell
#begin to draw forms 
$Form = New-Object System.Windows.Forms.Form 
$Form.Text = "Computer Pinging Tool" 
$Form.Size = New-Object System.Drawing.Size(300,150) 
$Form.StartPosition = "CenterScreen"
```
One of the cool things you can do with the System.Windows.Forms object is to modify its KeyPreview property to True and then add listeners for certain key presses to have your form respond to them. Basically if you enable KeyPreview, your form itself will intecept a key press and can do things with it before the control that is selected gets the press. So instead of the user having to click the X button or click enter, yowe can tell the form to do something when the user hits Escape or Enter instead.

With that in mind, lets add a hook into both the Enter and Escape keys to make them function.

```powershell
$Form.KeyPreview = $True 
$Form.Add_KeyDown(
  {if ($\_.KeyCode -eq "Enter") {
      $x=$ListBox.SelectedItem;
      $Form.Close()}
  }) 
$Form.Add_KeyDown({if ($\_.KeyCode -eq "Escape") {$Form.Close()}})
```

And now, lets comment block out the Ping section of the script (we'll also use `#region` and `#endregion` to allow us to collapse away that block for the time being) and add the following lines to the bottom to display our form.
```powershell
#Show form 
$Form.Topmost = $True 
$Form.Add_Shown({$Form.Activate()}) 
[void]$Form.ShowDialog()
```

If you've been following along from home, you should have something similar to this.

![](../assets/images/2013/10/images/pingtool_02.png)

And now lets give it a try!

![](../assets/images/2013/10/images/pingtool_03.png) Mmmm, tasty progress.

Ah, the sweet taste of progress.  We now have a form and some code which works. Lets add a box where a user can specify the computer name to test, and then a button to start the test.

We'll be using the Systems.Windows.Forms.Label (Abbreviated as simply Forms.whatever from now on), Forms. TextBox and Forms.Button controls to add the rest of our app for now.  While I'm here, if you'd like a listing of all of the available other .net controls you can make use of, check out this link: [http://msdn.microsoft.com/en-us/library/system.windows.forms.aspx](http://msdn.microsoft.com/en-us/library/system.windows.forms.aspx)

First, lets add a label (a field of uneditable text), in which we will describe what this tool will do.  To start, instantiate a new System.Windows.Forms object of type .label, and then we'll set the location, size and text properties.  Finally, we'll add the control to our form using the .Add() method, as you'll see below.  Add the following text above the commented out Actual Code region.

```powershell
$label = New-Object System.Windows.Forms.Label 
$label.Location = New-Object System.Drawing.Size(5,5) 
$label.Size = New-Object System.Drawing.Size(240,30) 
$label.Text = "Type any computer name to test if it is on the network and can respond to ping" 
$Form.Controls.Add($label)
```
Some notes about this.  Location here is given in (x,y) with distances being pixels away from the upper left hand corner of the form.  Using this method of building a GUI from scratch, it is not uncommon to spend some time fiddling with the sizing by tweaking values and executing, back and forth.

![Note the #regions used to make editing our code a bit cleaner](../assets/images/2013/10/images/pingtool_04.png) 

Note the #regions used to make editing our code a bit cleaner

Lets save our script and see what happens!

![We are making a GUI interface using Visual Basi--er, PowerShell!](../assets/images/2013/10/images/pingtool_05.png) 

We are making a GUI interface using Visual Basi--er, PowerShell!

Alright, next, to throw a textbox on there and add a button to begin the ping test, add the following lines in the '#region begin to draw forms'.

```powershell
$textbox = New-Object System.Windows.Forms.TextBox 
$textbox.Location = New-Object System.Drawing.Size(5,40) 
$textbox.Size = New-Object System.Drawing.Size(120,20) 
$textbox.Text = "Select source PC:" $Form.Controls.Add($textbox)

$OKButton = New-Object System.Windows.Forms.Button 
$OKButton.Location = New-Object System.Drawing.Size(140,38) 
$OKButton.Size = New-Object System.Drawing.Size(75,23) 
$OKButton.Text = "OK" $OKButton.Add_Click($ping_computer_click)
$Form.Controls.Add($OKButton)

$result_label = New-Object System.Windows.Forms.label 
$result_label.Location = New-Object System.Drawing.Size(5,65) 
$result_label.Size = New-Object System.Drawing.Size(240,30) 
$result_label.Text = "Results will be listed here" 
$Form.Controls.Add($result_label)
```
At this point you may be noticing a whole lot of forms form forms.  I know, there is a lot of retyping the same things.  
>This is the inherent draw-back of Windows Forms GUIs, it is extremely verbose to create a UI.

Also, one thing I want to draw attention to is the `$OKButton.Add_Click` specifying this property will associate the contents of the `$ping_computer_click` variable (currently empty) as a function to execute when the button is clicked.  We'll go over that in a future post!

Before heading out, lets see what we have thus far.

![Seeing the UI come together is such a satisfying feeling](../assets/images/2013/10/images/pingtool_06.png) 

Seeing the UI come together is such a satisfying feeling

Alright, next time we reconvene, we'll link our pinging function from earlier into this tool, and see if it works!