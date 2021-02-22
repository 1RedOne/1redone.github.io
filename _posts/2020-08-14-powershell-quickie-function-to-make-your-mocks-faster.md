---
title: "PowerShell quickie - function to make your Mocks faster"
date: "2020-08-14"
header: "../assets/images/2020/08/images/quicker-auto-mocking-in-c.png"
layout: post
excerpt: "In C#, writing unit tests is king, and Moq is the hotness we use to Mock objects and methods, like the MockObjects we get with Pester in PowerShell."
tags: [powershell, mstest, moq, mocking]

---


![](../assets/images/2020/08/images/quicker-auto-mocking-in-c.png) In C#, writing unit tests is king, and Moq is the hotness we use to Mock objects and methods, like the MockObjects we get with Pester in PowerShell.

But one rough part of it is the syntax for Moq, which requires you to write a handler and specify each input argument, which can get pretty verbose and tiresome.
<!--more-->
To ease this up, try this function, which will take a method signature and convert it into a sample Mock.Setup or Mock.Verify block, ready for testing

{% gist 4f60a5739c40a7541006cce153fc4194 %}