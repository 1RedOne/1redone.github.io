---
title: "What's going on with the Windows Network Connection Status Icon?"
date: "2013-09-26"
categories: 
  - "quickies"
---

Ever wonder where this little guy gets its information from, be it happy or sad?

<table border="1" cellspacing="0" cellpadding="0"><tbody><tr><td>&nbsp;<a href="http://foxdeploy.files.wordpress.com/2013/09/ncsi-11.png"><img src="images/ncsi-11.png" alt="NCSI-1" width="22" height="27"></a></td><td>Sad LAN Connection</td></tr><tr><td>&nbsp;<a href="http://foxdeploy.files.wordpress.com/2013/09/ncsi-21.png"><img src="images/ncsi-21.png" alt="NCSI-2" width="25" height="27"></a></td><td>Happy LAN Connection</td></tr><tr><td>&nbsp;<a href="http://foxdeploy.files.wordpress.com/2013/09/ncsi-31.png"><img src="images/ncsi-31.png" alt="NCSI-3" width="23" height="27"></a></td><td>Sad Wi-Fi Connection</td></tr><tr><td>&nbsp;<a href="http://foxdeploy.files.wordpress.com/2013/09/ncsi-42.png"><img src="images/ncsi-42.png" alt="NCSI-4" width="23" height="27"></a></td><td>Happy Wi-Fi Connection</td></tr></tbody></table>

Essentially, a task runs whenever a network configuration change event takes place.  This calls a service which first tries to NSLookup [www.msftncsi.com](http://www.msftncsi.com), the Microsoft Network Connection Status Indicator site.  If this is successful, it then performs an HTTP GET on a simple text file stored on this site.

If these two steps work, it proves that DNS, Routing, and HTTP traffic are all allowed and working.

Now, if you're on a system that can access certain sites explicitly, like Updates.Microsoft.com then you may still a see a status icon of disconnected, even if your system can get out to the general web.  This might be because msftncsi.com remains blocked.

So, the icon is a great indicator of whether or not you have web access for most cases, but not necessarily in high security environments.

Source : [http://blogs.technet.com/b/networking/archive/2012/12/20/the-network-connection-status-icon.aspx](http://blogs.technet.com/b/networking/archive/2012/12/20/the-network-connection-status-icon.aspx)
