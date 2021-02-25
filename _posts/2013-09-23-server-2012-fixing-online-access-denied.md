---
title: "Server 2012 : Fixing 'Online - Access Denied'"
date: "2013-09-23"
redirect_from : /2013/09/23/server-2012-fixing-online-access-denied
categories: 
  - "other"
tags: 
  - "2012r2"
---

Just a reminder, if you add a server to server manager and are getting 'Online - Access Denied', make sure that you've set the 'Manage As' credentials!  

Otherwise, your local account will be used to connect, which is unlikely to work in most cases.
