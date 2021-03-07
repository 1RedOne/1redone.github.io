---
title: "Working out Select-Object with Calculated Properties"
date: "2014-05-19"
categories: 
  - "scripting"
---

Hi all,

I learned of some interesting new abilities of the Select-Object command this week and wanted to share them with you.

For a client demerger operation, we're using the formerly Quest, now Dell Active Directory Management tools to replicate one AD Domain to another and then merge ACLs of files to ensure a smooth transition from Domain Old to Domain New.  One aspect of this task is a bit like herding cats, waiting for users to bring their computers online so that we can trigger the Quest Agent on their computer to rewrite the ACLs across the system, with the other half being behind the scenes ensuring that user inboxes are replicated from Exchange.Old to Exchange.Newness.  I wrote this simple tool to help our team track the IP addresses of user machines (as we're having a DNS issue as well...not our creation but our problem to solve), and whether or not the system is online.

Currently we're using a SharePoint site to track user and system association, and this process makes use of the 'Export to Excel' option.  On the next revision, this tool will be able to pull data from SharePoint directly, but I'm not quite there yet.

So, for the purposes of this demo, you'll need a .CSV file with Username, ComputerName, and the User's Physical location.  It should look something like this.  

 

| UserName | ComputerName | Location |
| --- | --- | --- |
| Lindsey O | bucky | Marietta GA |
| Steven A. | NotOnline | Italy |
| Paul A. | RaveBoi | Los Angeles |
| Nick M |  | Dallas GA |
| Me | localhost | Marietta GA |

Alright, so our table is made.  If you want a sample CSV, [use this link](https://www.dropbox.com/s/4t2fi3aiyx615lr/Migration.csv).  Now, we're going to make use of an interesting property that the Select-Object command has, in which we can specify a hashtable to define a column heading and expression for each column.  You can use this same formatting on Format-List or Format-Table, for what it's worth.  This behavior of using `@{Name='ColumnName'; Expression ={#ScriptBlock}}` is also referred to as a _Calculated Property._ 

In our example, we want to first Import-Csv our file with the values.  We then pipe it into our Select-Object command, and pull out our ComputerName, UserName,  and Location from the values provided.  Next, we'll use the Test-Connection commandlet to test if a computer is online and list if it is Reachable, using the -Quiet parameter to get output in True/False.  Finally, if we can ping our machine, we also want its IP address, pulling the IP Address from the Test-Connection command.

$comp \= import-csv .\\Migration.csv

for (;;){ 

 $comp | Select-Object @{Name\='ComputerName';Expression\={$\_.ComputerName}},\` @{Name\='User';Expression\={$\_.UserName}},\` @{Name\='Location';Expression\={$\_.Location}},\` @{Name\='Ipv4';Expression\={Test-Connection \-computername $\_.ComputerName \-count 1 | select \-ExpandProperty IPV4Address | select \-expand IPAddressToString }},\` @{Name\='Reachable';Expression\={Test-Connection \-computername $\_.ComputerName \-count 1 \-quiet}} | Format-Table timeout 90}

If you have a smaller number of computers, you can also define your object explicitly, and skirt the whole Import-CSV, using this useful Syntax.

$comp \= @( \[pscustomobject\]@{name\="Kevin B.";ComputerName\="AMAL-454";Location\="USA"}, \[pscustomobject\]@{name\="Kevin B.";ComputerName\="AMAL-433";Location\="USA"}, \[pscustomobject\]@{name\="Me";ComputerName\="localhost";Location\="USA"})

In either case, the output will be something along these lines.

User           ComputerName Location Ipv4 Reachable ----     \------------ \-------- \---- \--------- Lindsey O.     Bucky                       Marietta GA         192.168.2.198  True Steven A       NotOnline Italy   False Paul A.        RaveBoi Los Angeles  False Nick M         Akravator Dallas GA  False Me             localhost FoxDeployopia 127.0.0.1  True

 So, this was quite a quicky, but I hope these techniques help you out.  There is a ton of potential for cleverness with Calculated Properties.  If you come up with any, feel free to contact me.  I'll share it here with everyone and give you full credit.
