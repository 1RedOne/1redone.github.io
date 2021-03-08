---
title: "PowerShelling FizzBuzz"
date: "2014-09-02"
redirect_from : /2014/09/02/powershelling-fizzbuzz
coverImage: ..\assets\images\foxPlaceHolder.webp
categories: 
  - "scripting"
tags: 
  - "powershell"
---

I recently learned about the FizzBuzz test, which is meant to help interviewers determine if a prospective hire can understand the fundamental logic needed to program.

The premise is this:

> Write a program that prints the numbers from 1 to 100. But for multiples of three print “Fizz” instead of the number and for the multiples of five print “Buzz”. For numbers which are multiples of both three and five print “FizzBuzz”.

I thought this sounded like a fun challenge, so I decided to try my hand at it.

At first, this seemed deceptively easy. Set up a For-Each loop with $num incrementing. If the number is divisibile by 3, then performing a modulo operation will result in a remainder of zero.

Perform the same if the number is divisble by five. Then write either Fizz or Buzz based on which was true.

However, if the number is divisible by BOTH, write out Fizzbuzz instead, and then proceed. The problem here was catching for the AND condition, very similar to a binary math operation. I eventually discarded my ForEach and instead used a While Loop, as the behavior of Continue and Break within a For loop lead to undesired outcomes.

Here is my answer:

```powershell
Function Start-FizzBuzz { 
  $num = 0 while ($num -lt 100) { 
    #-lt is shorthand for LessThan 
    $fizz = $false 
    $buzz = $false 
    $num++ 
    if (($num % 3) -eq 0) {
      $fizz = $true;
    } 
    if (($num % 5) -eq 0) {
      $buzz = $true;
    }

    if (($fizz) -and ($buzz)){ 
      "FIZZBUZZ" continue
       #continue tells PowerShell to continue on to the next object in series, and gets around a situation where we'd get output of FIZZ, BUZZ, FIZZBUZZ 
       }
    if ($fizz){
       "FIZZ" CONTINUE 
      } 
    if ($buzz){
    "BUZZ"
    CONTINUE 
    }
     $num 
     #if we didn't write Fizz, Buzz or FizzBuzz, write the number itself 
     }
  }


```
