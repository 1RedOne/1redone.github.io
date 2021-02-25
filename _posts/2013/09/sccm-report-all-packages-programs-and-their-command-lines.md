---
title: "SCCM Report - All Packages, Programs and their command lines"
date: "2013-09-19"
tags: 
  - "sccm"
  - "sql"
---

Hi all,

I recently had a requirement at a client to make a list of all SCCM Packages. their Programs,  and then the command lines of each, along with the package source.  I wondered if this was possible, and fortunately the SQL Views were already present to do so.

This ended up being a very short query: \[code language="sql"\]SELECT Program.PackageID, Package.Name 'Package Name', Program.ProgramName 'Program Name', Program.CommandLine, Program.Comment, Program.Description, Package.PkgSourcePath FROM \[v\_Program\] as Program LEFT JOIN v\_Package as Package on Package.PackageID = Program.PackageID</p> Order by Program.PackageID \[/code\] And the output  Some of these command lines were VERY long, so it came out a bit wide.:

[![apps and command lines - 1](images/apps-and-command-lines-1.png)](http://foxdeploy.files.wordpress.com/2013/09/apps-and-command-lines-1.png) [![apps and command lines - 2](images/apps-and-command-lines-21.png)](http://foxdeploy.files.wordpress.com/2013/09/apps-and-command-lines-21.png)
