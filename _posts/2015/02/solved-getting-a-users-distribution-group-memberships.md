---
title: "Solved: Getting a user's Distribution Group Memberships"
date: "2015-02-27"
categories: 
  - "scripting"
tags: 
  - "exchange"
  - "powershell"
---

It's surprisingly hard to get back a listing of all of a particular user's Exchange Distribution Group Memberships. The strange thing about this is that you can very easily get a list of all of a user's AD Security Groups using

\[code language="powershell" light="true"\]Get-ADPrincipalGroupMembership\[/code\]

. If this works for your purposes, great, but if what you really need is a report of all of a user's / mailbox or resource mailbox Distribution Group membership, I've come up with the following.

```powershell    get-distributiongroup | ForEach-Object { $groupName = $\_ Get-DistributionGroupMember -Identity $groupname.Name | ForEach-Object{ \[pscustomObject\]@{GroupName=$groupname;groupMember=$\_.Name} } } | Group-Object -Property GroupMember | Select-object Name, @{Name=‘Groups‘;Expression={$\_.Group.GroupName}} \[/code\]

Whoa! What's happening there?

Here's the walkthrough of why this works:

- We're getting a big list of all of the distribution groups
- for each, resolving the full membership of each group
- For every entity we discover who is a member of this group, we create a custom object of "username,groupname"
- Once this finishes, we send this to the Group-Object command to let it pick out every unique user
- Then gather all of their memberships using a calculated property
- We then can send this on to a CSV file, to get an output like this.

\[code\] #TYPE Selected.Microsoft.PowerShell.Commands.GroupInfo "Name","Groups" "Stephen","Group\_1 Group\_2 OtherFolks" "Lenna.Paprocki","Group\_2 OtherFolks" "James.Butt","Group\_2 OtherFolks" "Josephine.Darakjy","OtherFolks" \[/code\]

In my opinion, XML would be the best way to display this info, rather than a CSV. Additionally, it would be very cool to have a lighter weight cmdlet to return just the Distribution Group membership of one user. If I come up with this approach, I'll be sure to update this.

Hope you enjoy!
