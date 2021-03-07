---
title: "Use Invoke-WebRequest to get your physical location"
date: "2014-10-23"
categories: 
  - "scripting"
tags: 
  - "powershell"
---

Hi all,

This is predominantly going to be a script sharing post.   I've got a fever for these APIs so expect to see me crank out a bunch of new cmdlettes in the next coming weeks.  I've already got one for finding a restaurant in your area using an awesome opentable-scraping API I found on heroku.  Anyway...send me requests, this is soo much fun!

Unlike my previous post, this API is totally free, so you can copy and paste and start using this code today!  Why did I want to do this?  Well in a conversation with a fellow redditor about a way to get Weather Info, he wondered how to do a GPS or geolocation lookup within the script, to have it update as he moved around.

I naturally had to see what I could do!

For this one, it all revolves around using hostIP.Info's free open API which determines relative user location based on the browser-agent resolved IP address.

This isn't going to be the most needle-pointed geolocation, but it's not half bad!   Note that if your users are running on a VPN or Proxy or in a cloud provider, the results for this will be all over the map.

#### Please correct me!

I'm also pretty sure I'm doing something dumb here.  I had to create this terrible series of Search-String, .Splits and -Joins here to make it work, and I'm certain there is an easier way to get these values that the API returns.  I've included a reference in the bottom comment of what an object looks like from this script, so please correct me!  Also, my nested values here breaks the syntax highlighting of WordPress.  Sorry.

Finally, this function is all switch based. That is, it accepts no parameterized input, but relies on Switches instead. I'd nevere seen another script written this way, so if no Switch is provided, it defaults to what I think is the most useful. As I've never seen this before, I'm not certain if there is a PowerShell-Best-Way of doing this.

\[code language="powershell"\] <# .Synopsis Use this Function to perform a lookup on API.HostIP.info which will tell you either the Country, City or GPS Coords .DESCRIPTION Use this Function in your other functions to perform a lookup on API.HostIP.info to obtain the physical location your script is running in .EXAMPLE Get-PhysicalLocation

#Default output is City >Atlanta GA .EXAMPLE Get-PhysicalLocation -coords | Get-Weather

#Get-PhysicalLocation will provide Custom Object with a Coords property, which will be cmdlet bound by Get-Weather, which will result in the weather forecast for the local area >The weather is generally Clear and currently 57.47 degrees Fahrenheit at Wednesday, October 22, 2014 8:15:08 PM wind is gusting up to 6.86 m/PH with a chance of precipitation at 0

The weekly forecast is drizzle on wednesday, with temperatures rising to 79f on monday. .NOTES This function is based on some very ugly regex XML parsing, as I couldn't figure out how to get PowerShell to properly recognize the namespace of the GML XML objects that were being returned. In a future version, I'd love to resolve this #> Function Get-PhysicalLocation { param (\[switch\]$Coords,\[switch\]$City,\[switch\]$CountryName,\[switch\]$CountryAbbrev )

#if no switches are specified, convert to $City mode if (($coords,$City,$CountryName,$CountryAbbrev) -notcontains $True){$City = $True}

if ($coords){

$coordinates = ((((\[xml\](invoke-webrequest http://api.hostip.info/ | select Content).Content).InnerXml -split ">" | select-string -Pattern "<gml:coordinates" -Context 1) -split "\`n")\[2\] -replace "</gml:coordinates",'').Trim() \[pscustomobject\]@{Coords=$coordinates.Split(',')\[1\],$coordinates.Split(',')\[0\]}

}

if ($City) {((((\[xml\](invoke-webrequest http://api.hostip.info/ | select Content).Content).InnerXml -split ">" | select-string -Pattern "<gml:name" -Context 1)\[1\] -Split "\`n")\[2\] -replace "</gml:name",'').Trim()}

if ($countryName){ ((((\[xml\](invoke-webrequest http://api.hostip.info/ | select Content).Content).InnerXml -split ">" | select-string -Pattern "<countryName" -Context 1) -Split "\`n")\[2\] -replace "</countryName","").Trim() }

if ($countryAbbrev){ ((((\[xml\](invoke-webrequest http://api.hostip.info/ | select Content).Content).InnerXml -split ">" | select-string -Pattern "<countryAbbrev" -Context 1) -Split "\`n")\[2\] -replace "</countryAbbrev","").Trim()

}

<# Refence of GML object for future verision <?xml version="1.0" encoding="ISO-8859-1" ?> <HostipLookupResultSet version="1.0.1" xmlns:gml="http://www.opengis.net/gml" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noN amespaceSchemaLocation="http://www.hostip.info/api/hostip-1.0.1.xsd"> <gml:description>This is the Hostip Lookup Service</gml:description> <gml:name>hostip</gml:name> <gml:boundedBy> <gml:Null>inapplicable</gml:Null> </gml:boundedBy> <gml:featureMember> <Hostip> <ip>216.183.126.166</ip> <gml:name>Atlanta, GA</gml:name> <countryName>UNITED STATES</countryName> <countryAbbrev>US</countryAbbrev> <!-- Co-ordinates are available as lng,lat --> <ipLocation> <gml:pointProperty> <gml:Point srsName="http://www.opengis.net/gml/srs/epsg.xml#4326"> <gml:coordinates>-84.4226,33.7629</gml:coordinates> </gml:Point> </gml:pointProperty> </ipLocation> </Hostip> </gml:featureMember> </HostipLookupResultSet>

#> }

\[/code\]
