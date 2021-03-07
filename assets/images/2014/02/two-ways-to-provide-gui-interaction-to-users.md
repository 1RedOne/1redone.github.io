---
title: "Two ways to provide GUI interaction to users"
date: "2014-02-17"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

![](http://foxdeploy.com/resources/learning-gui-toolmaking-series/)

**This post is part of the Learning GUI Toolmaking Series, here on FoxDeploy. Click the banner to return to the series jump page!**

* * *

In this blog post, I'll outline two methods you can use in your PowerShell scripts to provide GUI interactivity to your users, and allow them to select an object from a list.  These may not be the best method to achieve a goal, but are quick and simple enough that you can throw them in your scripts.

## Method One

First, the System.Windows.Forms .Net way of building a form.  In this case, we'll have a string $users, which will contain the results of an Active Directory Query to return all users with a name like 'Fox-\*', so Fox-01, Fox-07, and so on.  One thing that is tricky to many (I know it was to me!) when they first start using .net forms to build GUIs is that it can be hard to understand how to list dynamic content in a ComboBox or ListBox.

One thing to keep in mind when choosing between the two is that only a ListBox allows for the selection of more than one object.

![](http://foxdeploy.files.wordpress.com/2014/01/two_method_of_input_01.png) ListBox v. ComboBox - Bitter Enemies\[/caption\]

Assume we have a ListBox defined and added to our Form.  This is the code you'd need to do so.

``#Load system forms and drawing assemblies, Load with Partial allows us to Tab-Complete `#begin to draw list box $ListBox = New-Object System.Windows.Forms.ListBox $ListBox.Location = New-Object System.Drawing.Size(10,40) $ListBox.Size = New-Object System.Drawing.Size(160,20) $ListBox.Height = 80 $ListBox.Name = 'ListBox_UserName' $ListBox.SelectionMode = "MultiExtended"`

Note : in all of these examples, you could use a .ComboBox instead of a .ListBox and it would still work.

If we run this code in PowerShell and then pipe $ListBox to Get-Member, we'll see a number of interesting properties and methods available.  The one which will store the content happens to be titled .Items, to access the contents, check $ListBox.Items. The trick to adding Dynamic content (e.g. the results of a query or search) to your UI elements is to add each element to the $ListBox.Items Property using the .Add method, as seen below.

`$ListBox.Items.Add("Something we want to add") $ListBox.Items.Add("waffles")` For those of you following along at home, if you input $ListBox.Items, you'll see the following.

![](http://foxdeploy.files.wordpress.com/2014/01/two_method_of_input_02.png)

[caption id="" align="alignnone" width="295"]![](http://foxdeploy.files.wordpress.com/2014/01/two_method_of_input_02-5.png) Maybe it should say 'Something we want to eat'[/caption]

Now, that we know it is so easy to add items to a list or combo box, if we want to add the results of a query or function, we just use a ForEach function!

`#For each object within Users... $users| ForEach-Object{ #the [void] below adds this element to our form, but suppresses any output associated [void] $ListBox.Items.Add($_.Name) }`

Now, we'll jump ahead for a bit and assume you've built a form and added listeners for Enter and Escape (code available here).

If you run this in PowerShell, you'll see output similar to this.  In this lazy example, we'll depend on the user hitting Enter to leave the form.  If you want to add an okay button, I suppose that is acceptable as well.  Throw this bad boy into your code.

`#Set Properties for the Ok button $OKButton = New-Object System.Windows.Forms.Button $OKButton.Location = New-Object System.Drawing.Size(180,75) $OKButton.Size = New-Object System.Drawing.Size(75,23) $OKButton.Text = "OK" #What to do when the button is clicked, you can treat this like a function $OKButton.Add_Click({$Form.Close()}) #Add the button to our form $Form.Controls.Add($OKButton)`

You should be left with a result like this [[Link to code]](http://foxdeploy.com/code-and-scripts/new-listbox-wmultiselect/ "New-Listbox-wMultiSelect") and it will look like this.

![](http://foxdeploy.files.wordpress.com/2014/01/two_method_of_input_03.png)

If we need to access the objects selected, we can call $Listbox.SelectedItems to see all of the items that were selected.

So, this worked and was relatively simple.  But not that simple, and it really is quite a lot of code to do all this.  There is an easier method.

## Method Two

Sure, it’s a lot of fun to add all of this code to our scripts to create a GUI, but starting in PowerShell v3, a very powerful new ability was bestowed upon Out-GridView: the new -PassThru switch!

Lets recreate functionally the same tool, but using this new method.  Stretch your typing fingers, kiddies, its going to be quite a stretch!

$users = get-aduser -filter {Name -like "Fox-*"}

$x = $users | Select Name | Out-GridView -PassThru -Title 'Pick a user' | % {$_}

Surely that can't be it.  Lets just give it a try...

[caption id="" align="alignnone" width="375"]![](http://foxdeploy.files.wordpress.com/2014/01/two_method_of_input_04.png) No fliiping way![/caption]

And the objects are available for you to act on at the end as well, stored in $x.

I've sworn by the .Net method of building PowerShell tools for a long while now.  However, this new flexibility at least gives me some pause.

Readers: do you like posts like this?  The skies the limit to the complexity of UI we create in PowerShell.  If you'd like to see more, let me know!``
