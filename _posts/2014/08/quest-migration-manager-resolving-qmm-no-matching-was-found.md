---
title: "Quest Migration Manager : 'Resolving QMM No Matching was found'"
date: "2014-08-22"
categories: 
  - "other"
---

If in Baretail (or your log file of choice) you see something similar to the following when attempting to Switch a mailbox.

![](https://foxdeploy.files.wordpress.com/2014/08/quest_nomatching.png)

Text:

Starting to process collection 'SPEEDITUP' (Source server 'FOXXC04', target server 'FOXDAG01', type '0'). Starting to process item '/o=Contoso/ou=Exchange Administrative Group ((01))/cn=Recipients/cn=Test.User' (Collection 'SPEEDITUP', PST: 'B5BDFEF890CD84439F04FC4B711E3E75186', SyncMailboxInfo: 'True', SyncSwitched: 'False', SyncAllContent: 'False', SyncFolderContent: 'False'). Retrieve info from RootDSE. Getting RootDSE Logging on to the mailbox '/o=Contoso/ou=Exchange Administrative Group ((01))/cn=Configuration/cn=Servers/cn=FOXXC04/cn=Microsoft System Attendant' (Server: 'FOXXC04', user: 'FOX\_adAD\_svc\_exqmm', has assocciated PFDB: 'False', connection flags = 32768). Trying to synchronize MAPI profile creation. Creating MAPI profile. Trying to logon. Trying to open private store. Trying to open address book. Setting search path. Setting cached Address lists. No matching was found for '/o=Contoso/ou=Exchange Administrative Group ((01))/cn=Recipients/cn=Test.User'. Please make sure that the user is migrated, the matching rules are correct, and the script components are functioning. Skipping collection 'Resource Calendar Mailboxes' because it is disabled. Skipping collection 'All Mailboxes' because it is disabled. No more items to process in this session. Logging off from the mailbox '/o=Contoso/ou=Exchange Administrative Group ((01))/cn=Configuration/cn=Servers/cn=FOXXC04/cn=Microsoft System Attendant' (Server: 'FOXXC04', user: 'FOX\_adAD\_svc\_exqmm'). Session has been stopped.

If you run into this issue, first verify that a Quest AD Account Migration Completed Successfully. If not, then verify that the Exchange Quest service has permission to the mailbox in the source by using the following PowerShell Commandlette

\[code language="powershell"\]

Function Fix-MailboxPerms { $ServiceQMMAccount = "foxdeploy\\\_svcQMM"

param(\[Alias("SamAccountName","DisplayName")\]\[Parameter(Mandatory=$True,ValueFromPipeline=$True,ValueFromPipelinebyPropertyName=$True)\]$UserName)

#if $UserName came from MailboxStatistics, give us the size if ($username.TotalitemSize){Write-Host (($UserName.TotalItemSize).Value.ToMB() ) "MB Mbx" } $username| get-mailbox | % { $user = $\_; "Setting AD Rights for object...$ServiceQMMAccount" $user | Add-ADPermission -User $ServiceQMMAccount -AccessRights GenericAll -ExtendedRights Receive-As,Send-As

"Setting Mailbox Permissions...$ServiceQMMAccount" $user | Add-MailboxPermission -User $ServiceQMMAccount -AccessRights FullAccess

}

} \[/code\]

If this still doesn't work, search in the Target Domain to verify that a mailbox exists for the user account. If not, this may signify that Calendar Sync agent isn't configured to run regularly (possibly indicating a new user account). You can quickly resolve the matter by Mail enabling the user's account in the target domain with the following syntax:

\[code language="powershell"\] Get-User Test.User1 | Enable-Mailbox -Database Region\_db01 \[/code\]

Once completed, run another AD Object migration session, and then watch Calendar Sync (CSA.log) or Mail Source Agent (EMWMSA.log) to see if the changes are noted. You can also directly compare attributes within AD from the source and target accounts.

You should see the LegacyExchangeDN for the Source Account listed as an x500 proxyAddress in the target account. You should also see the LegacyExchangeDN for the Target account listed as an x500 proxyAddress in the source account.

In no time, you should see the mailbox switch/sync/or whatever you were trying to do.
