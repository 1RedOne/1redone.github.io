---
title: "Get the daily forecast in your console, with PowerShell"
date: "2014-10-20"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

Today I saw a post on reddit about scraping a webpage for weather information. Reading over the comments, I had an idea, and I quickly looked away wanting to try this myself before seeing what someone else posted.

http://www.reddit.com/r/PowerShell/comments/2jitvn/help\_with\_screen\_scraping\_or\_interpreting\_web/

If you don't care about how this is done, skip to the bottom for the code, here is a preview of the finished product:

[![weather_00](https://foxdeploy.files.wordpress.com/2014/10/weather_00.png?w=660)](https://foxdeploy.files.wordpress.com/2014/10/weather_00.png) 

Reading the OP's question, he basically wanted to get a weather alert if it was going to rain. I thought this a nice goal, but expanded further to wanting to get certain weather information like the temp, forecast and wind speed, right in the console when I started it up.

Knowing that PowerShell has exceptional WebService and Remote API capabilities, I started my search trying to locate a web service out there somewhere with a nice REST or JSON API available to get my weather info from.  I read about ForeCast.IO, an open API made for weather applications, with a very reasonable price (free for up to 1,000 queries a day!) and quickly signed up.

### A note on APIs

One thing to keep in mind when setting up a tool like this is that you'll need to generally register for an account to use most APIs. Many places will provide these services free for the first 1,000 or 10,000 queries, but then charge you a pittance beyond that. Keep this in mind when sharing code about things like this. If someone has your API Key, they are effectively you. If they leave your script running on a loop constantly hammering an API somewhere, you can be on the hook for $100's.

**Don't give people your API key unless you'd feel safe giving them your physical or digital wallet.**

\[caption id="attachment\_873" align="alignnone" width="660"\]![weather_01](https://foxdeploy.files.wordpress.com/2014/10/weather_01.png?w=660) Make note of your API Key on this page.\[/caption\]

If you're OK with all of this,

Go to ForeCast.IO and sign up for an account then make note of the API key

Great, copy down your API and then hide it!

If we take a [look at the documentation](https://developer.forecast.io/docs/v2#forecast_call), we'll see that to make a call, we simply need to run a web request, subbing in certain values, and in response we'll get something back…

\[code language="java" light="true"\]https://api.forecast.io/forecast/APIKEY/LATITUDE,LONGITUDE\[/code\]

As stated above, we need to replace our API Key for the word APIKEY anywhere found in docs. We'll also need to substitute in the latitude and longitude. If you look at the example on the site, they give the following to get the weather in Alcatraz. I'm hiding my API Key in $API\_key

https://api.forecast.io/forecast/$API\_key/37.8267,-122.423

If you run Invoke-WebRequest, then convert From JSON, you'll have a nice PowerShell object.

\[caption id="attachment\_872" align="alignnone" width="660"\]![weather_02](https://foxdeploy.files.wordpress.com/2014/10/weather_02.png?w=660) Um, the weather looks to be very bad in Alkatraz. Let's cancel our vacation!\[/caption\]

Now, if you want to look up your own city, you can [get your latitude and longitude here](http://developer.mapquest.com/web/tools/lat-long-finder).

This all all well and good, except the time comes back in Unix time format, which measures ticks on the clock since January 1st, 1970, so you can convert that with the following PowerShell code.  I got this approach from [this answer from Keith Hill on StackOverflow](http://stackoverflow.com/questions/5779244/im-looking-for-a-powershell-function-to-convert-unix-time-to-string).

\[code language="powershell" light="true"\] \[TimeZone\]::CurrentTimeZone.ToLocalTime((\[datetime\]'1/1/1970').AddSeconds($weather.currently.time)) \[/code\]

So, after pulling out a little bit of data, I have the following code. This will get the current temp, weekly summary, and also play an alert sound if any weather alerts are encountered! Hope you enjoy it!

A preview picture of the finished product:

![weather_03](https://foxdeploy.files.wordpress.com/2014/10/weather_03.png?w=660)

\[code language="powershell"\] function Get-Weather{ param($city = "33.9533,-84.5406") $API\_key = "\*\*\*\*PUT YOUR APIKEY HERE\*\*\*\*\*\*" $url = "https://api.forecast.io/forecast/$APIkey/$city"

If

$weather = Invoke-WebRequest $url | ConvertFrom-Json

$ForeCastTime = \[TimeZone\]::CurrentTimeZone.ToLocalTime((\[datetime\]'1/1/1970').AddSeconds($weather.currently.time))

("The weather is generally " + $weather.currently.summary + " and currently " + $weather.currently.temperature + " degrees Fahrenheit at " + $ForeCastTime.DateTime) ("wind is gusting up to " + $weather.currently.windspeed + " m/PH with a chance of precipitation at " + $weather.currently.precipProbability) #it is currently 54.9 degrees Fahrenheit at Monday, October 20, 2014 10:23:11 AM

("The weekly forecast is " + (($weather.daily.summary) -creplace '\\?',"").ToLower())

("The following Weather alerts were found for the requested area") $weather.Alerts | % {write-host \`a; Write-host -ForegroundColor YELLOW $\_.Title Write-host -ForegroundColor Red $\_.Description}

#return a Global weather object for us to play with $Global:weather = $weather }

\[/code\]
