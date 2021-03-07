---
title: "Migrating and transforming contact lists from OCS to Lync 2013 with PowerShell"
date: "2014-10-10"
categories: 
  - "scripting"
tags: 
  - "lync"
  - "powershell"
---

**Update:** You can get the functions referenced in this post [here](http://foxdeploy.com/functions/ocs-lync-functions/ "OCS Lync Functions").

* * *

Recently, I was given a very favorable task, which boiled down to something like this  "We need to migrate buddy lists from OCS 2007 to Lync 2013 and handle thousands of changes to e-mail addresses/sip address and domain names in the process".

I turned to the only resource about this on the internet, the following 200-word blog post, in Spanish.

[http://uclavecchia.wordpress.com/2013/03/06/exportar-contatos-ocslync2010-e-importar-no-lync-2013/](http://uclavecchia.wordpress.com/2013/03/06/exportar-contatos-ocslync2010-e-importar-no-lync-2013/)

## **I feel that I should probably stop you here and say Warning!  This is not at all supported!**

In my situation, here were the requirements:

- Condense from multiple regional OCS servers to one global Lync server
- Export buddy lists or contact lists from all users
- Replace mentions of domainOLD.domain.com with domain.com
    - Only enact the above replaces on a group of pilot users
- Create the framework to update all user's logins and buddy lists from domainold.domain.com
- Finally, note that many users are switching from having nonstandard and cute logins to OCS to using their AD E-Mail address attribute

The above requirements should make it obvious why certain logic was implemented in the tools I created here.

First off, how do I get the Buddy list data out from OCS 2007?  Well, the install files for OCS Server included in the support directory a very useful tool called dbimpexp.exe, which is used to import and export contacts from OCS in an XML file format.  You can take this file and eventually import it into Lync server using the Import-CSUserData or Update-CSUserData.  The difference between the two is that Import is destructive while Update will append and update contacts.

Now, I've created some tools to make this less painful, but here is the manual process:

1. Connect to every OCS server, run the following: dbimpexp.exe /hrxmlfile:FileName.xml /sqlserver:<FQDN\_of\_sqlServer>.
    1. Copy these XML files to a central place with access to the Lync Cmdlets.
2. Make changes to the XML files as needed in conjunction with your requirements.
3. Enable all users for whom the buddy lists should be imported in Lync 2013.
4. On the Lync Server, run Convert-CsUserData on each of the import.Xml files, specifying -TargetVersion Current.
5. Run Update-CsUserData or Import-CsUserData as needed for each user to be enabled:
    
    \[code lang="powershell" light="true"\]import-csuserdata -Filename $importFile -UserFilter $user.Mail -poolfqdn <lyncPoolFQDN> -verbose\[/code\]
    

I've mentioned that this can be super manual, and it totally is….unless you've made some tools!  Which I have.  So, here is the tool assisted version of the above steps.

1. ### Connect to every OCS server, export files and copy
    
    This is still manual.  Sorry
2. ### Make changes to the XML files as needed in conjunction with your requirements
    
    If you need to make changes to user names during migration do this step, if not, proceed to Step 3!
    
    I've created the Update-OCSXML function found in the following list of functions to help with this task. 
    
    Update-OCSXml This function expects five inputs:
    
    $BuddyListFile, which should be the path to one of the XML files you got in step one $NameMatchingFile should be the path to a CSV file which should contain at least three columns, one for user's existing name, one for the user's desired name, and one for the users UPN or SAM name specified as Name $SourceColumn should be the name of the column with the user's old name $TargetColumn should be the name of the column with user's new name $OutFile should contain the desired output file name (Will automatically output to the current directory with the BaseName of the file specified in $NameMatchingFile + .xml)
    
    To understand what the code is doing, the $BuddyListFile is read into memory using a StringBuilder (which is mutable = fast!), then for every item found in the $NameMatchingFile, all entries of $\_.SourceColumn are swapped for $\_.TargetColumn.  In the final rows, there is a commented out function which can be used to make a sweeping change of the entire list, if needed.
    
    For my scenario, I needed to enable pilot users, and process their friend's lists to only change the sipaddress for their contacts which were also in the pilot list.  To reiterate, only if someone was found within the $NameMatchingFile did their entries get changed.
    
    When we roll production with this, I'll activate the final row as a catch all to swap all mentions of olddomain for newdomain.
3. ### Enable all users for whom the buddy lists should be imported in Lync 2013
    
    To make this easier, I made a wrapper around Enable-CSAduser which can import from the same $NameMatchingFile used above, to enable only those whose buddy lists have changed.
    
    Enable-OCSPilotUsers This function expect the following input:
    
    $UserList (or $NameMatchingFile) which is the same CSV used above $NameColumn which is the name of the column containing the user's name in the above CSV $SIPDomain which should be pretty obvious, the Lync 2013 SIP Domain in which to enable $RegistrarPool, which is the pool to register against
    
    Again, this function really helped me in my constantly shifting pilot testing, but you might be able to bypass this if flash-cutting your whole environment.
4. ### On the Lync Server, run Convert-CsUserData on each of the import.Xml files, specifying -TargetVersion Current
    
    An interesting thing about Lync's processing of these import.xml files is that it will cull through these massive files and return much smaller zipped files containing user's buddy lists, but it will **only extract values for currently enabled users** in Lync 2013.You could just run Convert-CsUserData over and over for each file, or you could use the function I made, Reprocess-OCSBuddyList, which will search for all .xml files of the naming convention created by my above tool (Updated\*.xml) and then import and process them.
    
    This is a VERY NOISY process, as you'll get warning output for each user skipped, and error output for every user who was not enabled.  To stifle this, I'm terribly setting WarningAction and ErrorAction to SilentlyContinue.
5. ### Run Update-CsUserData or Import-CsUserData as needed for each user to be enabled:
    
    Again, using the same $UserList or $NameMatchingFile used in the above files, you can use the Update or Import OCSBuddyList.  You can also specify -Recurse to attempt to import every discovered Updated\*contactsExport.zip file into every user.  I had to do this because some of my user's had been migrated from region to region and I couldn't always trust the output of the user's contacts to be up to date.
    
    At this step, you should now instruct your users to log off of the old OCS server, and reconnect to the new Lync server.

 

So, that should take you through exporting contacts from OCS, modifying them however you need to, and then importing them into Lync 2013, all with Pilot group test-ability.  Here are some caveats:

- Your pilot group will be able to message the remainder or production users and see their Free/Busy status as normal.  However, all production users will need to re-add the pilot users to their friend's lists to message them.  Otherwise, they'll see the pilot user's as offline (which they will be, since they'll be logged into the new environment)
- Sometimes user's won't see changes to their buddy list until they log off and log back on to Lync/OCS.  I'm not sure why the changes to the list aren't immediately visible.
- This stuff can become very, very confusing.

Feel free to contact me if you have any questions about how to use these tools, or need help understanding this process.
