---
title: "Impractical One-liner Challenge"
date: "2014-09-19"
categories: 
  - "scripting"
---

### Update

My thanks to Mike F. Robbins and others on reddit who pointed out that the command should be 'Select -ExpandProperty DistinguishedName', and not organizationalUnit.

### The Challenge

A colleague and I got into a competition earlier today. How could we display an Out-Gridview of all of a companies OU's, and then move a computer to the selected one in a single line of code.

We condensed our code down to the following two lines:

\[code language="powershell" light="true"\] $destinationOU =  Get-ADObject -Filter 'ObjectClass -eq "organizationalUnit"' | Select -ExpandProperty DistinguishedName -Unique | Out-Gridview -passthru

Get-Content .\\Computers.txt | Get-QADObject | Move-QADObject -NewParentContainer $destinationOU -whatif \[/code\]

The goal? Make it into a one-liner.

### GUIDELINES:

- Maintain the steps if possible.  Minimally acceptable solution:
    - Get user input for which OU
    - Get a list of computers and move them to the OU
- NO CHEATING WITH Semicolons or backticks Doing the below doesn't count
    
    \[code language="powershell" light="true"\]$ou = Out-Gridview;gc Computers.txt | Move-Computer $ou\[/code\]
    

Nope, sorry, try harder.

- Anything else goes!

Please comment here with your answers. I'll post my own within a few days.  Also, if you have any ideas for a future impractical One-Liner Challenge, let me know here, Twitter, or Reddit!
