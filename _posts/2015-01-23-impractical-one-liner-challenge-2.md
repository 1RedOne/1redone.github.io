---
title: "Impractical One-liner Challenge #2"
date: "2015-01-23"
redirect_from : /2015/01/23/impractical-one-liner-challenge-2
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
tags: 
  - "impractical-one-liner-challenge"
  - "powershell"
---

It's back, your favorite Friday PowerShell diversion!

The get-date command has a useful method called GetDateTimeFormats() that lists all of the available date-time formats available on your system, suitable for you to find just the right date format to fit your needs.  However, actually using the output can be difficult, as you must use the following syntax, (Get-Date).GetDateTimeFormats()\[<index>\] and picking the right one from a huge non-numbered list can be challenging.

### Your Mission

Display all of the dateTime formats available, along with the index position of each in a graphical GUI user interface for the user to pick the format they desire, then use that selection to display a tip to the user on how to get that particular format.

### Rules

- Try to avoid using Semicolons.  If you have to use one, explain it.
- You are encourage to use backticks and PowerShell next-line detection (brackets, pipes) to wrap your code in to a readable one-liner
- Interpret GUI and 'display a tip' however you like
- No prizes, no whining!
