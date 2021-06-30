---
title: "PowerShell, ConvertTo-StringData"
date: "2021-06-30"
redirect_from : 2021/06/30/powershell-convertto-string-data/
coverImage: \assets\images\2021\converttostringdata_hero.png
categories: 
  - "scripting"
tags: 
  - "StackOverflow"
  - "PowerShell"
excerpt: "Recently I saw an interesting scenario on Stack Overflow, where someone for their CI/DC pipeline needed a way to convert a rich JSON Object into a classic property=value stringdata type.  It seemed easy and kind of challenging, so I took a stab at it.  "
fileName: '2021-06-30-powershell-convertto-stringdata'
---
Sometimes at work I get bored, or I'm waiting for a huge project to build, or I need a quick diversion in a pomodoro but don't want to get sucked into Reddit or Twitter.

I pop open Stack Overflow to see if there are any interesting or unfairly shut-down questions.  This was one of those.

![Header for this post, reads 'ConvertingTo-StringData'](\assets\images\2021\converttostringdata_hero.png)

*Post Outline*

* Question
* This seems easy
* It seemed easy because I was wrong
* Maybe this is good enough?
* Can you do better?
  
## [How do I Convert this JSON to another format?](https://stackoverflow.com/questions/68180889/convert-json-data-to-property-format-using-powershell)

>I am working on one challenge which I am trying to solve, but due to lack of experience hit a roadblock. I would greatly appreciate any help from gurus on this site :)

>I need to convert JSON input to property format. Example: Given JSON:
```
{
  "name": "John",
  "age": 30,
  "married": true,
  "cars": [
    {"model": "BMW 230", "mpg": 27.5},
    {"model": "Ford Edge", "mpg": 24.1}
  ]}
  ```

>Need to be converted to following format once script executed:
```
name="John"
age=30
married=true
cars.0.model="BMW 230"
cars.0.mpg=27.5
cars.1.model="Ford Edge"
cars.1.mpg=24.1
```

## This seems easy

At first glance, it seemed easy peasey!  All I need to do is `ConvertFrom-Json` and then take a look at the NoteProperties and then write them out to screen in the right format!

```powershell
Function ConvertTo-StringData($object, $propertyOverride){
    $fields = $object | get-member -MemberType NoteProperty
    foreach($field in $fields){
        OutputMember -object $object -propertyName $field.name 
        }
    
}

Function OutputMember($object,$propertyName){
       "$($propertyName)=$($object.$($propertyName))"
}
```

Aw yeah, how great am I?  This will definitely work perfectly and with no further problems. 

```
ConvertTo-StringData $object
age=30
cars= 
married=true
name=John
```

Hmmm...that entry for Cars doesn't look right.

# It seemed easy because I was wrong

Ahh, I need to add some special handling for when a property had an array of values.

I've been living in c# for a long time now, so ugly methods like `IsArray()` now feel comfortable and good to me.  I'm terribly sorry and I won't be apologizing.

```
Function IsArray($object){
    $object.Definition -match '.*\[\].*'
}

Function ConvertTo-StringData($object, $propertyOverride){
    $fields = $object | get-member -MemberType NoteProperty
    foreach($field in $fields){
        if (IsArray($field)){
             OutputArrayMember -object $object -field $field
        }
        else{
            OutputMember -object $object -propertyName $field.name -propertyOverride $propertyOverride
        }
    }
}
```
This function will give me a true/false and can be used in an `if()` block to help me handle the properties the right way...now to test it and...

```
ConvertTo-StringData $object
age=30
model=BMW 230
mpg=27.5
model=Ford Edge
mpg=24.1
married=True
name=John
```
This is how I was starting to feel as the difficulties began to pile up.
![shows Sonic being stomped on by Styx in the Sonic Boom show](/assets/images/2021/convertToStringdata_sonicStomp.jfif)

OK, this is progress, as we're now gathering all of the properties at least.  All I needed to do from here was add some additional handling for when we drilled into a property to report the full property path.


# I know, let's use Recursion!
# Maybe this is good enough?

![shows Sonic and Tails from Sonic 2 in the Special 'HalfPipe' stage with the caption 'Cool' overlaid](/assets/images/2021/sonicCool.gif)


![shows Scourge from Sonic the Hedgehog comics, issue #195, with the text of 'Hail to the king, baby'](/assets/images/2021/scourgeKing.png)
## Can you do better?

Think you can do better?  I'll bet you can!  I didn't have enough time or a need to generate the perfect function for this problem, which would recursively step through all properties and handle every edge case, but what I made is probably good enough. 

If you can do better, I'll consider you a FoxDeploy hero...which will net you your name over on the right column of the site, AND some goodies...when I think of what to do!

![shows Sonic breakdancing](/assets/images/2021/sonicDance.gif)

This is what you'll be doing if you become a FoxDeploy Hero!

 - Final Link to gist
