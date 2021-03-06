---
title: "Class is in Session: PowerShell Classes"
date: "2016-11-22"
categories: 
  - "scripting"
---

![ClassesInPowerShellGraphic](images/news.png)

PowerShell has been mostly complete for you and me, the ops guys, for a while now. But for Developers, important features were missing.

One of those features were Classes, a important development concept which probably feels a bit foreign to a lot of my readers. For me, I'd been struggling with classes for a long time. Ever since Middle School. #DadJokeLol.

In this post, I'll cover my own journey from WhatIsGoingOnDog to 'Huh, I might have something that resembles a clue now'.

I'll cover what Classes are, why you might want to use them, and finally show a real-world example.

### What the heck are Classes?

If you've been scripting for a while, you're probably very accustomed to making CustomObjects. For instance, I make Objects ALL the file that contain a subset of properties from a file. I'll commonly select a File's Name, convert it's size into KB, and then display the LastWriteTime in days.

Why, because I want to, that's why! It normally looks like this.

```powershell

#code go here!

$file = Get-Item R:\\Dan\_Hibiki.jpg

##Using Calculated Properties $file | Select-Object Name, @{Label='Size(KB)';Expression={\[int\]($\_.Length / 1kb)}},\` @{Label='Age';Expression={\[int\]((get-date)-($\_.LastWriteTime)).Days}}

##Instantiating a custom object \[pscustomobject\]@{Name=$file.Name 'Size(KB)'=\[int\]($file.Length / 1kb) 'Age'=\[int\]((get-date)-($file.LastWriteTime)).Days }

Name Size(KB) Age ---- -------- --- Dan\_Hibiki.jpg 38 1053 \[/code\]

This is fine for one off usage in your code, but when you're building something bigger than a one-liner, bigger even than a function, you can end up having a lot of your code consumed with repetition.

The bad thing about having a lot of repetition in your code is that you don't just have one spot to make a change...instead, you can end up making the same change over, and over again! This makes it REALLY time-consuming when you realize that you missed a property, or need to add an extra column to your output. A minor tweak to output generates a lot of work effort in cleaning things up.

### What problems do they solve?

From an operations / scripting perspective: **Classes let us save a template for a custom object**. They have other capabilities, true, but for our needs, understanding this use case will make things much easier.

Most of your day to day scripts will not need Classes. In fact, only very complex and advanced modules _really_ make sense as a use cases for Classes. But it's a good idea to know how to use them, so you'll be prepared when the opportunity arises.

#### Where can I use Classes?

Keep this in mind, PowerShell Classes are a v5.0 Feature. If you're writing scripts that target machines running Server 2003 or Vista, you'll not be able to use Classes with this syntax we'll cover here.

###### What If I need classes on an older machine?

If you REALLY need classes on WMF 4 or earlier machines, you can access them using Add-Type. For an example, [check out the answers here on this post from StackOverflow](http://stackoverflow.com/questions/59819/how-do-i-create-a-custom-type-in-powershell-for-my-scripts-to-use).

#### Surprise! You've been using Classes all along! Kind of.

It's easy to get started with classes. In fact, you're probably used to working with them in PowerShell. For instance, if you've ever rounded a number in PowerShell, you've used the `[Math]` class, which has many helpful operations available.

```powershell

$pi = 3.14159 \[Math\]::Round($pi,2) 3.14

\[Math\]::Abs(-1234) 1234\[/code\]

Wondering about the double colon there? No, I'm not referring to the delicious chocolatey stuffed Colon candy, either.



What we're doing there is calling a Static Method.

#### Methods: Instance versus Static Methods

Normally when we call methods, we're used to doing something like this.

```powershell

$date = Get-Date $date.AddDays(7) \[/code\]

In this process, we're calling Get-Date, which instantiates (which makes an instance of) an object of the DateTime class.

As soon as we go from the high level description of the class to an actual object of that class (also called an instance), it get's its own properties and methods, which pertain to this instance of the class. For this reason, the methods we get from instantiating an instance of a class is referred to as _Instance Methods_.

Conversely, when a class is loaded into memory, its methods are always available, and they also cannot be changed without reloading the class. They're immutable, or static, and you don't need to call an instance of the class to get them. They're known as _Static Methods_.

For example, if I want to round a number I just run

```powershell

\[Math\]::Round(3.14141,2) >3.14 \[/code\]

I don't have to make an instance of it first, like this.

```powershell #What we won't do $math = new-object -TypeName System.Math

\>new-object : A constructor was not found. Cannot find an appropriate constructor for type System.Math. \[/code\]

This error message of 'No constructor is telling us that we are not meant to try an make an object out of it. We're doing it wrong!

##### Making a FoxFile class

Defining a class is easy! It involves using a new keyword, like `Function` or `Resource`. In this case, the keyword is `Class`. We then splat down some squiggles and we're done.

```powershell

Class FoxFile

{

#Values you want it to have (you could allow arrays, int, etc) \[string\]$Name \[string\]$Size \[string\]$Age

#EndOfClass } \[/code\]

Breaking this down, at the start, we call the keyword of `Class` to prime PowerShell on how to interpret the following script block. Next, I define the values I want my object to have.

If I run this as it is...I don't get much out of it.

```powershell PS > \[FoxFile\]

IsPublic IsSerial Name BaseType -------- -------- ---- -------- True False FoxFile System.Object \[/code\]

However, using Tab Expansion, I see that I have a StaticMethod of `New()` available. For free! If I run it, I get a new FoxFile object, but it doesn't have anything defined.

```powershell PS > \[FoxFile\]::new()

Name Size Age ---- ---- --- \[/code\]

Not super useful...however because I didn't add any instructions or bindings to it. Let's go a little bit deeper.

##### Getting Fancy, adding a method to my Class

Adding a method is pretty easy. It can be thought of as defining a mini-function within our Class, and it basically looks exactly like a mini-cmdlet. A cmdletlett. Com-omelete. Mmm...omelet.

Going back to our class definition before, all we do is add a few lines of space and add the following:

```powershell FoxFile ($file)

{$this.Name = $file.Name $this.size = $file.Length /1kb $this.Age = \[int\]((get-date)-($file.LastWriteTime)).Days } \[/code\]

##### $This weird variable

When we're working with classes, we're dealing with the special snow-flake vegetable, `$this`. In the above, we're defining what happens when someone calls the new method.

We've already defined the properties we want this class to have, so we're setting them here. We provide for one parameter which we'll call `$file`, and then we map the Name property to what's parsed in.

We do the same for `.Size` and `.Age` as well.

Now, let's reload into memory...

```powershell Class FoxFile

{

\[string\]$Name \[string\]$Size \[string\]$Age

#define our constructor (our ::New method) FoxFile ($file)

{$this.Name = $file.Name $this.size = $file.Length /1kb $this.Age = \[int\]((get-date)-($file.LastWriteTime)).Days }

} \[/code\]

And let's see what happens when I run this on a file.

```powershell

$a = Get-Item .\\Something.ps1xml

PS C:\\Users\\Stephen> \[FoxFile\]::new($a)

Name Size Age ---- ---- --- Something.ps1xml 1.09 121 \[/code\]

Yay it worked!!! But I feel like the elements of this are in my head, however, they're not quite crystalized yet...

Let's add a Crystal method!

```powershell Crystal ()

{start https://youtu.be/hfUSyoJcbxU?t=45} \[/code\]

Finally, to test it out, run the following.

```powershell $a = \[FoxFile\]::((Get-item .\\Somefile.tla)) $a.Crystal() \[/code\]

And that's pretty much it.  You can get very deep with Classes, for instance, I wrote an example, available here, of a VirtualMachine class you could use in Hyper-V, which is capable of creating a new VM.  In a lot of use cases, I might instead just write a module with a few PowerShell functions to handle the tasks of many methods for a class, but it's always good to know how to use the tools in your toolbag.

https://gist.github.com/f69cc02763dbd5cf2077b04939d23914

##### Resources

One of the greatest things about PowerShell is the incredible community and repository of resources available to us.

Want a deeper dive than this? Checkout some of these resources here:

I was greatly helped by [Ed Wilson's awesome blog series on the topic here](https://blogs.technet.microsoft.com/heyscriptingguy/tag/classes/).

Additionally, Trevor made a [good video series on classes here](https://channel9.msdn.com/Search?term=trevor%20sullivan%20classes#lang-en=en&ch9Search)!

Finally, [the wonderful writing of $Somedude here](http://www.homeandlearn.co.uk/NET/nets11p2.html) really helped me as well.
