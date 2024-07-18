---
title: "KQL Quickie - Human Readable day of the week"
date: "2024-07-17"
redirect_from : 2024/07/17/kql-quickie-human-readable-day-of-week
coverImage: \assets\images\2024\kqlHumanReadable.webp
categories: 
  - "querying"
tags: 
 - "queries" 
 - "kusto" 
excerpt: "Have you ever needed to do complex automation in Azure Devops?  Like retrieving a token for one service and handing it off to subsequent commands to use?  Then you might have been puzzled about the correct syntax to use.  In this post, I'll give you a working example of how the syntax should be used to hand variables between bash and PowerShell tasks in Azure Devops"
fileName: '2024-06-16-how-to-pass-variables-between-azure-devops-bash-and-powershell-commands'
---
Ever need to figure out which day of the week something happened, and you're using an r or ADX like querying language?  

Many of these offer a `dayofweek` function, but in many cases, these will give you a timespan interval since the previous Sunday.  I don't know about you, but for me, it's very hard to just look at `1.00:00:00` and think "Oh yeah thats a Monday!

![Header for this post, reads 'Handing off variables in ADO'](\assets\images\2024\kqlHumanReadable.webp)

## The query

Here is, short and sweet.

```kql
let weekday = (day:int) {        
        case(
        day == time(1.00:00:00), "Mon",
        day == time(2.00:00:00), "Tue",
        day == time(3.00:00:00), "Wed",
        day == time(4.00:00:00), "Thu",
        day == time(5.00:00:00), "Fri",
        day == time(6.00:00:00), "Sat",
        "Sun")
    };
    print weekday(1d);   
```

Result:

>Mon


And a full working example

```kql
let weekday = (day:int) {        
        case(
        day == time(1.00:00:00), "Mon",
        day == time(2.00:00:00), "Tue",
        day == time(3.00:00:00), "Wed",
        day == time(4.00:00:00), "Thu",
        day == time(5.00:00:00), "Fri",
        day == time(6.00:00:00), "Sat",
        "Sun")
    };    
   range input from 0d to -6d step -1d
   | extend AsDate = ago(input)
   | extend AsWeekDayInt = dayofweek(AsDate)
   | extend AsDayOfWeek = weekday(AsWeekDayInt)
```

Result:

![Header for this post, reads 'Handing off variables in ADO'](\assets\images\2024\weekDayResults.png)