---
title: "My most useful 8 liner yet"
date: "2014-08-20"
categories: 
  - "sccm"
---

In my line of work, I'm constantly copying and pasting from e-mails, SharePoint, into PowerShell to do some meaningful work.  This means all day long I'm setting variables equal to paste, then removing blank entries, and then splitting them (because people never say 'please migrate these computers' and provide a list like $computers="compA","compB","compC".

I then end up Pasting, and running $variable= _Paste_, then $variable.Trim().Split("\`n").  I finally decided to speed things up by making this short little few-liner.  I always forgot whether it was Split-N-Trim or not, so I made an alias for the other way around.

It now has a permanent place within my $PSProfile

\[code language="powershell"\] Function Split-N-Trim { param( \[Parameter(Mandatory=$True,ValueFromPipeline=$True)\]\[string\[\]\]$Objects) Write-Host (&amp;quot;-Recieved &amp;quot; + $Objects.Count +&amp;quot; objects&amp;quot;) $Objects = $Objects.Trim().Split(&amp;quot;\`n&amp;quot;) Write-Host (&amp;quot;Returning &amp;quot; + $Objects.Count +&amp;quot; objects&amp;quot;) Return $Objects } new-alias Trim-N-Split Split-N-Trim

\[/code\]
